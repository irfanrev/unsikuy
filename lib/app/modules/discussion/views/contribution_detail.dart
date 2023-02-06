import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/discussion/controllers/discussion_controller.dart';
import 'package:unsikuy_app/app/modules/discussion/reply_contributor.dart';
import 'package:unsikuy_app/app/modules/post/controllers/post_controller.dart';
import 'package:unsikuy_app/app/modules/post/widgets/comment_card.dart';
import 'package:unsikuy_app/app/modules/post/widgets/reply_comment.dart';
import 'package:unsikuy_app/app/modules/post_detail/views/post_image_view.dart';
import 'package:unsikuy_app/app/modules/post_detail/widget/comment_card_detail.dart';
import 'package:unsikuy_app/app/modules/profile/views/profile_view.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

class ContributionDetail extends GetView<PostController> {
  const ContributionDetail({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(Get.arguments['published_at']);

    final postC = Get.put(DiscussionController());
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 28,
        leading: IconButton(
          onPressed: () {
            Get.back();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Reply',
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: AppColors.textColour80),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: controller.scrollC,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: () {
                        // Get.to(ProfileView(
                        //   uuid: Get.arguments['uuid'],
                        // ));
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Hero(
                              tag: 'pp',
                              child: ClipRRect(
                                child: ImageLoad(
                                  shapeImage: ShapeImage.oval,
                                  image: Get.arguments['profilePict'],
                                  placeholder:
                                      AppImages.userPlaceholder.image().image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    Get.arguments['username'],
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
                                    visible: Get.arguments['isVerify'] == true,
                                    child: Icon(
                                      CupertinoIcons.checkmark_seal_fill,
                                      color: Colors.red[900],
                                      size: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                DateFormat.yMMMMEEEEd().format(dateTime),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: AppColors.textColour50,
                                      fontSize: 12,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                DateFormat.Hm().format(dateTime),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: AppColors.textColour50,
                                      fontSize: 12,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    width: 100.w,
                    child: Linkify(
                      text: Get.arguments['text'],
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
                            fontSize: 15,
                            height: 1.5,
                          ),
                      linkStyle:
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      '${Get.arguments['like'].length} people liked this reply',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: AppColors.textColour50),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Divider(
                    height: 2,
                    color: AppColors.gray,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     Row(
                  //       children: [
                  //         InkWell(
                  //             onTap: () {
                  //               controller.likePost(
                  //                 Get.arguments['postId'],
                  //                 postC.auth.currentUser!.uid,
                  //                 Get.arguments['like'],
                  //                 Get.arguments['uuid'],
                  //               );
                  //             },
                  //             child: Obx(() => controller.getUuid.value ==
                  //                     postC.auth.currentUser!.uid
                  //                 ? const Icon(
                  //                     CupertinoIcons.hand_thumbsup_fill,
                  //                     color: AppColors.primaryLight,
                  //                     size: 22,
                  //                   )
                  //                 : Icon(
                  //                     CupertinoIcons.hand_thumbsup,
                  //                     color: AppColors.grey.shade500,
                  //                     size: 22,
                  //                   ))),
                  //       ],
                  //     ),
                  //     const SizedBox(width: 32),
                  //     Row(
                  //       children: [
                  //         InkWell(
                  //           onTap: () {
                  //             controller.focusNode.requestFocus();
                  //           },
                  //           child: Icon(
                  //             CupertinoIcons.chat_bubble,
                  //             color: AppColors.grey.shade500,
                  //             size: 22,
                  //           ),
                  //         ),
                  //         const SizedBox(width: 8),
                  //         // Text(
                  //         //   lengthOfComment.toString(),
                  //         //   style: Theme.of(context)
                  //         //       .textTheme
                  //         //       .bodySmall!
                  //         //       .copyWith(
                  //         //           color: AppColors.textColour50,
                  //         //           fontSize: 12),
                  //         // ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Reply',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  Container(
                    width: 100.w,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('discussion')
                          .doc(Get.arguments['postId'])
                          .collection('contribution')
                          .doc(Get.arguments['commentId'])
                          .collection('reply')
                          .orderBy('published_at', descending: true)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingOverlay();
                        }
                        if (snapshot.data!.docs.length == 0) {
                          return Center(
                            child: Container(
                              width: 150,
                              child: Lottie.asset(
                                  'lib/app/resources/images/not-found.json'),
                            ),
                          );
                        } else {
                          return ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              padding: EdgeInsets.all(16),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return ReplyContributor(
                                  snap: snapshot.data!.docs[index],
                                  controller: postC,
                                  postId: Get.arguments['postId'],
                                );
                              });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    child: ImageLoad(
                      shapeImage: ShapeImage.oval,
                      placeholder: AppImages.userPlaceholder.image().image,
                      image: postC.photoUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 4,
                      controller: postC.commentC,
                      decoration: InputDecoration(
                        hintText: 'Reply this contribution',
                        border: InputBorder.none,
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
                      keyboardType: TextInputType.multiline,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 18),
                    ),
                  )),
                  InkWell(
                    onTap: () {
                      postC.postReplyComment(Get.arguments['postId'],
                          Get.arguments['uuid'], Get.arguments['commentId']);

                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: Text(
                      'Send',
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: AppColors.primaryLight),
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
