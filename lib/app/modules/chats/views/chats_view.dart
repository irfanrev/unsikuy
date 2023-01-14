import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/controllers/auth_controller.dart';
import 'package:unsikuy_app/app/modules/chats/widgets/user_card_chat.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_overlay.dart';

import '../controllers/chats_controller.dart';

class ChatsView extends GetView<ChatsController> {
  const ChatsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Chat',
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: AppColors.textColour80),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: 100.w,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.chatStream(
                  FirebaseAuth.instance.currentUser!.uid,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    var allChats = snapshot.data!.docs;
                    return ListView.builder(
                        itemCount: allChats.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                              stream: controller.friendStream(
                                allChats[index]['uuid'],
                              ),
                              builder: (context, snapshot2) {
                                if (snapshot2.connectionState ==
                                    ConnectionState.active) {
                                  var data = snapshot2.data!.data();
                                  return UserCardChat(
                                    data: data,
                                    totalUnread: allChats[index],
                                    controller: controller,
                                  );
                                }
                                return LoadingOverlay();
                              });
                        });
                  }
                  return LoadingOverlay();
                },
              ),
            )));
  }
}
