import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  final _file = await _imagePicker.pickImage(source: source, imageQuality: 15);
  File? img = File(_file!.path);
  img = await croppImage(imageFile: img);
  if (img != null) {
    return img.readAsBytes();
  }
  Get.snackbar('Warning', 'No image selected!');
}

Future<File?> croppImage({File? imageFile}) async {
  CroppedFile? croppedImage =
      await ImageCropper().cropImage(sourcePath: imageFile!.path);
  if (croppedImage == null) return null;
  return File(croppedImage.path);
}
