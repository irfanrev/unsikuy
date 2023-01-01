import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/post/controllers/post_controller.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';

class PostCardItem extends StatefulWidget {
  final snap;
  final PostController controller;
  PostCardItem({super.key, required this.snap, required this.controller});

  @override
  State<PostCardItem> createState() => _PostCardItemState();
}

class _PostCardItemState extends State<PostCardItem> {
  int lengthOfComment = 0;
  @override
  void initState() {
    // TODO: implement initState
    getCommentLength();
    super.initState();
    print('init post');
  }

  @override
  void dispose() {
    getCommentLength();
    // TODO: implement dispose
    super.dispose();
  }

  void getCommentLength() async {
    try {
      QuerySnapshot qSnap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      lengthOfComment = qSnap.docs.length;
      print(lengthOfComment.toString());
    } catch (e) {
      print(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(widget.snap['published_at']);

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        image: widget.snap['profImg'],
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
                        widget.snap['username'],
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
              Visibility(
                visible: widget.controller.uuidUser == widget.snap['uuid'],
                child: InkWell(
                  onTap: () {
                    if (widget.controller.uuidUser == widget.snap['uuid']) {
                      Get.defaultDialog(
                        titlePadding: EdgeInsets.only(top: 16),
                        title: 'Delete Post?',
                        titleStyle: Theme.of(context).textTheme.headline2,
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
                                widget.controller
                                    .deletePost(widget.snap['postId']);
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
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.snap['description'],
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
                image: widget.snap['postUrl'],
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
                        widget.controller.likePost(
                            widget.snap['postId'],
                            widget.controller.auth.currentUser!.uid,
                            widget.snap['like']);
                      },
                      child: widget.snap['like']
                              .contains(widget.controller.auth.currentUser!.uid)
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
                    '${widget.snap['like'].length}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: AppColors.textColour50),
                  ),
                ],
              ),
              const SizedBox(width: 32),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.toNamed(Routes.COMMENT,
                          arguments: widget.snap['postId'].toString());
                      print(Get.arguments.toString());
                    },
                    child: Icon(
                      CupertinoIcons.chat_bubble,
                      color: AppColors.grey.shade500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    lengthOfComment.toString(),
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
