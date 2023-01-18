import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:uuid/uuid.dart';

class PostController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController commentC = TextEditingController();
  var photoUrl;
  var username;
  var uuidUser;
  var postID;
  var status;
  var bio;

  RxBool liked = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getUsersData();

    super.onInit();
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

  Future<void> likePost(String postId, String uuid, List like) async {
    try {
      if (like.contains(uuid)) {
        await _firestore.collection('posts').doc(postId).update({
          "like": FieldValue.arrayRemove([uuid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          "like": FieldValue.arrayUnion([uuid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postId) async {
    try {
      if (commentC.text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          "profilePict": photoUrl,
          "username": username,
          "uuid": uuidUser,
          "text": commentC.text,
          "commentId": commentId,
          "published_at": DateTime.now().toString(),
        });
        // showNotif('Success', 'Comment is posted');
      } else {
        showError('Text is empty', 'Please enter your comment below');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> connectUser(String uuid, String friendName, String email,
      String friendPhoto, String friendStatus, String friendBio) async {
    try {
      CollectionReference users = _firestore.collection('users');
      // DocumentSnapshot snap =
      //     await _firestore.collection('users').doc(uuid).get();
      // List connecters = (snap.data()! as dynamic)['connecters'];
      // if (connecters.contains(connectId)) {
      //   await _firestore.collection('users').doc(connectId).update({
      //     'connecters': FieldValue.arrayRemove([uuid])
      //   });
      //   await _firestore.collection('users').doc(uuid).update({
      //     'connecters': FieldValue.arrayRemove([connectId])
      //   });
      // } else {
      //   await _firestore.collection('users').doc(connectId).update({
      //     'connecters': FieldValue.arrayUnion([uuid])
      //   });
      //   await _firestore.collection('users').doc(uuid).update({
      //     'connecters': FieldValue.arrayUnion([connectId])
      //   });
      // }

      final isConnected = await users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('connected')
          .where('email', isEqualTo: email)
          .get();

      await users
          .doc(uuid)
          .collection('connected')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .set({
        'uuid': FirebaseAuth.instance.currentUser!.uid,
        'username': username,
        'photoUrl': photoUrl,
        'status': status,
        'bio': bio,
      });
      await users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('connected')
          .doc(email)
          .set({
        'uuid': uuid,
        'username': friendName,
        'photoUrl': friendPhoto,
        'status': friendStatus,
        'bio': friendBio,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> disconnectUser(String uuid, String friendName, String email,
      String friendPhoto, String friendStatus, String friendBio) async {
    try {
      CollectionReference users = _firestore.collection('users');

      await users
          .doc(uuid)
          .collection('connected')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .delete();
      await users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('connected')
          .doc(email)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
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
