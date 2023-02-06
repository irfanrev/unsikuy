import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unsikuy_app/app/controllers/auth_controller.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class DiscussionController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController commentC = TextEditingController();
  final TextEditingController searchC = TextEditingController();
  final TextEditingController reportC = TextEditingController();
  final authC = Get.find<AuthController>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var photoUrl;
  var username;
  var uuidUser;
  var postID;
  var status;
  var bio;
  var isVerify;
  var isSearch = false.obs;
  var isConnecters;
  var getResult;
  var parsingStatus = ''.obs;

  RxBool liked = false.obs;
  RxInt tag = 0.obs;
  List<String> tags = [];
  List<String> options = [
    'Spam',
    'Plagiarism',
    'Inappropriate',
  ];

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
    isVerify = userData['isVerify'];
    uuidUser = currentUser.uid.toString();
  }

  Future sendEmail(String sharingName, String sharingId) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final body = jsonEncode({
      'service_id': 'service_sd6r46w',
      'template_id': 'template_xbrcknn',
      'user_id': 'S27fCFKeMjxIkuHK4',
      'template_params': {
        'user_name': username,
        'user_email': auth.currentUser!.email,
        'user_subject': 'REPORT UNSIKA CONNECT',
        'user_message': reportC.text,
        'sharing_username': sharingName,
        'sharing_text': sharingId,
      }
    });
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: body,
    );
    print(response.body);
    reportC.clear();
    showNotif('Report Success', 'Report has sended!');
    Get.back();
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

  Future<void> likeContribution(String postId, String uuid, List like,
      String friendUuid, String commentId) async {
    try {
      if (like.contains(uuid)) {
        await _firestore
            .collection('discussion')
            .doc(postId)
            .collection('contribution')
            .doc(commentId)
            .update({
          "like": FieldValue.arrayRemove([uuid]),
        });
      } else {
        await _firestore
            .collection('discussion')
            .doc(postId)
            .collection('contribution')
            .doc(commentId)
            .update({
          "like": FieldValue.arrayUnion([uuid]),
        });
      }
      DocumentSnapshot docSnap = await FirebaseFirestore.instance
          .collection('userToken')
          .doc(uuid)
          .get();
      String mToken = docSnap['token'];
      authC.sendPustNotification(mToken, '', '$username like your comment');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> dislikeContribution(String postId, String uuid, List dislike,
      String friendUuid, String commentId) async {
    try {
      if (dislike.contains(uuid)) {
        await _firestore
            .collection('discussion')
            .doc(postId)
            .collection('contribution')
            .doc(commentId)
            .update({
          "dislike": FieldValue.arrayRemove([uuid]),
        });
      } else {
        await _firestore
            .collection('discussion')
            .doc(postId)
            .collection('contribution')
            .doc(commentId)
            .update({
          "dislike": FieldValue.arrayUnion([uuid]),
        });
      }
      DocumentSnapshot docSnap = await FirebaseFirestore.instance
          .collection('userToken')
          .doc(uuid)
          .get();
      String mToken = docSnap['token'];
      authC.sendPustNotification(mToken, '', '$username dislike your comment');
    } catch (e) {
      print(e.toString());
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
          "isVerify": isVerify,
          "published_at": DateTime.now().toString(),
          "postId": postId,
          "like": [],
          "dislike": [],
        });
        DocumentSnapshot docSnap = await FirebaseFirestore.instance
            .collection('userToken')
            .doc(uuid)
            .get();
        String mToken = docSnap['token'];
        authC.sendPustNotification(
            mToken, commentC.text, '$username Comment your Discussion');
        String notifId = Uuid().v1();
        await _firestore
            .collection('users')
            .doc(uuid)
            .collection('notification')
            .doc(notifId)
            .set({
          'username': username,
          'photoUrl': photoUrl,
          'title': '$username contribute to your discussion',
          'body': commentC.text,
          'time': DateTime.now().toString(),
          'notifId': notifId,
        });
        commentC.clear();
        // showNotif('Success', 'Comment is posted');

      } else {
        showError('Text is empty', 'Please enter your comment below');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> postReplyComment(
      String postId, String uuid, String commentId) async {
    try {
      if (commentC.text.isNotEmpty) {
        String replyId = const Uuid().v1();
        await _firestore
            .collection('discussion')
            .doc(postId)
            .collection('contribution')
            .doc(commentId)
            .collection('reply')
            .doc(replyId)
            .set({
          "profilePict": photoUrl,
          "username": username,
          "uuid": uuidUser,
          "text": commentC.text,
          "commentId": commentId,
          "isVerify": isVerify,
          "published_at": DateTime.now().toString(),
          "postId": postId,
          "replyId": replyId,
        });
        DocumentSnapshot docSnap = await FirebaseFirestore.instance
            .collection('userToken')
            .doc(uuid)
            .get();
        String mToken = docSnap['token'];
        authC.sendPustNotification(mToken, commentC.text.toString(),
            '$username reply your contribution');
        String notifId = Uuid().v1();
        await _firestore
            .collection('users')
            .doc(uuid)
            .collection('notification')
            .doc(notifId)
            .set({
          'username': username,
          'photoUrl': photoUrl,
          'title': '$username reply your contribution',
          'body': commentC.text,
          'time': DateTime.now().toString(),
          'notifId': notifId,
        });
        commentC.text = '';
        // showNotif('Success', 'Comment is posted');
      } else {
        showError('Text is empty', 'Please enter your comment below');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteReply(
      String postId, String commentId, String replyId) async {
    try {
      await _firestore
          .collection('discussion')
          .doc(postId)
          .collection('contribution')
          .doc(commentId)
          .collection('reply')
          .doc(replyId)
          .delete();
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
