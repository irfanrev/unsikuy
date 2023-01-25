import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:unsikuy_app/app/controllers/auth_controller.dart';
import 'package:uuid/uuid.dart';

class ChatRoomController extends GetxController {
  //TODO: Implement ChatRoomController
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final authC = Get.find<AuthController>();
  int totalUnread = 0;
  late ScrollController scrollC;
  var isShowEmoji = false.obs;
  late FocusNode focusNode;
  TextEditingController chatC = TextEditingController();
  var photoUrl;

  var chatContent;

  @override
  void onInit() {
    // TODO: implement onInit
    scrollC = ScrollController();
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isShowEmoji.value = false;
      }
    });
    getUsersData();
    super.onInit();
  }

  Future getUsersData() async {
    User currentUser = auth.currentUser!;

    DocumentSnapshot userData =
        await firestore.collection('users').doc(currentUser.uid).get();

    photoUrl = userData['photoUrl'];
  }

  @override
  void onClose() {
    // TODO: implement onClose
    scrollC.dispose();
    focusNode.dispose();
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

  void addEmojiToChat(Emoji emoji) {
    chatC.text = chatC.text + emoji.emoji;
  }

  void deleteEmoji() {
    chatC.text = chatC.text.substring(0, chatC.text.length - 2);
  }

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
      'groupTime': DateFormat.yMMMMd('en_us').format(DateTime.parse(date)),
    });
    totalUnread += 1;

    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection('userToken')
        .doc(argument['uuid'])
        .get();
    DocumentSnapshot userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

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

    String friendToken = docSnap['token'];
    String userName = userSnap['username'];
    print(friendToken);
    authC.sendPustNotification(friendToken, chatContent.toString(), userName);
  }
}
