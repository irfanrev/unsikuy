import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';

class ChatsController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream(String uuid) {
    return firestore
        .collection('users')
        .doc(uuid)
        .collection('chats')
        .orderBy('lastTime', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> friendStream(String uuid) {
    return firestore.collection('users').doc(uuid).snapshots();
  }

  void goToChatRoom(String email, String myuuid, String chat_id,
      String friendEmail, String friendUuid) async {
    CollectionReference chats = firestore.collection('chats');
    CollectionReference users = firestore.collection('users');
    final updateStatusChat = await chats
        .doc(chat_id)
        .collection('chat')
        .where('isRead', isEqualTo: false)
        .where('penerima', isEqualTo: email)
        .get();

    updateStatusChat.docs.forEach((element) async {
      await chats.doc(chat_id).collection('chat').doc(element.id).update({
        'isRead': true,
      });
    });

    await users.doc(myuuid).collection('chats').doc(chat_id).update({
      'total_unread': 0,
    });

    print(chat_id);
    Get.toNamed(Routes.CHAT_ROOM, arguments: {
      'chat_id': chat_id,
      'friendEmail': friendEmail,
      'uuid': friendUuid,
    });
  }
}
