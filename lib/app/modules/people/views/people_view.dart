import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/model/user.dart';
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
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FormInputFieldWithIcon(
                    keyboardType: TextInputType.text,
                    controller: controller.searchC,
                    labelText: 'Search user by first keyword',
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
              height: 10,
            ),
            StatusList(),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Obx(() => controller.isSearch.value == true
                  ? Container(
                      width: 100.w,
                      child: FirestoreListView<User>(
                          query: FirebaseFirestore.instance
                              .collection('users')
                              .where("username",
                                  isGreaterThanOrEqualTo:
                                      controller.searchC.text)
                              .where('username',
                                  isLessThan: controller.searchC.text + 'z')
                              .orderBy("username", descending: true)
                              .withConverter<User>(
                                  fromFirestore: (snapshot, _) =>
                                      User.fromJson(snapshot.data()!),
                                  toFirestore: (post, _) => post.toJson()),
                          itemBuilder: (context, snaphot) {
                            final users = snaphot.data();
                            return UserCard(
                              snap: users,
                            );
                          }),
                      // child: FutureBuilder(
                      //     future: FirebaseFirestore.instance
                      //         .collection("users")
                      //         .where("username",
                      //             isGreaterThanOrEqualTo:
                      //                 controller.searchC.text)
                      //         .where('username',
                      //             isLessThan: controller.searchC.text + 'z')
                      //         .orderBy("username", descending: true)
                      //         .get(),
                      //     builder: (context, snapshot) {
                      //       if (!snapshot.hasData) {
                      //         return LoadingOverlay();
                      //       }
                      //       return ListView.builder(
                      //           shrinkWrap: true,
                      //           primary: false,
                      //           itemCount:
                      //               (snapshot.data! as dynamic).docs.length,
                      //           itemBuilder: (context, index) {
                      //             return UserCard(
                      //               snap:
                      //                   (snapshot.data! as dynamic).docs[index],
                      //             );
                      //           });
                      //     }),
                    )
                  : controller.parsingStatus.value == ''
                      ? Container(
                          width: 100.w,
                          child: FirestoreListView<User>(
                              query: FirebaseFirestore.instance
                                  .collection('users')
                                  .withConverter<User>(
                                      fromFirestore: (snapshot, _) =>
                                          User.fromJson(snapshot.data()!),
                                      toFirestore: (post, _) => post.toJson()),
                              itemBuilder: (context, snaphot) {
                                final users = snaphot.data();
                                return UserCard(
                                  snap: users,
                                );
                              }),
                          // child: FutureBuilder(
                          //     future: FirebaseFirestore.instance
                          //         .collection("users")
                          //         .get(),
                          //     builder: (context, snapshot) {
                          //       if (snapshot.connectionState ==
                          //           ConnectionState.waiting) {
                          //         return LoadingOverlay();
                          //       }
                          //       return ListView.builder(
                          //           shrinkWrap: true,
                          //           primary: false,
                          //           itemCount:
                          //               (snapshot.data! as dynamic).docs.length,
                          //           itemBuilder: (context, index) {
                          //             return UserCard(
                          //               snap: (snapshot.data! as dynamic)
                          //                   .docs[index],
                          //             );
                          //             // return Text((snapshot.data! as dynamic)
                          //             //     .docs[index]['username']
                          //             //     .toString());
                          //           });
                          //     }),
                        )
                      : Container(
                          width: 100.w,
                          child: FirestoreListView<User>(
                              query: FirebaseFirestore.instance
                                  .collection('users')
                                  .where('status',
                                      isEqualTo: controller.parsingStatus.value)
                                  .withConverter<User>(
                                      fromFirestore: (snapshot, _) =>
                                          User.fromJson(snapshot.data()!),
                                      toFirestore: (post, _) => post.toJson()),
                              itemBuilder: (context, snaphot) {
                                final users = snaphot.data();
                                return UserCard(
                                  snap: users,
                                );
                              }),
                          // child: FutureBuilder(
                          //     future: FirebaseFirestore.instance
                          //         .collection("users")
                          //         .where('status',
                          //             isEqualTo: controller.parsingStatus.value)
                          //         .get(),
                          //     builder: (context, snapshot) {
                          //       if (snapshot.connectionState ==
                          //           ConnectionState.waiting) {
                          //         return LoadingOverlay();
                          //       }
                          //       return ListView.builder(
                          //           shrinkWrap: true,
                          //           primary: false,
                          //           itemCount:
                          //               (snapshot.data! as dynamic).docs.length,
                          //           itemBuilder: (context, index) {
                          //             return UserCard(
                          //               snap: (snapshot.data! as dynamic)
                          //                   .docs[index],
                          //             );
                          //             // return Text((snapshot.data! as dynamic)
                          //             //     .docs[index]['username']
                          //             //     .toString());
                          //           });
                          //     }),
                        )),
            ),
          ],
        ),
      ),
    );
  }
}
