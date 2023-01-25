import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/post/controllers/post_controller.dart';
import 'package:unsikuy_app/app/modules/profile/views/profile_view.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/theme/app_theme.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

    return InkWell(
      onTap: () {
        Get.toNamed(Routes.POST_DETAIL, arguments: widget.snap);
      },
      child: Container(
        width: 100.w,
        //padding: const EdgeInsets.all(16),

        // decoration: BoxDecoration(
        //     color: AppColors.white,
        //     border: Border.all(color: AppColors.grey.shade300),
        //     borderRadius: BorderRadius.circular(16),
        //     boxShadow: [
        //       AppElevation.elevation2px,
        //     ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.snap['username'],
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                '~',
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                          Visibility(
                            visible: widget.controller.uuidUser ==
                                widget.snap['uuid'],
                            child: InkWell(
                              onTap: () {
                                if (widget.controller.uuidUser ==
                                    widget.snap['uuid']) {
                                  Get.defaultDialog(
                                    titlePadding: EdgeInsets.only(top: 16),
                                    title: 'Delete Post?',
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
                                            widget.controller.deletePost(
                                                widget.snap['postId']);
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
                      Text(
                        "${DateFormat.yMMMEd().format(dateTime)} on ${DateFormat.Hm().format(dateTime)}",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: AppColors.textColour40, fontSize: 10),
                        textAlign: TextAlign.start,
                      ),
                      Linkify(
                        text: widget.snap['description'],
                        onOpen: (value) async {
                          Uri url = Uri.parse(value.url);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          } else {
                            throw 'Could not launch $value.url';
                          }
                        },
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: AppColors.textColour80,
                              fontSize: 14,
                              height: 1.4,
                            ),
                        linkStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: Colors.blue[800],
                                  fontWeight: FontWeight.bold,
                                  height: 1.4,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Visibility(
                        visible: widget.snap['postUrl'] != '',
                        child: Container(
                          width: Get.width,
                          height: Get.height * 0.35,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: ImageLoad(
                              image: widget.snap['postUrl'],
                              placeholder:
                                  AppImages.imgPlaceholderPrimary.image().image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    widget.controller.likePost(
                                      widget.snap['postId'],
                                      widget.controller.auth.currentUser!.uid,
                                      widget.snap['like'],
                                      widget.snap['uuid'],
                                    );
                                  },
                                  child: widget.snap['like'].contains(widget
                                          .controller.auth.currentUser!.uid)
                                      ? const Icon(
                                          CupertinoIcons.hand_thumbsup_fill,
                                          color: AppColors.primaryLight,
                                          size: 18,
                                        )
                                      : Icon(
                                          CupertinoIcons.hand_thumbsup,
                                          color: AppColors.grey.shade500,
                                          size: 18,
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
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.COMMENT, arguments: {
                                    'postId': widget.snap['postId'].toString(),
                                    'uuid': widget.snap['uuid'].toString(),
                                  });
                                  print(Get.arguments.toString());
                                },
                                child: Icon(
                                  CupertinoIcons.chat_bubble,
                                  color: AppColors.grey.shade500,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                lengthOfComment.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: AppColors.textColour50,
                                        fontSize: 12),
                              ),
                            ],
                          ),
                          // InkWell(
                          //   onTap: () async {
                          //     widget.controller
                          //         .share(widget.snap['description']);
                          //   },
                          //   child: Icon(
                          //     CupertinoIcons.paperplane,
                          //     color: AppColors.grey.shade500,
                          //     size: 18,
                          //   ),
                          // ),
                          const SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
