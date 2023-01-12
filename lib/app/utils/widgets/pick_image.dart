import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source, imageQuality: 35);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  Get.snackbar('Warning', 'No image selected!');
}
