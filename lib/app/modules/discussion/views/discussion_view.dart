import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/discussion/discussion_card.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/form/form_input_field_with_icon.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_overlay.dart';

import '../controllers/discussion_controller.dart';

class DiscussionView extends StatelessWidget {
  const DiscussionView({Key? key}) : super(key: key);
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
      body: GetBuilder<DiscussionController>(
        init: DiscussionController(),
        builder: (controller) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: (kIsWeb) ? 320 : 0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FormInputFieldWithIcon(
                            keyboardType: TextInputType.text,
                            controller: controller.searchC,
                            labelText: 'Search by first keyword',
                            onCompleted: (value) {
                              if (value != '') {
                                controller.isSearch.value = true;
                                controller.parsingStatus.value = '';
                                controller.update();
                                print(value.toString());
                              } else {
                                controller.isSearch.value = false;
                              }
                            },
                            onClear: () {
                              controller.searchC.clear();
                              controller.isSearch.value = false;
                              controller.update();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: 100.w,
                      child: controller.isSearch.value == true
                          ? StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('discussion')
                                  .where("title",
                                      isGreaterThanOrEqualTo:
                                          controller.searchC.text)
                                  .where('title',
                                      isLessThan: controller.searchC.text + 'z')
                                  .orderBy("title", descending: true)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return LoadingOverlay();
                                }
                                return ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      return DiscussionCard(
                                        snap: snapshot.data!.docs[index].data(),
                                        controller: controller,
                                      );
                                    });
                              },
                            )
                          : StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('discussion')
                                  .orderBy('published_at', descending: true)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return LoadingOverlay();
                                }
                                return ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      return DiscussionCard(
                                        snap: snapshot.data!.docs[index].data(),
                                        controller: controller,
                                      );
                                    });
                              },
                            ),
                    ),
                  ],
                ),
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryDark,
        onPressed: () {
          Get.toNamed(Routes.UPLOAD_DISCUSS);
        },
        child: Center(
          child: Icon(
            Icons.add,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
