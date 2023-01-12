import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:unsikuy_app/app/model/chat.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserCredential? userCredential;
  User? currentUserNow;

  //initial variable

  @override
  void onInit() {
    // TODO: implement onInit
    getUsersData();
    super.onInit();
  }

  Future getUsersData() async {
    User currentUser = auth.currentUser!;

    DocumentSnapshot userData =
        await firestore.collection('users').doc(currentUser.uid).get();

    currentUserNow = auth.currentUser!;
  }

  void addNewConnection(String friendEmail) async {
    try {
      String date = DateTime.now().toString();
      bool flagNewConnection = false;
      CollectionReference chats = firestore.collection('chats');
      CollectionReference users = firestore.collection('users');

      final docUser = await users.doc(currentUserNow!.uid).get();
      final docChats =
          (docUser.data() as Map<String, dynamic>)['chats'] as List;
      var chat_id;

      if (docChats != null) {
        docChats.forEach((singleChat) {
          if (singleChat['connection'] == friendEmail) {
            chat_id = singleChat['chat_id'];
          }
        });

        if (chat_id != null) {
          flagNewConnection = false;
          // Get.toNamed(Routes.CHAT_ROOM, arguments: chat_id);
        } else {
          flagNewConnection = true;
        }
      } else {
        flagNewConnection = true;
      }

      if (flagNewConnection) {
        final chatDocs = await chats.where("connection", whereIn: [
          [
            currentUserNow!.email,
            friendEmail,
          ],
          [
            friendEmail,
            currentUserNow!.email,
          ],
        ]).get();

        if (chatDocs.docs.length != 0) {
          // ada data
          final String chatDataId = chatDocs.docs[0].id;
          final Map<String, dynamic> chatData =
              (chatDocs.docs[0].data() as Map<String, dynamic>);

          // Cek dan tambah chat
          docChats.add({
            "connection": friendEmail,
            "chat_id": chatDataId,
            'lastTime': chatData['lastTime'],
            "total_unread": 0,
          });

          await users.doc(currentUserNow!.uid).update({"chats": docChats});

          chat_id = chatDataId;
        } else {
          // buat baru
          final newChatDoc = await chats.add({
            "connection": [
              currentUserNow!.email,
              friendEmail,
            ],
            "chat": [],
          });

          docChats.add({
            "connection": friendEmail,
            "chat_id": newChatDoc.id,
            'lastTime': date,
            "total_unread": 0,
          });

          await users.doc(currentUserNow!.uid).update({"chats": docChats});

          chat_id = newChatDoc.id;
        }
      }
      print(chat_id);
      Get.toNamed(Routes.CHAT_ROOM, arguments: chat_id);
    } catch (e) {
      print(e);
    }
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

void showNotif(String title, String message) {
  Get.snackbar(title, message.toString(),
      backgroundColor: AppColors.successMain, colorText: Colors.white);
}
