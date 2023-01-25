import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDetailController extends GetxController {
  //TODO: Implement PostDetailController

  FocusNode focusNode = FocusNode();
  ScrollController scrollC = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final count = 0.obs;
  var isLike = false.obs;
  var getLike = 0.obs;
  var getUuid = ''.obs;
  @override
  void onInit() {
    focusNode = FocusNode();
    scrollC = ScrollController();
    super.onInit();
  }

  Future<void> getPostLike(String postID) async {
    DocumentSnapshot snap =
        await _firestore.collection('posts').doc(postID).get();

    getUuid.value = snap['uuid'];
    getLike.value = (snap.data()! as dynamic).length;
  }

  Future<void> likePost(
      String postId, String uuid, List like, String friendUuid) async {
    try {
      if (like.contains(uuid)) {
        await _firestore.collection('posts').doc(postId).update({
          "like": FieldValue.arrayRemove([uuid]),
        });
        isLike.value = false;
      } else {
        await _firestore.collection('posts').doc(postId).update({
          "like": FieldValue.arrayUnion([uuid]),
        });
        isLike.value = true;
      }
      getPostLike(postId);
    } catch (e) {
      print(e.toString());
    }
  }
}
