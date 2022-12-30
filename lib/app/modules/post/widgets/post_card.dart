import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/post/controllers/post_controller.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';

class PostCardItem extends StatelessWidget {
  final snap;
  PostController controller;
  PostCardItem({
    super.key,
    required this.snap,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(snap['published_at']);

    return Container(
      width: 100.w,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            AppElevation.elevation2px,
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipRRect(
                  child: ImageLoad(
                    shapeImage: ShapeImage.oval,
                    image: snap['profImg'],
                    placeholder: AppImages.userPlaceholder.image().image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snap['username'],
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    DateFormat.Hm().format(dateTime),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.textColour50,
                        ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            snap['description'],
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColors.black,
                  height: 1.4,
                ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 100.w,
            height: Get.height * 0.3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ImageLoad(
                image: snap['postUrl'],
                placeholder: AppImages.imgLogo.image().image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        controller.likePost(snap['postId'],
                            controller.auth.currentUser!.uid, snap['like']);
                      },
                      child: snap['like']
                              .contains(controller.auth.currentUser!.uid)
                          ? const Icon(
                              CupertinoIcons.hand_thumbsup_fill,
                              color: AppColors.primaryLight,
                            )
                          : Icon(
                              CupertinoIcons.hand_thumbsup,
                              color: AppColors.grey.shade500,
                            )),
                  const SizedBox(width: 8),
                  Text(
                    '${snap['like'].length}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: AppColors.textColour50),
                  ),
                ],
              ),
              const SizedBox(width: 28),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.chat_bubble,
                    color: AppColors.grey.shade500,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '123',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: AppColors.textColour50),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            child: Text(
              DateFormat.yMMMMEEEEd().format(dateTime),
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: AppColors.textColour50,
                  ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
