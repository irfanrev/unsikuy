import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unsikuy_app/app/model/user.dart' as model;
import 'package:unsikuy_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/pick_image.dart';
import 'package:uuid/uuid.dart';

class EditProfileController extends GetxController {
  final ProfileController profileC = ProfileController.find;
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  TextEditingController usernameC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController statusC = TextEditingController();
  TextEditingController bioC = TextEditingController();
  TextEditingController igC = TextEditingController();
  TextEditingController twitterC = TextEditingController();
  TextEditingController linkedinC = TextEditingController();
  TextEditingController webC = TextEditingController();
  TextEditingController aboutC = TextEditingController();
  RxBool isLoading = false.obs;
  RxString waStatus = 'Private by default'.obs;
  RxString waStatusPublic = 'Public'.obs;
  var uuidUser;
  var photoUrl;
  var username;
  var phone;
  var status;
  var email;
  var ig;
  var twitter;
  var linkedIn;
  var web;
  String photoReady = '';
  Uint8List? file;
  List<String> statusOptions = [
    'Student',
    'Alumni',
    'Lecturer',
    'Staff',
    'Organization',
    'Other'
  ];
  GetStorage box = GetStorage();

  @override
  void onInit() {
    // TODO: implement onInit
    getUsersData();
    super.onInit();
  }

  Future getUsersData() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot userData =
        await _firestore.collection('users').doc(currentUser.uid).get();

    username = userData['username'];
    usernameC.text = userData['username'];
    photoUrl = userData['photoUrl'];
    phone = userData['phone'];
    phoneC.text = userData['phone'];
    status = userData['status'];
    email = userData['email'];
    statusC.text = userData['status'];
    bioC.text = userData['bio'];
    aboutC.text = userData['about'];
    igC.text = userData['ig'];
    twitterC.text = userData['twitter'];
    linkedinC.text = userData['linkedin'];
    webC.text = userData['web'];
    uuidUser = currentUser.uid;
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
    photoReady = downloadUrl;
    return downloadUrl;
  }

  Future updateSosmed() async {
    isLoading.value = true;
    try {
      await _firestore.collection('users').doc(uuidUser).update({
        "ig": igC.text,
        "twitter": twitterC.text,
        "linkedin": linkedinC.text,
        "web": webC.text,
      });
      showNotif('Success', 'Social Media has updated');
      profileC.update();
      profileC.refresh();
      isLoading.value = false;
    } catch (e) {
      showError('Error', e.toString());
    }
  }

  Future updateWaPrivate() async {
    await box.remove('whatsapp');
    waStatus.value = 'Private by default';
    Get.back();
    refresh();
    update();
  }

  Future updateWaPublic() async {
    await box.write('whatsapp', 'Public');
    waStatusPublic.value = 'Public';
    Get.back();
    refresh();
    update();
  }

  Future updateProfile() async {
    isLoading.value = true;
    try {
      if (file != null) {
        String photo = await uploadImageToStorage('users', file!, false);
        await _firestore.collection('users').doc(uuidUser).update({
          "username": usernameC.text,
          "phone": phoneC.text,
          "status": status,
          "photoUrl": photo,
          "updated_at": DateTime.now().toString(),
        });
        //update post
        await _firestore
            .collection('posts')
            .where('uuid', isEqualTo: uuidUser)
            .get()
            .then((value) => value.docs.forEach((element) {
                  element.reference.update({
                    "username": usernameC.text,
                    "profImg": photo,
                  });
                }));
        //update discussion
        await _firestore
            .collection('discussion')
            .where('uuid', isEqualTo: uuidUser)
            .get()
            .then((value) => value.docs.forEach((element) {
                  element.reference.update({
                    "username": usernameC.text,
                    "profImg": photo,
                  });
                }));
        showNotif('Success', 'Profile has updated');
        profileC.update();
        profileC.refresh();
      } else {
        await _firestore.collection('users').doc(uuidUser).update({
          "username": usernameC.text,
          "phone": phoneC.text,
          "status": status,
          "updated_at": DateTime.now().toString(),
        });
        await _firestore
            .collection('posts')
            .where('uuid', isEqualTo: uuidUser)
            .get()
            .then((value) => value.docs.forEach((element) {
                  element.reference.update({
                    "username": usernameC.text,
                  });
                }));
        await _firestore
            .collection('discussion')
            .where('uuid', isEqualTo: uuidUser)
            .get()
            .then((value) => value.docs.forEach((element) {
                  element.reference.update({
                    "username": usernameC.text,
                  });
                }));
        showNotif('Success', 'Profile has updated');
        profileC.update();
        profileC.refresh();
      }

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
      // );

      isLoading.value = false;

      Get.back();
      //Get.offAll(RegisterSuccess());
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print(e.toString());
    }
    isLoading.value = false;
  }

  Future<void> updateBio() async {
    isLoading.value = true;
    try {
      await _firestore.collection('users').doc(uuidUser).update({
        "bio": bioC.text == username ? username : bioC.text,
      });

      profileC.refresh();

      showNotif('Success', 'Profile has updated');
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print(e.toString());
    }
    isLoading.value = false;
  }

  Future<void> updateAbout() async {
    isLoading.value = true;
    try {
      await _firestore.collection('users').doc(uuidUser).update({
        "about": aboutC.text == username ? username : aboutC.text,
      });

      profileC.refresh();

      showNotif('Success', 'Profile has updated');
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print(e.toString());
    }
    isLoading.value = false;
  }

  Future logout() async {
    await _auth.signOut();
    box.remove('token');
    Get.offAllNamed(Routes.LOGIN);
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

void showNotif(String title, String message) {
  Get.snackbar(title, message,
      backgroundColor: AppColors.primaryLight, colorText: Colors.white);
}
