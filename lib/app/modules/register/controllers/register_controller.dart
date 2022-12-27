import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  //TODO: Implement RegisterController
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  List<String> genderOptions = ['Male', 'Female'];
  List<String> statusOptions = ['Student', 'Alumni', 'Staff', 'Other'];
  bool isAggree = false;
}
