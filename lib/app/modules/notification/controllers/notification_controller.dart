import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  //TODO: Implement NotificationController
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  var photoUrl;
  var username;
  var uuidUser;
  var postID;
  var status;
  var bio;

  RxBool liked = false.obs;

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

    photoUrl = userData['photoUrl'];
    username = userData['username'];
    status = userData['status'];
    bio = userData['bio'];
    uuidUser = currentUser.uid.toString();
  }

  Future<void> deleteNotif(String notifId) async {
    try {
      await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('notification')
          .doc(notifId)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteAllNotif() async {
    try {
      await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('notification')
          .get()
          .then((value) {
        for (DocumentSnapshot ds in value.docs) {
          ds.reference.delete();
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
