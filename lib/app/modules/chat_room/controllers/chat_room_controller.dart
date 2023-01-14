import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomController extends GetxController {
  //TODO: Implement ChatRoomController
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int totalUnread = 0;
  late ScrollController scrollC;

  @override
  void onInit() {
    // TODO: implement onInit
    scrollC = ScrollController();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    scrollC.dispose();
    super.onClose();
  }

  // Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(
  //     String chat_id) async {
  //   CollectionReference chats = firestore.collection('chats');

  //   return chats
  //       .doc(chat_id)
  //       .collection('chat')
  //       .orderBy('lastTime', descending: false)
  //       .snapshots();
  // }

  Stream<DocumentSnapshot<Object?>> friendData(String uuidFriend) {
    CollectionReference users = firestore.collection('users');

    return users.doc(uuidFriend).snapshots();
  }

  void newChat(Map<String, dynamic> argument, String chat, String email,
      String uuid) async {
    CollectionReference chats = firestore.collection('chats');
    CollectionReference users = firestore.collection('users');

    String date = DateTime.now().toIso8601String();

    final newChat =
        await chats.doc(argument['chat_id']).collection('chat').add({
      'pengirim': email,
      'penerima': argument['friendEmail'],
      'pesan': chat,
      'time': date,
      'isRead': false,
    });
    totalUnread += 1;

    Timer(
      Duration.zero,
      () => scrollC.jumpTo(scrollC.position.maxScrollExtent),
    );

    await users.doc(uuid).collection('chats').doc(argument['chat_id']).update({
      'lastTime': date,
    });

    final checkFriendChat = await users
        .doc(argument['uuid'])
        .collection('chats')
        .doc(argument['chat_id'])
        .get();

    if (checkFriendChat.exists) {
      final checkTotalUnread = await chats
          .doc(argument['chat_id'])
          .collection('chat')
          .where('isRead', isEqualTo: false)
          .where('pengirim', isEqualTo: email)
          .get();

      //total unread untuk friend
      totalUnread = checkTotalUnread.docs.length;

      //update
      await users
          .doc(argument['uuid'])
          .collection('chats')
          .doc(argument['chat_id'])
          .update({
        'lastTime': date,
        'total_unread': totalUnread,
      });
    } else {
      // add new
      await users
          .doc(argument['uuid'])
          .collection('chats')
          .doc(argument['chat_id'])
          .set({
        'connection': email,
        'lastTime': date,
        'total_unread': totalUnread + 1,
        'uuid': FirebaseAuth.instance.currentUser!.uid,
      });
    }
  }
}
