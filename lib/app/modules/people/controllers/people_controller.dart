import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PeopleController extends GetxController {
  TextEditingController searchC = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isSearch = false.obs;
  var isConnecters;
  var getResult;
  var parsingStatus = ''.obs;

  Future<void> connectUser(String uuid, String connectId) async {
    try {
      var snap = await _firestore.collection('users').doc(uuid).get();
      List connecters = (snap.data()! as dynamic)['connecters'];
      if (connecters.contains(connectId)) {
        await _firestore.collection('users').doc(connectId).update({
          'connecters': FieldValue.arrayRemove([uuid])
        });
      } else {
        await _firestore.collection('users').doc(connectId).update({
          'connecters': FieldValue.arrayUnion([uuid])
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
