import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/model/post.dart';
import 'package:unsikuy_app/app/modules/post/controllers/post_controller.dart';
import 'package:unsikuy_app/app/modules/profile/views/profile_view.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/theme/app_theme.dart';
import 'package:unsikuy_app/app/utils/widgets/bottom_sheet_helper.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:unsikuy_app/app/utils/widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PostCardItem extends StatefulWidget {
  final Post snap;
  final PostController controller;
  PostCardItem({super.key, required this.snap, required this.controller});

  @override
  State<PostCardItem> createState() => _PostCardItemState();
}

class _PostCardItemState extends State<PostCardItem> {
  int lengthOfComment = 0;
  bool isSelected = false;
  int tag = 1;
  List<String> tags = [];
  List<String> options = [
    'Spam',
    'Plagiarism',
    'Inappropriate',
  ];
  @override
  void initState() {
    // TODO: implement initState
    getCommentLength();
    super.initState();
    print('init post');
  }

  void getCommentLength() async {
    try {
      QuerySnapshot qSnap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap.postId)
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
    DateTime dateTime = DateTime.parse(widget.snap.publishedAt.toString());

    return InkWell(
      hoverColor: AppColors.white,
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
                (!kIsWeb)
                    ? CachedNetworkImage(
                        imageUrl: widget.snap.profImg.toString(),
                        imageBuilder: (context, imgProvider) => Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imgProvider, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AppImages.userPlaceholder.image().image,
                                fit: BoxFit.cover),
                          ),
                        ),
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          widget.snap.profImg.toString(),
                          fit: BoxFit.cover,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.snap.username!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Visibility(
                                    visible: widget.snap.isVerify == true,
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: AppColors.textColour40,
                                        fontSize: 11),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          widget.controller.uuidUser == widget.snap.uuid
                              ? Visibility(
                                  visible: widget.controller.uuidUser ==
                                      widget.snap.uuid,
                                  child: InkWell(
                                    onTap: () {
                                      if (widget.controller.uuidUser ==
                                          widget.snap.uuid) {
                                        showBarModalBottomSheet(
                                            //constraints: BoxConstraints(maxHeight: 300),
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                width: 100.w,
                                                height: 160,
                                                padding: EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Delete this Post?',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4!
                                                          .copyWith(
                                                            color:
                                                                AppColors.black,
                                                            fontSize: 18,
                                                          ),
                                                    ),
                                                    const SizedBox(
                                                      height: 18,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        widget.controller
                                                            .deletePost(
                                                          widget.snap.postId!,
                                                          widget.snap.uuid!,
                                                          widget.snap.postUrl!,
                                                        );
                                                        Get.back();
                                                      },
                                                      child: Container(
                                                        width: 100.w,
                                                        height: 45,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(22),
                                                          color: AppColors
                                                              .primaryLight,
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          'Oke',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline5!
                                                                  .copyWith(
                                                                    color: AppColors
                                                                        .white,
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
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14),
                                      child: Icon(
                                        CupertinoIcons.ellipsis_vertical,
                                        size: 15,
                                        color: AppColors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                )
                              : PopupMenuButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 16,
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: ListTile(
                                        onTap: () {
                                          showBarBottomSheet(context,
                                              expand: false,
                                              builder: (context) {
                                            return Container(
                                              width: 100.w,
                                              color: AppColors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            icon: Icon(
                                                                Icons.close))
                                                      ],
                                                    ),
                                                    Divider(),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    Text(
                                                      'Why are you reporting this Sharing?',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    Obx(
                                                      () => ChipsChoice<
                                                          int>.single(
                                                        value: widget.controller
                                                            .tag.value,
                                                        onChanged: (val) {
                                                          widget.controller.tag
                                                              .value = val;
                                                        },
                                                        choiceItems:
                                                            C2Choice.listFrom<
                                                                int, String>(
                                                          source: options,
                                                          value: (i, v) => i,
                                                          label: (i, v) => v,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    Text(
                                                      'Other reason',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline5,
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    TextFormField(
                                                      controller: widget
                                                          .controller.reportC,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Enter your reason',
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide
                                                              .none, //<-- SEE HERE
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide
                                                              .none, //<-- SEE HERE
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width: 1,
                                                              color: AppColors
                                                                  .primaryLight), //<-- SEE HERE
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        hintStyle: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .bodyText1
                                                            ?.copyWith(
                                                                color: AppColors
                                                                    .textColour50,
                                                                fontSize: 16),
                                                        filled: true,
                                                        fillColor: AppColors
                                                            .grey.shade100,
                                                      ),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                              fontSize: 16),
                                                      keyboardType:
                                                          TextInputType.text,
                                                    ),
                                                    const SizedBox(
                                                      height: 32,
                                                    ),
                                                    PrimaryButton(
                                                      title: 'Submit',
                                                      onPressed: () => widget
                                                          .controller
                                                          .sendEmail(
                                                              widget.snap
                                                                  .username!,
                                                              widget.snap
                                                                  .description!),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                        },
                                        contentPadding: EdgeInsets.zero,
                                        leading: Icon(CupertinoIcons.flag),
                                        title: Text(
                                          'Report sharing',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                        child: ListTile(
                                      onTap: () {
                                        Get.defaultDialog(
                                            radius: 8,
                                            titlePadding: EdgeInsets.symmetric(
                                                vertical: 16),
                                            title: 'Block this Sharing?',
                                            titleStyle: Theme.of(context)
                                                .textTheme
                                                .headline4!
                                                .copyWith(
                                                  color: AppColors.black,
                                                ),
                                            cancel: TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                            ),
                                            middleText:
                                                'Block this sharing or thread',
                                            middleTextStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                            confirm: TextButton(
                                              onPressed: () {
                                                widget.controller.blockSharing(
                                                    widget.snap.username!,
                                                    widget.snap.description!);
                                                Get.back();
                                              },
                                              child: Text(
                                                'Oke',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                            ));
                                      },
                                      contentPadding: EdgeInsets.zero,
                                      leading:
                                          Icon(CupertinoIcons.shield_slash),
                                      title: Text(
                                        'Block sharing',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ))
                                  ],
                                ),
                        ],
                      ),
                      Linkify(
                        text: widget.snap.description!,
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
                              fontSize: 15,
                              height: 1.4,
                            ),
                        linkStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: Colors.blue[800],
                                  fontWeight: FontWeight.bold,
                                  height: 1.4,
                                ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Visibility(
                        visible: widget.snap.postUrl.toString() != '',
                        child: Container(
                          width: Get.width,
                          height: Get.height * 0.35,
                          child: (!kIsWeb)
                              ? CachedNetworkImage(
                                  imageUrl: widget.snap.postUrl.toString(),
                                  imageBuilder: (context, imageProvider) =>
                                      ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      width: Get.width,
                                      height: Get.height * 0.35,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child:
                                        AppImages.imgPlaceholderPrimary.image(
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      AppImages.imgPlaceholderPrimary.image(
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    width: Get.width,
                                    height: Get.height * 0.35,
                                    child: Image.network(
                                      widget.snap.postUrl.toString(),
                                      fit: BoxFit.cover,
                                    ),
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
                                    widget.snap.postId!,
                                    widget.controller.auth.currentUser!.uid,
                                    widget.snap.like!,
                                    widget.snap.uuid!,
                                  );
                                },
                                child: widget.snap.like.contains(
                                        widget.controller.auth.currentUser!.uid)
                                    ? const Icon(
                                        CupertinoIcons.hand_thumbsup_fill,
                                        color: AppColors.primaryLight,
                                        size: 20,
                                      )
                                    : Icon(
                                        CupertinoIcons.hand_thumbsup,
                                        color: AppColors.grey.shade500,
                                        size: 20,
                                      ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.snap.like.length}',
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
                                  onTap: () async {
                                    widget.controller.upPost(
                                      widget.snap.postId!,
                                      widget.controller.auth.currentUser!.uid,
                                      widget.snap.upPost!,
                                      widget.snap.uuid!,
                                    );
                                  },
                                  child: widget.snap.upPost.contains(widget
                                          .controller.auth.currentUser!.uid)
                                      ? const Icon(
                                          CupertinoIcons.arrow_up_circle_fill,
                                          color: AppColors.primaryLight,
                                          size: 20,
                                        )
                                      : Icon(
                                          CupertinoIcons.arrow_up_circle,
                                          color: AppColors.grey.shade500,
                                          size: 20,
                                        )),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.snap.upPost.length}',
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
                                    'postId': widget.snap.postId.toString(),
                                    'uuid': widget.snap.uuid.toString(),
                                  });
                                  print(Get.arguments.toString());
                                },
                                child: Icon(
                                  CupertinoIcons.chat_bubble,
                                  color: AppColors.grey.shade500,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                lengthOfComment.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: AppColors.textColour50,
                                    ),
                              ),
                            ],
                          ),
                          // InkWell(
                          //   onTap: () async {
                          //     widget.controller.savePost(
                          //         widget.snap['postId'],
                          //         widget.snap['username'],
                          //         widget.snap.description!,
                          //         widget.snap['published_at'],
                          //         widget.snap['uuid'],
                          //         widget.snap['postUrl'],
                          //         widget.snap['profImg'],
                          //         widget.snap['isVerify'].toString(),
                          //         widget.snap['like'],
                          //         widget.snap['upPost']);
                          //   },
                          //   child: Icon(
                          //     CupertinoIcons.bookmark,
                          //     color: AppColors.grey.shade500,
                          //     size: 20,
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
