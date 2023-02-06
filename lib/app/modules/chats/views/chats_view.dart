import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/controllers/auth_controller.dart';
import 'package:unsikuy_app/app/modules/chats/widgets/user_card_chat.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/form/form_input_field_with_icon.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: (kIsWeb) ? 320 : 0),
              child: Column(
                children: [
                  FormInputFieldWithIcon(
                    controller: controller.searchC,
                    labelText: 'Search user by first keyword',
                    onCompleted: (value) {
                      if (value != '') {
                        print(value.toString());
                        controller.isSearch.value = true;
                        controller.refresh();
                        controller.update();
                      } else {
                        controller.isSearch.value = false;
                        controller.refresh();
                        controller.update();
                      }
                    },
                    onClear: () {
                      controller.searchC.clear();
                      controller.isSearch.value = false;
                      controller.refresh();
                      controller.update();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => Container(
                      width: 100.w,
                      child: controller.isSearch.value == true
                          ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: controller.searchChat(
                                FirebaseAuth.instance.currentUser!.uid,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.active) {
                                  var allChats = snapshot.data!.docs;
                                  if (snapshot.data!.docs.length == 0) {
                                    return Center(
                                      child: Container(
                                        width: 200,
                                        child: Lottie.asset(
                                            'lib/app/resources/images/not-found.json'),
                                      ),
                                    );
                                  } else {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        primary: false,
                                        itemCount: allChats.length,
                                        itemBuilder: (context, index) {
                                          return StreamBuilder<
                                                  DocumentSnapshot<
                                                      Map<String, dynamic>>>(
                                              stream: controller.friendStream(
                                                allChats[index]['uuid'],
                                              ),
                                              builder: (context, snapshot2) {
                                                if (snapshot2.connectionState ==
                                                    ConnectionState.active) {
                                                  var data =
                                                      snapshot2.data!.data();
                                                  return UserCardChat(
                                                    data: data,
                                                    totalUnread:
                                                        allChats[index],
                                                    controller: controller,
                                                  );
                                                }
                                                return SizedBox();
                                              });
                                        });
                                  }
                                }
                                return LoadingOverlay();
                              },
                            )
                          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: controller.chatStream(
                                FirebaseAuth.instance.currentUser!.uid,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.active) {
                                  var allChats = snapshot.data!.docs;
                                  if (snapshot.data!.docs.length == 0) {
                                    return Center(
                                      child: Container(
                                        width: 200,
                                        child: Lottie.asset(
                                            'lib/app/resources/images/not-found.json'),
                                      ),
                                    );
                                  } else {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        primary: false,
                                        itemCount: allChats.length,
                                        itemBuilder: (context, index) {
                                          return StreamBuilder<
                                                  DocumentSnapshot<
                                                      Map<String, dynamic>>>(
                                              stream: controller.friendStream(
                                                allChats[index]['uuid'],
                                              ),
                                              builder: (context, snapshot2) {
                                                if (snapshot2.connectionState ==
                                                    ConnectionState.active) {
                                                  var data =
                                                      snapshot2.data!.data();
                                                  return UserCardChat(
                                                    data: data,
                                                    totalUnread:
                                                        allChats[index],
                                                    controller: controller,
                                                  );
                                                }
                                                return SizedBox();
                                              });
                                        });
                                  }
                                }
                                return LoadingOverlay();
                              },
                            ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
