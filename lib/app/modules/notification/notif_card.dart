import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/discussion/controllers/discussion_controller.dart';
import 'package:unsikuy_app/app/modules/notification/controllers/notification_controller.dart';
import 'package:unsikuy_app/app/modules/profile/views/profile_view.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';

class NotifCard extends StatelessWidget {
  final snap;
  final NotificationController controller;
  const NotifCard({super.key, required this.snap, required this.controller});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(snap['time']);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        width: 100.w,
        child: Row(
          children: [
            Container(
              width: 37,
              height: 37,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipRRect(
                child: ImageLoad(
                  shapeImage: ShapeImage.oval,
                  image: snap['photoUrl'],
                  placeholder: AppImages.userPlaceholder.image().image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          snap['title'],
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.defaultDialog(
                            titlePadding: EdgeInsets.only(top: 16),
                            title: 'Delete Notification?',
                            titleStyle: Theme.of(context).textTheme.headline2,
                            content: Column(
                              children: [
                                Container(
                                  width: 130,
                                  height: 130,
                                  child: Lottie.asset(
                                      'lib/app/resources/images/delete-post.json'),
                                ),
                                InkWell(
                                  onTap: () {
                                    controller.deleteNotif(snap['notifId']);
                                    Get.back();
                                  },
                                  child: Text('Delete',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                            color: AppColors.red,
                                          )),
                                )
                              ],
                            ),
                          );
                        },
                        child: Icon(
                          CupertinoIcons.ellipsis_vertical,
                          size: 15,
                          color: AppColors.grey.shade500,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "${DateFormat.yMMMEd().format(dateTime)} on ${DateFormat.Hm().format(dateTime)}",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.textColour50,
                          fontSize: 12,
                        ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Container(
                    width: Get.width,
                    child: Text(
                      snap['body'],
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: AppColors.textColour70,
                            fontSize: 15,
                            height: 1.4,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
