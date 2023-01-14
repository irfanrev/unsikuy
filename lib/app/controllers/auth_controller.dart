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
  // User? currentUserNow;

  //initial variable

  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   getUsersData();
  //   super.onInit();
  // }

  // Future getUsersData() async {
  //   User currentUser = auth.currentUser!;

  //   DocumentSnapshot userData =
  //       await firestore.collection('users').doc(currentUser.uid).get();

  //   currentUserNow = auth.currentUser!;
  // }

  void addNewConnection(String friendEmail, String uuid) async {
    try {
      String date = DateTime.now().toString();
      bool flagNewConnection = false;
      CollectionReference chats = firestore.collection('chats');
      CollectionReference users = firestore.collection('users');
      var chat_id;
      //TOTO : Fixing chats collection

      final docChats = await users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chats')
          .get();

      if (docChats.docs.length != 0) {
        // udah ada data
        final checkConnection = await users
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('chats')
            .where('connection', isEqualTo: friendEmail)
            .get();
        if (checkConnection.docs.length != 0) {
          flagNewConnection = false;
          //ambil chat id dari colletion
          chat_id = checkConnection.docs[0].id;
        } else {
          flagNewConnection = true;
        }
      } else {
        // belum ada data, buat baru!
        flagNewConnection = true;
      }

      if (flagNewConnection) {
        final chatDocs = await chats.where("connection", whereIn: [
          [
            FirebaseAuth.instance.currentUser!.email,
            friendEmail,
          ],
          [
            friendEmail,
            FirebaseAuth.instance.currentUser!.email,
          ],
        ]).get();

        if (chatDocs.docs.length != 0) {
          // ada data
          final String chatDataId = chatDocs.docs[0].id;
          final Map<String, dynamic> chatData =
              (chatDocs.docs[0].data() as Map<String, dynamic>);

          // Cek dan tambah chat

          await users
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('chats')
              .doc(chatDataId)
              .set({
            "connection": friendEmail,
            'lastTime': chatData['lastTime'],
            "uuid": uuid,
            "total_unread": 0,
          });

          chat_id = chatDataId;
        } else {
          // buat baru
          final newChatDoc = await chats.add({
            "connection": [
              FirebaseAuth.instance.currentUser!.email,
              friendEmail,
            ],
          });

          await chats.doc(newChatDoc.id).collection('chat');

          await users
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('chats')
              .doc(newChatDoc.id)
              .set({
            "connection": friendEmail,
            'lastTime': date,
            "uuid": uuid,
            "total_unread": 0,
          });

          chat_id = newChatDoc.id;
        }
      }

      final updateStatusChat = await chats
          .doc(chat_id)
          .collection('chat')
          .where('isRead', isEqualTo: false)
          .where('penerima',
              isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .get();

      updateStatusChat.docs.forEach((element) async {
        await chats.doc(chat_id).collection('chat').doc(element.id).update({
          'isRead': true,
        });
      });

      await users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chats')
          .doc(chat_id)
          .update({
        'total_unread': 0,
      });

      print(chat_id);
      Get.toNamed(Routes.CHAT_ROOM, arguments: {
        'chat_id': chat_id,
        'friendEmail': friendEmail,
        'uuid': uuid,
      });

      // fixing diatas

      // final docUser = await users.doc(currentUserNow!.uid).get();
      // final docChats =
      //     (docUser.data() as Map<String, dynamic>)['chats'] as List;

      // if (docChats != null) {
      //   docChats.forEach((singleChat) {
      //     if (singleChat['connection'] == friendEmail) {
      //       chat_id = singleChat['chat_id'];
      //     }
      //   });

      //   if (chat_id != null) {
      //     flagNewConnection = false;
      //     // Get.toNamed(Routes.CHAT_ROOM, arguments: chat_id);
      //   } else {
      //     flagNewConnection = true;
      //   }
      // } else {
      //   flagNewConnection = true;
      // }

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
