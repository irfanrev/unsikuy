import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/post/widgets/post_card.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_overlay.dart';
import 'package:unsikuy_app/app/utils/widgets/sm_app_bar.dart';
import 'package:unsikuy_app/app/utils/widgets/state_handle_widget.dart';

import '../controllers/post_controller.dart';

class PostView extends GetView<PostController> {
  const PostView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget clikToPost() {
      return Container(
        width: 100.w,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.shadesPrimaryLight10,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                    child: AppImages.userPlaceholder.image(),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  'What do you think?',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: AppColors.textColour30,
                      ),
                )
              ],
            ),
            const SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.photo_on_rectangle,
                      color: AppColors.primaryLight,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text('Add from Gallery',
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: AppColors.textColour70)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.camera,
                      color: AppColors.primaryLight,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text('Add from Camera',
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: AppColors.textColour70)),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Unsika Connect',
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: AppColors.textColour80),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.search,
              color: AppColors.primaryDark,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.bell,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('published_at', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingOverlay();
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return PostCardItem(
                    snap: snapshot.data!.docs[index].data(),
                    controller: controller,
                  );
                });
          },
        ),
      ),
    );
  }
}
