import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:unsikuy_app/app/controllers/auth_controller.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class PostController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final authC = Get.find<AuthController>();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  ScrollController scrollC = ScrollController();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController commentC =
      TextEditingController(); // listener for listview scrolling
  TextEditingController reportC =
      TextEditingController(); // listener for listview scrolling
  var photoUrl;
  var username;
  var uuidUser;
  var postID;
  var status;
  var bio;
  var isVerify;

  RxBool liked = false.obs;
  RxBool isTaped = false.obs;
  RxString reportValue = ''.obs;
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
    scrollC = ScrollController();
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
    isVerify = userData['isVerify'];
    uuidUser = currentUser.uid.toString();
  }

  Future<void> sendReport() async {
    final Email email = Email(
      body: reportC.text.isNotEmpty ? reportC.text : 'Report Sharing',
      subject: 'REPORT SHARING',
      recipients: ['sukacode.dev@gmail.com'],
      isHTML: false,
    );
    await FlutterEmailSender.send(email);
    reportC.clear();
    showNotif('Report Success', 'Report has sended!');
    Get.back();
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

  Future blockSharing(String sharingName, String sharingId) async {
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

  Future<void> likePost(
      String postId, String uuid, List like, String friendUuid) async {
    try {
      if (like.contains(uuid)) {
        await _firestore.collection('posts').doc(postId).update({
          "like": FieldValue.arrayRemove([uuid]),
        });
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('listLike')
            .doc(auth.currentUser!.email.toString())
            .delete();
      } else {
        await _firestore.collection('posts').doc(postId).update({
          "like": FieldValue.arrayUnion([uuid]),
        });
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('listLike')
            .doc(auth.currentUser!.email.toString())
            .set({
          'username': username,
          'photoUrl': photoUrl,
          'status': status,
          'uuid': uuidUser,
          'isVerify': isVerify,
          'bio': bio,
        });
        DocumentSnapshot docSnap = await FirebaseFirestore.instance
            .collection('userToken')
            .doc(friendUuid)
            .get();
        String mToken = docSnap['token'];
        authC.sendPustNotification(mToken, '', '$username Like your sharing');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likeComment(String postId, String uuid, List like,
      String friendUuid, String commentId) async {
    try {
      if (like.contains(uuid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          "like": FieldValue.arrayRemove([uuid]),
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          "like": FieldValue.arrayUnion([uuid]),
        });
        DocumentSnapshot docSnap = await FirebaseFirestore.instance
            .collection('userToken')
            .doc(friendUuid)
            .get();
        String mToken = docSnap['token'];
        authC.sendPustNotification(mToken, '', '$username like your comment');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> disLikeComment(String postId, String uuid, List dislike,
      String friendUuid, String commentId) async {
    try {
      if (dislike.contains(uuid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          "dislike": FieldValue.arrayRemove([uuid]),
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          "dislike": FieldValue.arrayUnion([uuid]),
        });
        DocumentSnapshot docSnap = await FirebaseFirestore.instance
            .collection('userToken')
            .doc(friendUuid)
            .get();
        String mToken = docSnap['token'];
        authC.sendPustNotification(
            mToken, '', '$username disklike your comment');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> upPost(
      String postId, String uuid, List upPost, String friendUuid) async {
    try {
      if (upPost.contains(uuid)) {
        await _firestore.collection('posts').doc(postId).update({
          "upPost": FieldValue.arrayRemove([uuid]),
        });
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('listBoosted')
            .doc(auth.currentUser!.email.toString())
            .delete();
      } else {
        await _firestore.collection('posts').doc(postId).update({
          "upPost": FieldValue.arrayUnion([uuid]),
        });
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('listBoosted')
            .doc(auth.currentUser!.email.toString())
            .set({
          'username': username,
          'photoUrl': photoUrl,
          'status': status,
          'uuid': uuidUser,
          'isVerify': isVerify,
          'bio': bio,
        });
        DocumentSnapshot docSnap = await FirebaseFirestore.instance
            .collection('userToken')
            .doc(friendUuid)
            .get();
        String mToken = docSnap['token'];
        authC.sendPustNotification(
            mToken, '', '$username Boosted your sharing');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> savePost(
      String postId,
      String username,
      String desc,
      String publishedAt,
      String uuid,
      String postUrl,
      String profImg,
      String isVerify,
      String like,
      String post) async {
    try {
      await _firestore
          .collection('users')
          .doc(uuidUser)
          .collection('archive')
          .doc(postId)
          .set({
        'postId': postId,
        'username': username,
        'description': desc,
        'published_at': publishedAt,
        'uuid': uuid,
        'postUrl': postUrl,
        'profImg': profImg,
        'isVerify': isVerify,
        'like': like,
        'upPost': post,
      });
      showNotif('Success', 'This post has saved');
    } catch (e) {
      print(e);
    }
  }

  Future<void> postComment(String postId, String uuid) async {
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
            mToken, commentC.text.toString(), '$username Comment your sharing');
        String notifId = Uuid().v1();
        await _firestore
            .collection('users')
            .doc(uuid)
            .collection('notification')
            .doc(notifId)
            .set({
          'username': username,
          'photoUrl': photoUrl,
          'title': '$username comment your sharing',
          'body': commentC.text,
          'time': DateTime.now().toString(),
          'notifId': notifId,
        });
        await analytics.logEvent(name: 'Post Comment', parameters: {
          'title': 'post_comment',
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

  Future<void> postReplyComment(
      String postId, String uuid, String commentId) async {
    try {
      if (commentC.text.isNotEmpty) {
        String replyId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
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
        authC.sendPustNotification(
            mToken, commentC.text.toString(), '$username reply your comment');
        String notifId = Uuid().v1();
        await _firestore
            .collection('users')
            .doc(uuid)
            .collection('notification')
            .doc(notifId)
            .set({
          'username': username,
          'photoUrl': photoUrl,
          'title': '$username reply your comment',
          'body': commentC.text,
          'time': DateTime.now().toString(),
          'notifId': notifId,
        });
        commentC.text = '';
        await analytics.logEvent(name: 'Reply Comment', parameters: {
          'title': 'reply_comment',
        });
        // showNotif('Success', 'Comment is posted');
      } else {
        showError('Text is empty', 'Please enter your comment below');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> connectUser(
      String uuid,
      String friendName,
      String email,
      String friendPhoto,
      String friendStatus,
      String friendBio,
      bool verify) async {
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
        'isVerify': isVerify,
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
        'isVerify': verify,
      });
      String notifId = Uuid().v1();
      await _firestore
          .collection('users')
          .doc(uuid)
          .collection('notification')
          .doc(notifId)
          .set({
        'username': username,
        'photoUrl': photoUrl,
        'title': '$username has connected with you',
        'body': '',
        'time': DateTime.now().toString(),
        'notifId': notifId,
      });
      commentC.text = '';
      await analytics.logEvent(name: 'Connect User', parameters: {
        'title': 'connect_user',
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
      await analytics.logEvent(name: 'Disconnect user', parameters: {
        'title': 'disconnect user',
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePost(String postId, String uuid, String imgPath) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      if (imgPath != '') {
        await FirebaseStorage.instance.refFromURL(imgPath).delete();
      }
      analytics.logEvent(name: 'Delete Post', parameters: {
        'title': 'delete_post',
        'postId': postId,
      });
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
      await analytics.logEvent(name: 'Delete Comment', parameters: {
        'title': 'delete_comment',
        'commentId': commentId,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteReply(
      String postId, String commentId, String replyId) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .collection('reply')
          .doc(replyId)
          .delete();
      await analytics.logEvent(name: 'Delete Reply', parameters: {
        'title': 'delete_reply',
        'postId': postId,
      });
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
      backgroundColor: AppColors.primaryLight, colorText: Colors.white);
}
