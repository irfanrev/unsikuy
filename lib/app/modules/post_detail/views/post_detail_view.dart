import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/post/controllers/post_controller.dart';
import 'package:unsikuy_app/app/modules/post_detail/views/post_image_view.dart';
import 'package:unsikuy_app/app/modules/post_detail/widget/comment_card_detail.dart';
import 'package:unsikuy_app/app/modules/profile/views/profile_view.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/post_detail_controller.dart';

class PostDetailView extends GetView<PostDetailController> {
  const PostDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(Get.arguments['published_at']);
    final postC = Get.put(PostController());
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
          'Sharing',
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
                        Get.to(ProfileView(
                          uuid: Get.arguments['uuid'],
                        ));
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: ClipRRect(
                              child: ImageLoad(
                                shapeImage: ShapeImage.oval,
                                image: Get.arguments['profImg'],
                                placeholder:
                                    AppImages.userPlaceholder.image().image,
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
                                Get.arguments['username'],
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                DateFormat.yMMMMEEEEd().format(dateTime),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: AppColors.textColour50,
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
                      text: Get.arguments['description'],
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
                  Visibility(
                    visible: Get.arguments['postUrl'] != '',
                    child: InkWell(
                      onTap: () {
                        Get.to(PostImageView(image: Get.arguments['postUrl']));
                        // Get.defaultDialog(
                        //   content: PostImageView(image: Get.arguments['postUrl']),
                        // );
                      },
                      child: Container(
                        width: 100.w,
                        child: Image.network(
                          Get.arguments['postUrl'],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Total Like ${Get.arguments['like'].length}',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                postC.likePost(
                                  Get.arguments['postId'],
                                  postC.auth.currentUser!.uid,
                                  Get.arguments['like'],
                                );
                              },
                              child: Get.arguments['like']
                                      .contains(postC.auth.currentUser!.uid)
                                  ? const Icon(
                                      CupertinoIcons.hand_thumbsup_fill,
                                      color: AppColors.primaryLight,
                                      size: 22,
                                    )
                                  : Icon(
                                      CupertinoIcons.hand_thumbsup,
                                      color: AppColors.grey.shade500,
                                      size: 22,
                                    )),
                        ],
                      ),
                      const SizedBox(width: 32),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              controller.focusNode.requestFocus();
                            },
                            child: Icon(
                              CupertinoIcons.chat_bubble,
                              color: AppColors.grey.shade500,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Text(
                          //   lengthOfComment.toString(),
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .bodySmall!
                          //       .copyWith(
                          //           color: AppColors.textColour50,
                          //           fontSize: 12),
                          // ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Comments',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  Container(
                    width: 100.w,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(Get.arguments['postId'])
                          .collection('comments')
                          .orderBy('published_at', descending: true)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingOverlay();
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            padding: EdgeInsets.all(16),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return CommentCardDetail(
                                snap: snapshot.data!.docs[index],
                                controller: postC,
                                postID: Get.arguments['postId'],
                              );
                            });
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
                      controller: postC.commentC,
                      decoration: InputDecoration(
                        hintText: 'Comment as ${postC.username}',
                        border: InputBorder.none,
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 18),
                    ),
                  )),
                  InkWell(
                    onTap: () {
                      postC.postComment(Get.arguments['postId']);
                      postC.commentC.text = '';
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
