import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/people/widgets/status_list.dart';
import 'package:unsikuy_app/app/modules/people/widgets/user_card.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/form/form_input_field_with_icon.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_overlay.dart';

import '../controllers/people_controller.dart';

class PeopleView extends GetView<PeopleController> {
  const PeopleView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discover Connecters',
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: AppColors.textColour80),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    labelText: 'Search for keep connected',
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
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 18,
            ),
            StatusList(),
            const SizedBox(
              height: 24,
            ),
            Expanded(
                child: Obx(() => controller.isSearch.value == true
                    ? Container(
                        width: 100.w,
                        child: FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection("users")
                                .where("username",
                                    isGreaterThanOrEqualTo:
                                        controller.searchC.text)
                                .where('username',
                                    isLessThan: controller.searchC.text + 'z')
                                .orderBy("username", descending: true)
                                .get(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return LoadingOverlay();
                              }
                              return ListView.builder(
                                  itemCount:
                                      (snapshot.data! as dynamic).docs.length,
                                  itemBuilder: (context, index) {
                                    return UserCard(
                                      snap: (snapshot.data! as dynamic)
                                          .docs[index],
                                    );
                                  });
                            }),
                      )
                    : controller.parsingStatus.value == ''
                        ? Container(
                            width: 100.w,
                            child: FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection("users")
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return LoadingOverlay();
                                  }
                                  return ListView.builder(
                                      itemCount: (snapshot.data! as dynamic)
                                          .docs
                                          .length,
                                      itemBuilder: (context, index) {
                                        return UserCard(
                                          snap: (snapshot.data! as dynamic)
                                              .docs[index],
                                        );
                                        // return Text((snapshot.data! as dynamic)
                                        //     .docs[index]['username']
                                        //     .toString());
                                      });
                                }),
                          )
                        : Container(
                            width: 100.w,
                            child: FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection("users")
                                    .where('status',
                                        isEqualTo:
                                            controller.parsingStatus.value)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return LoadingOverlay();
                                  }
                                  return ListView.builder(
                                      itemCount: (snapshot.data! as dynamic)
                                          .docs
                                          .length,
                                      itemBuilder: (context, index) {
                                        return UserCard(
                                          snap: (snapshot.data! as dynamic)
                                              .docs[index],
                                        );
                                        // return Text((snapshot.data! as dynamic)
                                        //     .docs[index]['username']
                                        //     .toString());
                                      });
                                }),
                          ))),
          ],
        ),
      ),
    );
  }
}
