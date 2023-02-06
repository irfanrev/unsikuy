import 'dart:async';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  const ChatRoomView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final String chat_id = (Get.arguments as Map<String, dynamic>)['chat_id'];
    final String uuidFriend = (Get.arguments as Map<String, dynamic>)['uuid'];

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 28,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
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
                              profileData['status'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: AppColors.shadesPrimaryDark60,
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
                            if (index == 0) {
                              return Column(
                                children: [
                                  Chip(
                                    backgroundColor: AppColors.grey.shade200,
                                    label: Text(
                                      allData[index]['groupTime'],
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  ItemChat(
                                      isSender: allData[index]['pengirim'] ==
                                              FirebaseAuth
                                                  .instance.currentUser!.email
                                          ? true
                                          : false,
                                      msg: allData[index]['pesan'],
                                      time: allData[index]['time']),
                                ],
                              );
                            } else {
                              if (allData[index]['groupTime'] ==
                                  allData[index - 1]['groupTime']) {
                                return ItemChat(
                                    isSender: allData[index]['pengirim'] ==
                                            FirebaseAuth
                                                .instance.currentUser!.email
                                        ? true
                                        : false,
                                    msg: allData[index]['pesan'],
                                    time: allData[index]['time']);
                              } else {
                                return Column(
                                  children: [
                                    Chip(
                                      backgroundColor: AppColors.grey.shade200,
                                      label: Text(
                                        allData[index]['groupTime'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    ItemChat(
                                        isSender: allData[index]['pengirim'] ==
                                                FirebaseAuth
                                                    .instance.currentUser!.email
                                            ? true
                                            : false,
                                        msg: allData[index]['pesan'],
                                        time: allData[index]['time']),
                                  ],
                                );
                              }
                            }
                          });
                    }
                    return LoadingOverlay();
                  }),
            ),
          )),
          Container(
            margin: EdgeInsets.only(
              bottom: controller.isShowEmoji.isTrue
                  ? 5
                  : context.mediaQueryPadding.bottom,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    child: TextField(
                      minLines: 1,
                      maxLines: 4,
                      autocorrect: false,
                      controller: controller.chatC,
                      focusNode: controller.focusNode,
                      style: Theme.of(context).textTheme.bodyText1,
                      keyboardType: TextInputType.multiline,
                      onEditingComplete: () => controller.newChat(
                          Get.arguments as Map<String, dynamic>,
                          controller.chatC.text,
                          FirebaseAuth.instance.currentUser!.email.toString(),
                          FirebaseAuth.instance.currentUser!.uid.toString()),
                      decoration: InputDecoration(
                        hintText: 'Type message here',
                        prefixIcon: IconButton(
                          onPressed: () {
                            controller.focusNode.unfocus();
                            controller.isShowEmoji.toggle();
                          },
                          icon: Icon(Icons.emoji_emotions_outlined),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        filled: true,
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.0,
                            color: AppColors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1,
                              color: AppColors.primaryLight), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Material(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.primaryDark,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      if (controller.chatC.text.isNotEmpty) {
                        controller.newChat(
                            Get.arguments as Map<String, dynamic>,
                            controller.chatC.text,
                            FirebaseAuth.instance.currentUser!.email.toString(),
                            FirebaseAuth.instance.currentUser!.uid.toString());
                        controller.chatContent = controller.chatC.text;
                        controller.chatC.clear();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => (controller.isShowEmoji.isTrue)
                ? Container(
                    height: 325,
                    child: EmojiPicker(
                      onEmojiSelected: (category, emoji) {
                        controller.addEmojiToChat(emoji);
                      },
                      onBackspacePressed: () {
                        controller.deleteEmoji();
                      },
                      config: Config(
                        backspaceColor: AppColors.primaryDark,
                        columns: 7,
                        emojiSizeMax: 32.0,
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        initCategory: Category.RECENT,
                        bgColor: Color(0xFFF2F2F2),
                        indicatorColor: AppColors.primaryLight,
                        iconColor: Colors.grey,
                        iconColorSelected: AppColors.primaryLight,
                        showRecentsTab: true,
                        recentsLimit: 28,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                      ),
                    ),
                  )
                : SizedBox(),
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
        vertical: 1,
        horizontal: 8,
      ),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color:
                  isSender ? AppColors.primaryLight : AppColors.grey.shade200,
              borderRadius: isSender
                  ? BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                      bottomLeft: Radius.circular(22),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                    ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Linkify(
                  text: '$msg',
                  onOpen: (value) async {
                    Uri url = Uri.parse(value.url);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    } else {
                      throw 'Could not launch $value.url';
                    }
                  },
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: isSender ? AppColors.white : AppColors.black,
                        height: 1.4,
                      ),
                  linkStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                ),
                Container(
                  child: Text(
                    DateFormat.jm().format(DateTime.parse(time)),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}
