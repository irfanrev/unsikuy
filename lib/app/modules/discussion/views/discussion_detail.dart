import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/discussion/contributor_card.dart';
import 'package:unsikuy_app/app/modules/discussion/controllers/discussion_controller.dart';
import 'package:unsikuy_app/app/modules/post/controllers/post_controller.dart';
import 'package:unsikuy_app/app/modules/post/widgets/comment_card.dart';
import 'package:unsikuy_app/app/modules/profile/views/profile_view.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:get/get.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_overlay.dart';

class DiscussionDetail extends StatelessWidget {
  const DiscussionDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final String username = (Get.arguments as Map<String, dynamic>)['name'];
    final String postId = (Get.arguments as Map<String, dynamic>)['postId'];
    final String img = (Get.arguments as Map<String, dynamic>)['img'];
    final String title = (Get.arguments as Map<String, dynamic>)['title'];
    var date = (Get.arguments as Map<String, dynamic>)['date'];
    final String uuid = (Get.arguments as Map<String, dynamic>)['uuid'];
    var isVerify = (Get.arguments as Map<String, dynamic>)['isVerify'];
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () => Get.back(), child: Icon(Icons.arrow_back_ios_new)),
          title: Text(
            'Main Discussion',
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(color: AppColors.textColour80),
          ),
        ),
        body: GetBuilder<DiscussionController>(builder: (controller) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: (kIsWeb) ? 320 : 0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: ClipRRect(
                                    child: ImageLoad(
                                      shapeImage: ShapeImage.oval,
                                      image: img,
                                      placeholder: AppImages.userPlaceholder
                                          .image()
                                          .image,
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
                                      uuid: uuid,
                                    ));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            username,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4!
                                                .copyWith(
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Visibility(
                                            visible: isVerify == true,
                                            child: Icon(
                                              CupertinoIcons
                                                  .checkmark_seal_fill,
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
                                        "${DateFormat.yMMMEd().format(date)} on ${DateFormat.Hm().format(date)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              color: AppColors.textColour50,
                                            ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        width: 100.w,
                        child: Text(
                          title,
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    color: AppColors.black,
                                    fontSize: 18,
                                    height: 1.4,
                                  ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Divider(
                        color: AppColors.grey.shade200,
                        indent: 2,
                        thickness: 1.2,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 16, top: 8),
                        width: 100.w,
                        child: Text(
                          'Contribution',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: AppColors.textColour80),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        width: 100.w,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('discussion')
                              .doc(postId)
                              .collection('contribution')
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
                                  primary: false,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(16),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    return ContributorCard(
                                      snap: snapshot.data!.docs[index],
                                      controller: controller,
                                      posId: postId,
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
                padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: (kIsWeb) ? 320 : 16),
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        child: ImageLoad(
                          shapeImage: ShapeImage.oval,
                          placeholder: AppImages.userPlaceholder.image().image,
                          image: controller.photoUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 4,
                          controller: controller.commentC,
                          decoration: InputDecoration(
                            hintText: 'Contribute as ${controller.username}',
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 18),
                        ),
                      )),
                      InkWell(
                        onTap: () {
                          controller.postDiscussion(postId, uuid);
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
          );
        }));
  }
}
