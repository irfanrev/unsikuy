import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/notification/notif_card.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_overlay.dart';

import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        title: Text(
          'Notification',
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: AppColors.textColour80),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showBarModalBottomSheet(
                    //constraints: BoxConstraints(maxHeight: 300),
                    context: context,
                    builder: (context) {
                      return Container(
                        width: 100.w,
                        height: 250,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Are you sure you want to delete all notifications?',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                    color: AppColors.black,
                                    fontSize: 18,
                                  ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            InkWell(
                              onTap: () {
                                controller.deleteAllNotif();
                                Get.back();
                              },
                              child: Container(
                                width: 100.w,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  color: AppColors.primaryLight,
                                ),
                                child: Center(
                                    child: Text(
                                  'Oke',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        color: AppColors.white,
                                      ),
                                )),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                width: 100.w,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  color: AppColors.primaryOrange,
                                ),
                                child: Center(
                                    child: Text(
                                  'Cancel',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        color: AppColors.white,
                                      ),
                                )),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              icon: Icon(
                CupertinoIcons.delete,
                size: 22,
                color: AppColors.primaryDark,
              ))
        ],
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('notification')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingOverlay();
              }
              if ((snapshot.data! as dynamic).docs.length == 0) {
                return Center(
                  child: Container(
                    width: 200,
                    child:
                        Lottie.asset('lib/app/resources/images/not-found.json'),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      var data = (snapshot.data! as dynamic).docs[index];
                      return NotifCard(
                        snap: data,
                        controller: controller,
                      );
                    });
              }
            }),
      ),
    );
  }
}
