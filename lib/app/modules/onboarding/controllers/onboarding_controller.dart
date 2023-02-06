import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';

class OnboardingController extends GetxController {
  GetStorage box = GetStorage();

  skipOnboard() {
    box.write('skipOnboard', 'skip');
    print(box.read('token').toString());
    Get.offAllNamed(Routes.LOGIN);
  }
}
