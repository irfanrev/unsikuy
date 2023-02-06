import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:unsikuy_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:unsikuy_app/app/modules/profile/widgets/mydiscuss_card.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_overlay.dart';
import 'package:get/get.dart';

class MydiscussionView extends StatelessWidget {
  const MydiscussionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discussion',
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: AppColors.textColour80),
        ),
        centerTitle: false,
      ),
      body: GetBuilder<ProfileController>(builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('discussion')
                .where('uuid', isEqualTo: Get.arguments)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingOverlay();
              }
              if ((snapshot.data! as dynamic).docs.length == 0) {
                return Center(
                  child: Container(
                    width: 150,
                    child:
                        Lottie.asset('lib/app/resources/images/not-found.json'),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return MydiscussCard(
                        snap: (snapshot.data! as dynamic).docs[index],
                        controller: controller,
                      );
                    });
              }
            },
          ),
        );
      }),
    );
  }
}
