import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/discussion/controllers/discussion_controller.dart';
import 'package:unsikuy_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:unsikuy_app/app/modules/profile/views/profile_view.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';

class MydiscussCard extends StatelessWidget {
  final snap;
  final ProfileController controller;
  const MydiscussCard(
      {super.key, required this.snap, required this.controller});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(snap['published_at']);
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.DISCUSS_DETAIL, arguments: {
          'postId': snap['postId'].toString(),
          'img': snap['profImg'].toString(),
          'name': snap['username'].toString(),
          'title': snap['title'].toString(),
          'uuid': snap['uuid'].toString(),
          'date': dateTime,
        });
      },
      child: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
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
                    InkWell(
                      onTap: () {
                        Get.to(ProfileView(
                          uuid: snap['uuid'],
                        ));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                snap['username'],
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Visibility(
                                visible: snap['isVerify'] == true,
                                child: Icon(
                                  CupertinoIcons.checkmark_seal_fill,
                                  color: Colors.red[900],
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "${DateFormat.yMMMEd().format(dateTime)} on ${DateFormat.Hm().format(dateTime)}",
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: AppColors.textColour50,
                                      fontSize: 12,
                                    ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: controller.uuidUser == snap['uuid'],
                  child: InkWell(
                    onTap: () {
                      if (controller.uuidUser == snap['uuid']) {
                        showBarModalBottomSheet(
                            //constraints: BoxConstraints(maxHeight: 300),
                            context: context,
                            builder: (context) {
                              return Container(
                                width: 100.w,
                                height: 160,
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Delete this Discussion?',
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
                                        controller
                                            .deleteDiscussion(snap['postId']);
                                        Get.back();
                                      },
                                      child: Container(
                                        width: 100.w,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(22),
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
                                  ],
                                ),
                              );
                            });
                      }
                    },
                    child: Icon(
                      CupertinoIcons.ellipsis_vertical,
                      size: 15,
                      color: AppColors.grey.shade500,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: 100.w,
              child: Text(
                snap['title'],
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: AppColors.black,
                      fontSize: 16,
                      height: 1.4,
                    ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //   color: AppColors.grey.shade500,
                    // ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.quote_bubble,
                        color: AppColors.grey.shade500,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Contribution',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: AppColors.textColour50,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              color: AppColors.grey.shade200,
              indent: 2,
              thickness: 1.3,
            )
          ],
        ),
      ),
    );
  }
}
