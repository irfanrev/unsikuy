import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/discussion/controllers/discussion_controller.dart';
import 'package:unsikuy_app/app/modules/post/controllers/post_controller.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:url_launcher/url_launcher.dart';

class ContributorCard extends StatelessWidget {
  final snap;
  final posId;
  final DiscussionController controller;
  const ContributorCard(
      {super.key,
      required this.snap,
      required this.controller,
      required this.posId});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(snap['published_at']);

    return Container(
      margin: EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipRRect(
                child: ImageLoad(
              shapeImage: ShapeImage.oval,
              placeholder: AppImages.userPlaceholder.image().image,
              image: snap['profilePict'] ?? '',
              fit: BoxFit.cover,
            )),
          ),
          const SizedBox(
            width: 6,
          ),
          Expanded(
            child: Container(
              width: 100.w,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16)),
                  color: AppColors.grey.shade100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        snap['username'],
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: AppColors.textColour80,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Visibility(
                        visible: controller.uuidUser == snap['uuid'],
                        child: InkWell(
                          onTap: () {
                            if (controller.uuidUser == snap['uuid']) {
                              Get.defaultDialog(
                                titlePadding: EdgeInsets.only(top: 16),
                                title: 'Delete Contribution?',
                                titleStyle:
                                    Theme.of(context).textTheme.headline2,
                                content: Column(
                                  children: [
                                    Container(
                                      width: 160,
                                      height: 160,
                                      child: Lottie.asset(
                                          'lib/app/resources/images/delete-post.json'),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.deleteContribution(
                                            posId, snap['commentId']);
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
                            }
                          },
                          child: Icon(
                            CupertinoIcons.ellipsis_vertical,
                            size: 15,
                            color: AppColors.grey.shade500,
                          ),
                        ),
                      )
                      // Icon(
                      //   CupertinoIcons.hand_thumbsup,
                      //   size: 20,
                      //   color: AppColors.grey.shade500,
                      // )
                    ],
                  ),
                  Text(
                    "${DateFormat.yMMMEd().format(dateTime)} on ${DateFormat.Hm().format(dateTime)}",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.textColour50,
                          fontSize: 11,
                        ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Linkify(
                    text: snap['text'],
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
                          color: AppColors.black,
                          height: 1.4,
                        ),
                    linkStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
