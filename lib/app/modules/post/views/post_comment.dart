import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unsikuy_app/app/modules/post/controllers/post_controller.dart';
import 'package:unsikuy_app/app/modules/post/widgets/comment_card.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:get/get.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_overlay.dart';

class PostComment extends StatelessWidget {
  const PostComment({super.key});

  @override
  Widget build(BuildContext context) {
    final String postId = (Get.arguments as Map<String, dynamic>)['postId'];
    final String uuid = (Get.arguments as Map<String, dynamic>)['uuid'];

    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () => Get.back(), child: Icon(Icons.arrow_back_ios_new)),
          title: Text(
            'Comments',
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(color: AppColors.textColour80),
          ),
        ),
        body: GetBuilder<PostController>(builder: (controller) {
          return Column(
            children: [
              Expanded(
                child: SizedBox.expand(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('comments')
                        .orderBy('published_at', descending: true)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingOverlay();
                      }
                      return ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return CommentCard(
                              snap: snapshot.data!.docs[index],
                              controller: controller,
                              postId: postId,
                            );
                          });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
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
                            hintText: 'Comment as ${controller.username}',
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
                          controller.postComment(postId, uuid);
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
