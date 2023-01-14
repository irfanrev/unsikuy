import 'dart:async';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_overlay.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  const ChatRoomView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final String chat_id = (Get.arguments as Map<String, dynamic>)['chat_id'];
    final String uuidFriend = (Get.arguments as Map<String, dynamic>)['uuid'];

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 22,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              child: StreamBuilder<DocumentSnapshot<Object>>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(uuidFriend)
                      .snapshots(),
                  builder: (context, snapProfile) {
                    if (snapProfile.connectionState == ConnectionState.active) {
                      var profileData =
                          snapProfile.data!.data() as Map<String, dynamic>;
                      return ImageLoad(
                        fit: BoxFit.cover,
                        shapeImage: ShapeImage.oval,
                        placeholder: AppImages.userPlaceholder.image().image,
                        image: profileData['photoUrl'],
                      );
                    }
                    return ImageLoad(
                      fit: BoxFit.cover,
                      shapeImage: ShapeImage.oval,
                      placeholder: AppImages.userPlaceholder.image().image,
                    );
                  }),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: StreamBuilder<DocumentSnapshot<Object>>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(uuidFriend)
                            .snapshots(),
                        builder: (context, snapProfile) {
                          if (snapProfile.connectionState ==
                              ConnectionState.active) {
                            var profileData = snapProfile.data!.data()
                                as Map<String, dynamic>;
                            return Text(
                              profileData['username'],
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    color: AppColors.textColour80,
                                  ),
                            );
                          }
                          return Text(
                            '',
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      color: AppColors.textColour80,
                                    ),
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'status',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.shadesPrimaryDark60,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Container(
              width: 100.w,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(chat_id)
                      .collection('chat')
                      .orderBy('time')
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      var allData = snapshot.data!.docs;
                      Timer(
                        Duration.zero,
                        () => controller.scrollC.jumpTo(
                            controller.scrollC.position.maxScrollExtent),
                      );
                      return ListView.builder(
                          controller: controller.scrollC,
                          itemCount: allData.length,
                          itemBuilder: (context, index) {
                            // return BubbleNormal(
                            //   tail: true,
                            //   text: allData[index]['pesan'],
                            //   isSender: allData[index]['pengirim'] ==
                            //           FirebaseAuth.instance.currentUser!.email
                            //       ? true
                            //       : false,
                            //   color: AppColors.primaryLight,
                            //   textStyle:
                            //       TextStyle(color: Colors.white, fontSize: 16),
                            // );
                            return ItemChat(
                                isSender: allData[index]['pengirim'] ==
                                        FirebaseAuth.instance.currentUser!.email
                                    ? true
                                    : false,
                                msg: allData[index]['pesan'],
                                time: allData[index]['time']);
                          });
                    }
                    return LoadingOverlay();
                  }),
            ),
            // child: Column(
            //   children: [
            //     BubbleNormal(
            //       text:
            //           'Added iMassage shape bubbles Added iMassage shape bubbles Added iMassage shape bubbles Added iMassage shape bubbles Added iMassage shape bubbles Added iMassage shape bubbles Added iMassage shape bubbles Added iMassage shape bubbles Added iMassage shape bubbles Added iMassage shape bubbles Added iMassage shape bubbles',
            //       color: Color(0xFF1B97F3),
            //       tail: true,
            //       textStyle: TextStyle(color: Colors.white, fontSize: 16),
            //     ),
            //     BubbleNormal(
            //       text: 'Added iMassage shape bubbles',
            //       color: Color(0xFF1B97F3),
            //       tail: true,
            //       isSender: false,
            //       textStyle: TextStyle(color: Colors.white, fontSize: 16),
            //     ),
            //     BubbleNormal(
            //       text: 'Added iMassage shape bubbles',
            //       color: Color(0xFF1B97F3),
            //       tail: true,
            //       isSender: false,
            //       textStyle: TextStyle(color: Colors.white, fontSize: 16),
            //     ),
            //   ],
            // ),
          )),
          MessageBar(
            sendButtonColor: AppColors.primaryLight,
            onSend: (value) {
              if (value.isNotEmpty) {
                controller.newChat(
                    Get.arguments as Map<String, dynamic>,
                    value,
                    FirebaseAuth.instance.currentUser!.email.toString(),
                    FirebaseAuth.instance.currentUser!.uid.toString());
                value = '';
              }
            },
            actions: [
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: InkWell(
                  child: Icon(
                    Icons.emoji_emotions,
                    color: Colors.green,
                    size: 24,
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ItemChat extends StatelessWidget {
  const ItemChat({
    Key? key,
    required this.isSender,
    required this.msg,
    required this.time,
  }) : super(key: key);

  final bool isSender;
  final String msg;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: isSender
                  ? BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
            ),
            padding: EdgeInsets.all(12),
            child: Text("$msg",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: AppColors.white,
                      fontSize: 14,
                    )),
          ),
          SizedBox(height: 3),
          Text(
            DateFormat.jm().format(DateTime.parse(time)),
            style:
                Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 10),
          ),
        ],
      ),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}
