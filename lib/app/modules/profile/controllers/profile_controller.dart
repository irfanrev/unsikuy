import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;

import '../../../controllers/auth_controller.dart';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController
  static ProfileController find = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  GetStorage box = GetStorage();
  TextEditingController reportC = TextEditingController();
  var profileData;
  var uuidUser;
  var username;
  var status;
  var profImg;
  var bio;

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

  Future getUsersData() async {
    User currentUser = auth.currentUser!;

    DocumentSnapshot userData =
        await _firestore.collection('users').doc(currentUser.uid).get();

    uuidUser = currentUser.uid.toString();
    username = userData['username'];
    status = userData['status'];
    profImg = userData['photoUrl'];
    bio = userData['bio'];
  }

  Future blockUser(String sharingName) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final body = jsonEncode({
      'service_id': 'service_sd6r46w',
      'template_id': 'template_xbrcknn',
      'user_id': 'S27fCFKeMjxIkuHK4',
      'template_params': {
        'user_name': username,
        'user_email': auth.currentUser!.email,
        'user_subject': 'REPORT UNSIKA CONNECT',
        'user_message': 'Report User :',
        'sharing_username': sharingName,
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

  Future logout() async {
    await _auth.signOut();
    box.remove('token');
    Get.offAllNamed(Routes.LOGIN);
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
}
