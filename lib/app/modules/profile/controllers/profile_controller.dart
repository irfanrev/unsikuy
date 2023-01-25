import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController
  static ProfileController find = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  GetStorage box = GetStorage();
  var profileData;
  var uuidUser;
  var username;
  var status;
  var profImg;
  var bio;

  @override
  void onInit() {
    // TODO: implement onInit
    getUsersData();
    super.onInit();
  }

  Future getUsersData() async {
    User currentUser = auth.currentUser!;

    DocumentSnapshot userData =
        await _firestore.collection('users').doc(currentUser.uid).get();

    uuidUser = currentUser.uid.toString();
    username = userData['username'];
    status = userData['status'];
    profImg = userData['photoUrl'];
    bio = userData['bio'];
  }

  Future<void> deleteDiscussion(String postId) async {
    try {
      await _firestore.collection('discussion').doc(postId).delete();
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
