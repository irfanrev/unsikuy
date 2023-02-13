import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:unsikuy_app/app/model/user.dart' as model;
import 'package:unsikuy_app/app/modules/register/views/regsiter_success.dart';
import 'package:unsikuy_app/app/resources/resource.dart';

class RegisterController extends GetxController {
  //TODO: Implement RegisterController
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  List<String> genderOptions = ['Male', 'Female'];
  List<String> statusOptions = [
    'Student',
    'Alumni',
    'Lecturer',
    'Staff',
    'Organization',
    'Other'
  ];
  bool isAggree = false;
  bool isObscure = false;
  RxBool isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future register() async {
    isLoading.value = true;

    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: formKey.currentState?.value['email'],
          password: formKey.currentState?.value['password']);
      // model.User user = model.User(
      //   username: formKey.currentState?.value['username'],
      //   email: formKey.currentState?.value['email'],
      //   phone: formKey.currentState?.value['phone'],
      //   gender: formKey.currentState?.value['gender'],
      //   status: formKey.currentState?.value['status'],
      //   bio: '',
      //   photoUrl:
      //       'https://firebasestorage.googleapis.com/v0/b/unsika-connect.appspot.com/o/user_placeholder.png?alt=media&token=d78dc4cb-0e08-4023-bc8d-6a361c4cd461',
      //   uuid: cred.user!.uid,
      //   createdAt: DateTime.now(),
      //   updatedAt: DateTime.now(),
      //   chats: [],
      // );

      await _firebaseFirestore.collection('users').doc(cred.user!.uid).set({
        "username": formKey.currentState?.value['username'],
        "email": formKey.currentState?.value['email'],
        "phone": formKey.currentState?.value['phone'],
        "gender": formKey.currentState?.value['gender'],
        "status": formKey.currentState?.value['status'],
        "bio": '',
        "photoUrl":
            'https://firebasestorage.googleapis.com/v0/b/unsika-connect.appspot.com/o/user_placeholder.png?alt=media&token=d78dc4cb-0e08-4023-bc8d-6a361c4cd461',
        "uuid": cred.user!.uid,
        "createdAt": DateTime.now(),
        "updatedAt": DateTime.now(),
        "connecters": [],
        "isVerify": false,
        "ig": '',
        "twitter": '',
        "linkedin": '',
        "web": '',
        "about": '',
        // "chats": [],
      });

      _firebaseFirestore
          .collection('users')
          .doc(cred.user!.uid)
          .collection('chats');

      isLoading.value = false;
      Get.offAll(RegisterSuccess());
      await analytics.logSignUp(signUpMethod: 'email');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showError('Error', 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showError('Error', 'The account already exists for that email.');
      }
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Some error occurred');
    }
    isLoading.value = false;
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

dismissLoading() {
  if (Get.overlayContext != null) {
    Navigator.of(Get.overlayContext!).pop();
  }
}

// void showError(String message) {
//   Get.snackbar('txt_error_title'.tr, message.toString(),
//       backgroundColor: Colors.red, colorText: Colors.white);
// }

void showLoginError(String message) {
  Get.snackbar(message.toString(), 'txt_invalid_login'.tr,
      backgroundColor: Colors.red, colorText: Colors.white);
}

void showNotif(String message) {
  Get.snackbar('txt_success_notif'.tr, message.toString(),
      backgroundColor: AppColors.successMain, colorText: Colors.white);
}
