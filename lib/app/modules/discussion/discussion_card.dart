import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/discussion/controllers/discussion_controller.dart';
import 'package:unsikuy_app/app/modules/profile/views/profile_view.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/bottom_sheet_helper.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:unsikuy_app/app/utils/widgets/primary_button.dart';

class DiscussionCard extends StatefulWidget {
  final snap;
  final DiscussionController controller;
  const DiscussionCard(
      {super.key, required this.snap, required this.controller});

  @override
  State<DiscussionCard> createState() => _DiscussionCardState();
}

class _DiscussionCardState extends State<DiscussionCard> {
  int lengthDis = 0;

  @override
  void initState() {
    getCommentLength();
    super.initState();
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
          .collection('discussion')
          .doc(widget.snap['postId'])
          .collection('contribution')
          .get();
      lengthDis = qSnap.docs.length;
      print(lengthDis.toString());
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
      hoverColor: AppColors.white,
      onTap: () {
        Get.toNamed(Routes.DISCUSS_DETAIL, arguments: {
          'postId': widget.snap['postId'].toString(),
          'img': widget.snap['profImg'].toString(),
          'name': widget.snap['username'].toString(),
          'title': widget.snap['title'].toString(),
          'uuid': widget.snap['uuid'].toString(),
          'isVerify': widget.snap['isVerify'],
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
                          image: widget.snap['profImg'],
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
                          uuid: widget.snap['uuid'],
                        ));
                      },
                      child: Column(
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
                                      color: AppColors.black,
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
                widget.controller.uuidUser == widget.snap['uuid']
                    ? Visibility(
                        visible:
                            widget.controller.uuidUser == widget.snap['uuid'],
                        child: InkWell(
                          onTap: () {
                            if (widget.controller.uuidUser ==
                                widget.snap['uuid']) {
                              Get.defaultDialog(
                                titlePadding: EdgeInsets.only(top: 16),
                                title: 'Delete Discussion?',
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
                                        widget.controller.deleteDiscussion(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
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
                                showBarBottomSheet(context, expand: false,
                                    builder: (context) {
                                  return Container(
                                    width: 100.w,
                                    color: AppColors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
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
                                                  icon: Icon(Icons.close))
                                            ],
                                          ),
                                          Divider(),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            'Why are you reporting this Discussion?',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Obx(
                                            () => ChipsChoice<int>.single(
                                              value:
                                                  widget.controller.tag.value,
                                              onChanged: (val) {
                                                widget.controller.tag.value =
                                                    val;
                                              },
                                              choiceItems: C2Choice.listFrom<
                                                  int, String>(
                                                source:
                                                    widget.controller.options,
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
                                            controller:
                                                widget.controller.reportC,
                                            decoration: InputDecoration(
                                              hintText: 'Enter your reason',
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide
                                                    .none, //<-- SEE HERE
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide
                                                    .none, //<-- SEE HERE
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: AppColors
                                                        .primaryLight), //<-- SEE HERE
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              hintStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.copyWith(
                                                      color: AppColors
                                                          .textColour50,
                                                      fontSize: 16),
                                              filled: true,
                                              fillColor:
                                                  AppColors.grey.shade100,
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(fontSize: 16),
                                            keyboardType: TextInputType.text,
                                          ),
                                          const SizedBox(
                                            height: 32,
                                          ),
                                          PrimaryButton(
                                              title: 'Submit',
                                              onPressed: () => widget.controller
                                                  .sendEmail(
                                                      widget.snap['username'],
                                                      widget.snap['title'])),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(CupertinoIcons.flag),
                              title: Text(
                                'Report Discussion',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                              child: ListTile(
                            onTap: () {
                              Get.defaultDialog(
                                  radius: 8,
                                  titlePadding:
                                      EdgeInsets.symmetric(vertical: 16),
                                  title: 'Block this Discussion?',
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
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  middleText: 'Block this discussion',
                                  middleTextStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  confirm: TextButton(
                                    onPressed: () {
                                      widget.controller.sendEmail(
                                          widget.snap['username'],
                                          widget.snap['title']);
                                      Get.back();
                                    },
                                    child: Text(
                                      'Oke',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ));
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(CupertinoIcons.shield_slash),
                            title: Text(
                              'Block Discussion',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          )),
                        ],
                      ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: 100.w,
              child: Text(
                widget.snap['title'],
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
                        lengthDis.toString(),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: AppColors.textColour50,
                            ),
                      ),
                      const SizedBox(
                        width: 4,
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
