import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/model/post.dart';
import 'package:unsikuy_app/app/modules/post/widgets/post_card.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_overlay.dart';
import 'package:unsikuy_app/app/utils/widgets/sm_app_bar.dart';
import 'package:unsikuy_app/app/utils/widgets/state_handle_widget.dart';

import '../controllers/post_controller.dart';

class PostView extends GetView<PostController> {
  const PostView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final queryPost = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('published_at', descending: true)
        .withConverter<Post>(
            fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data()!),
            toFirestore: (post, _) => post.toJson());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Unsika Connect',
          style: Theme.of(context).textTheme.headline4!.copyWith(
                color: AppColors.textColour80,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.SEARCH);
            },
            icon: Icon(
              CupertinoIcons.search,
              color: AppColors.primaryDark,
            ),
          ),
          Visibility(
            visible: (!kIsWeb),
            child: IconButton(
              onPressed: () {
                Get.toNamed(Routes.UPLOAD);
              },
              icon: Icon(
                CupertinoIcons.plus_app,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.NOTIFICATION);
            },
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: FirestoreListView<Post>(
            query: queryPost,
            itemBuilder: (context, snaphot) {
              final post = snaphot.data();
              return PostCardItem(
                snap: post,
                controller: controller,
              );
            }),
      ),
      // body: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      //   child: StreamBuilder(
      //     stream: FirebaseFirestore.instance
      //         .collection('posts')
      //         .orderBy('published_at', descending: true)
      //         .snapshots(),
      //     builder: (context,
      //         AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return LoadingOverlay();
      //       }
      //       return ListView.builder(
      //           padding:
      //               const EdgeInsets.symmetric(horizontal: (kIsWeb) ? 370 : 0),
      //           itemCount: snapshot.data!.docs.length,
      //           itemBuilder: (context, index) {
      //             return PostCardItem(
      //               snap: snapshot.data!.docs[index].data(),
      //               controller: controller,
      //             );
      //           });
      //     },
      //   ),
      // ),
    );
  }
}
