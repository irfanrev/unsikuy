import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GetStorage box = GetStorage();

  Future logout() async {
    await _auth.signOut();
    box.remove('token');
    Get.offAllNamed(Routes.LOGIN);
  }
}
