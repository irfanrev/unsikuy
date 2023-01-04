import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  String? uuID;
  ProfileController({this.uuID});
  //TODO: Implement ProfileController
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GetStorage box = GetStorage();
  var profileData;

  getUsersData() async {
    try {
      User currentUser = _auth.currentUser!;

      var snap = await _firestore.collection('users').doc(uuID).get();

      profileData = snap.data()!;
      update();
    } catch (e) {
      print(e);
    }
  }

  Future logout() async {
    await _auth.signOut();
    box.remove('token');
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> likePost(String postId, String uuid, List like) async {
    try {
      if (like.contains(uuid)) {
        await _firestore.collection('posts').doc(postId).update({
          "like": FieldValue.arrayRemove([uuid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          "like": FieldValue.arrayUnion([uuid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
