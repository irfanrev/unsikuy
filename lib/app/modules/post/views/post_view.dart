import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:unsikuy_app/app/utils/widgets/sm_app_bar.dart';

import '../controllers/post_controller.dart';

class PostView extends GetView<PostController> {
  const PostView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SMAppBar(
        body: SingleChildScrollView(
      child: Column(
        children: [Text('data')],
      ),
    ));
  }
}
