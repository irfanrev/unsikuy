import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/discussion/controllers/discussion_controller.dart';
import 'package:unsikuy_app/app/modules/post/controllers/post_controller.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/bottom_sheet_helper.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:unsikuy_app/app/utils/widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ReplyContributor extends StatefulWidget {
  final snap;
  final String postId;
  final DiscussionController controller;
  const ReplyContributor(
      {super.key,
      required this.snap,
      required this.controller,
      required this.postId});

  @override
  State<ReplyContributor> createState() => _ReplyContributorState();
}

class _ReplyContributorState extends State<ReplyContributor> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(widget.snap['published_at']);

    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.snap['profilePict'],
                    imageBuilder: (context, imgProvider) => Container(
                      width: 42,
                      height: 42,
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
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AppImages.userPlaceholder.image().image,
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  // Container(
                  //   height: 50,
                  //   width: 1.2,
                  //   color: AppColors.grey.shade300,
                  // ),
                ],
              ),
              const SizedBox(
                width: 6,
              ),
              Expanded(
                child: Container(
                  width: 100.w,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.snap['username'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(
                                          color: AppColors.textColour80,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Visibility(
                                    visible: widget.snap['isVerify'] == true,
                                    child: Icon(
                                      CupertinoIcons.checkmark_seal_fill,
                                      color: Colors.red[900],
                                      size: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "${DateFormat.yMMMEd().format(dateTime)} on ${DateFormat.Hm().format(dateTime)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: AppColors.textColour50,
                                      fontSize: 11,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          widget.controller.uuidUser == widget.snap['uuid']
                              ? Visibility(
                                  visible: widget.controller.uuidUser ==
                                      widget.snap['uuid'],
                                  child: InkWell(
                                    onTap: () {
                                      if (widget.controller.uuidUser ==
                                          widget.snap['uuid']) {
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
                                                      'Delete Reply?',
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
                                                            .deleteReply(
                                                          widget.postId,
                                                          widget.snap[
                                                              'commentId'],
                                                          widget
                                                              .snap['replyId'],
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
                                                      'Why are you reporting this reply?',
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
                                                          source: widget
                                                              .controller
                                                              .options,
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
                                                              widget.snap[
                                                                  'username'],
                                                              widget.snap[
                                                                  'text']),
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
                                          'Report reply',
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
                                            title: 'Block this reply?',
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
                                            middleText: 'Block this reply',
                                            middleTextStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                            confirm: TextButton(
                                              onPressed: () {
                                                widget.controller.sendEmail(
                                                    widget.snap['username'],
                                                    widget.snap['text']);
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
                                        'Block reply',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ))
                                  ],
                                ),
                          // Icon(
                          //   CupertinoIcons.hand_thumbsup,
                          //   size: 20,
                          //   color: AppColors.grey.shade500,
                          // )
                        ],
                      ),
                      Linkify(
                        text: widget.snap['text'],
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
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          const SizedBox(
            height: 3,
          ),
        ],
      ),
    );
  }
}
