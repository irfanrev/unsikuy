import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unsikuy_app/app/controllers/auth_controller.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:uuid/uuid.dart';

class DiscussionController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController commentC = TextEditingController();
  final TextEditingController searchC = TextEditingController();
  final authC = Get.find<AuthController>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var photoUrl;
  var username;
  var uuidUser;
  var postID;
  var status;
  var bio;
  var isSearch = false.obs;
  var isConnecters;
  var getResult;
  var parsingStatus = ''.obs;

  RxBool liked = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getUsersData();

    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    searchC.clear();
    super.onClose();
  }

  Future getUsersData() async {
    User currentUser = auth.currentUser!;

    DocumentSnapshot userData =
        await _firestore.collection('users').doc(currentUser.uid).get();

    photoUrl = userData['photoUrl'];
    username = userData['username'];
    status = userData['status'];
    bio = userData['bio'];
    uuidUser = currentUser.uid.toString();
  }

  Future<void> deleteDiscussion(String postId) async {
    try {
      await _firestore.collection('discussion').doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteContribution(String postId, String commentId) async {
    try {
      await _firestore
          .collection('discussion')
          .doc(postId)
          .collection('contribution')
          .doc(commentId)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> postDiscussion(String postId, String uuid) async {
    try {
      if (commentC.text.isNotEmpty) {
        String conId = const Uuid().v1();
        await _firestore
            .collection('discussion')
            .doc(postId)
            .collection('contribution')
            .doc(conId)
            .set({
          "profilePict": photoUrl,
          "username": username,
          "uuid": uuidUser,
          "text": commentC.text,
          "commentId": conId,
          "published_at": DateTime.now().toString(),
        });
        DocumentSnapshot docSnap = await FirebaseFirestore.instance
            .collection('userToken')
            .doc(uuid)
            .get();
        String mToken = docSnap['token'];
        authC.sendPustNotification(
            mToken, commentC.text, '$username Comment your Discussion');
        // showNotif('Success', 'Comment is posted');
      } else {
        showError('Text is empty', 'Please enter your comment below');
      }
    } catch (e) {
      print(e);
    }
  }
}

showError(String title, String message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: AppColors.error,
    colorText: AppColors.white,
  );
}

void dismissloading(bool? skip) {
  Get.defaultDialog(
    barrierDismissible: skip ?? true,
    content: CircularProgressIndicator(
      color: AppColors.primaryLight,
    ),
  );
}

void showNotif(String title, String message) {
  Get.snackbar(title, message.toString(),
      backgroundColor: AppColors.successMain, colorText: Colors.white);
}
