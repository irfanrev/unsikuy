import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:unsikuy_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:unsikuy_app/app/modules/profile/widgets/profile_usercard.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:get/get.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_overlay.dart';

class ConnectedView extends StatelessWidget {
  const ConnectedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Connecters',
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: AppColors.textColour80),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(Get.arguments)
                .collection('connected')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingOverlay();
              }
              return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    var data = (snapshot.data! as dynamic).docs[index];
                    return ProfileUserCard(snap: data);
                  });
            }),
      ),
    );
  }
}
