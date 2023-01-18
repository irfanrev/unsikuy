import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDetailController extends GetxController {
  //TODO: Implement PostDetailController

  FocusNode focusNode = FocusNode();
  ScrollController scrollC = ScrollController();

  final count = 0.obs;
  @override
  void onInit() {
    focusNode = FocusNode();
    scrollC = ScrollController();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    scrollC.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
