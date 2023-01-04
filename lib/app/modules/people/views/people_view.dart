import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/people/widgets/status_list.dart';
import 'package:unsikuy_app/app/modules/people/widgets/user_card.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
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
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                  child: FormInputFieldWithIcon(
                    controller: controller.searchC,
                    labelText: 'Search for keep connected',
                    onCompleted: (value) {
                      if (value != '') {
                        controller.isSearch = true;
                        controller.parsingStatus = '';
                        controller.update();
                        print(value.toString());
                      } else {
                        controller.isSearch = false;
                      }
                    },
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.slider_horizontal_3,
                      color: AppColors.primaryLight,
                    ))
              ],
            ),
            const SizedBox(
              height: 18,
            ),
            StatusList(),
            const SizedBox(
              height: 18,
            ),
            Expanded(
                child: controller.isSearch == true
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
                    : (controller.parsingStatus == '')
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
                                      });
                                }),
                          )
                        : Container(
                            width: 100.w,
                            child: FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection("users")
                                    .where('username',
                                        isEqualTo: controller.getResult)
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
                                      });
                                }),
                          )),
          ],
        ),
      ),
    );
  }
}
