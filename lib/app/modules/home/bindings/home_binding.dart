import 'package:get/get.dart';
import 'package:unsikuy_app/app/modules/chats/controllers/chats_controller.dart';
import 'package:unsikuy_app/app/modules/people/controllers/people_controller.dart';
import 'package:unsikuy_app/app/modules/post/controllers/post_controller.dart';
import 'package:unsikuy_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:unsikuy_app/app/modules/upload/controllers/upload_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<PeopleController>(
      () => PeopleController(),
    );
    Get.lazyPut<PostController>(
      () => PostController(),
    );
    Get.lazyPut<ChatsController>(
      () => ChatsController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<UploadController>(
      () => UploadController(),
    );
  }
}
