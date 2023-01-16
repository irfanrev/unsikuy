import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/chats/controllers/chats_controller.dart';
import 'package:unsikuy_app/app/modules/people/controllers/people_controller.dart';
import 'package:unsikuy_app/app/modules/profile/views/profile_view.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:get/get.dart';

class UserCardChat extends StatelessWidget {
  final data;
  final totalUnread;
  final ChatsController controller;
  const UserCardChat(
      {super.key,
      required this.data,
      required this.totalUnread,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.goToChatRoom(
          FirebaseAuth.instance.currentUser!.email.toString(),
          FirebaseAuth.instance.currentUser!.uid,
          totalUnread.id,
          totalUnread['connection'],
          totalUnread['uuid'],
        );
      },
      child: Container(
        width: 100.w,
        margin: EdgeInsets.only(bottom: 22),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              child: ImageLoad(
                fit: BoxFit.cover,
                shapeImage: ShapeImage.oval,
                placeholder: AppImages.userPlaceholder.image().image,
                image: data['photoUrl'],
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['username'],
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: AppColors.textColour80,
                        ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    data['status'],
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.shadesPrimaryDark60,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(
              child: totalUnread['total_unread'] == 0
                  ? SizedBox()
                  : Chip(
                      backgroundColor: AppColors.primaryLight,
                      label: Text(
                        totalUnread['total_unread'].toString(),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: AppColors.white,
                            ),
                      ),
                    ),
            ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
}
