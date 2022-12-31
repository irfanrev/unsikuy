import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //TODO: Implement LoginController
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  bool isSecure = true;
  RxBool isLoading = false.obs;

  Stream<User?> get streamAuthState => _auth.authStateChanges();

  GetStorage box = GetStorage();

  Future login() async {
    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailC.text, password: passC.text);
      box.write('token', emailC.text);
      print(box.read('token').toString());
      Get.offAllNamed(Routes.HOME);
      isLoading.value = false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showError('Error', 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showError('Error', 'Wrong password provided for that user.');
      }
    } catch (e) {
      showError('Error', 'Something error');
      isLoading.value = false;
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
