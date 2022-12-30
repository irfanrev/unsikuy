import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unsikuy_app/app/model/post.dart';
import 'package:unsikuy_app/app/model/user.dart' as model;
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/pick_image.dart';
import 'package:uuid/uuid.dart';

class UploadController extends GetxController {
  //TODO: Implement UploadController
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final TextEditingController desc = TextEditingController();
  var username;
  var photoUrl;
  RxBool isDismiss = false.obs;

  Uint8List? file;

  @override
  void onInit() {
    // TODO: implement onInit
    getUsersData();
    super.onInit();
  }

  void chooseCamera() async {
    Uint8List source = await pickImage(ImageSource.camera);
    file = source;
    update();
  }

  void chooseGallery() async {
    Uint8List source = await pickImage(ImageSource.gallery);
    file = source;
    update();
  }

  Future getUsersData() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot userData =
        await _firestore.collection('users').doc(currentUser.uid).get();

    username = userData['username'];
    photoUrl = userData['photoUrl'];
  }

  Future<String> uploadImageToStorage(
      String childname, Uint8List file, bool isPost) async {
    Reference ref =
        firebaseStorage.ref().child(childname).child(_auth.currentUser!.uid);

    if (isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future upload() async {
    try {
      isDismiss.value = true;
      String photo = await uploadImageToStorage('post', file!, true);

      String postId = Uuid().v1();
      Post post = Post(
        postId: postId,
        username: username,
        description: desc.text,
        publishedAt: DateTime.now(),
        uuid: _auth.currentUser!.uid,
        postUrl: photo,
        profImg: photoUrl,
        like: [],
      );
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      showNotif('Success', 'Data is Posted!');
      resetImage();
      desc.text = '';
      isDismiss.value = false;
    } catch (e) {
      showError('Error', e.toString());
      isDismiss.value = false;
    }
  }

  resetImage() {
    file = null;
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
