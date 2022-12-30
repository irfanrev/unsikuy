import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostController extends GetxController {
  //TODO: Implement PostController
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  RxBool liked = false.obs;

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
