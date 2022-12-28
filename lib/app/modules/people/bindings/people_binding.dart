import 'package:get/get.dart';

import '../controllers/people_controller.dart';

class PeopleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PeopleController>(
      () => PeopleController(),
    );
  }
}
