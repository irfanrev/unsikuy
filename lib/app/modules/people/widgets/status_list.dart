import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/people/controllers/people_controller.dart';
import 'package:unsikuy_app/app/resources/resource.dart';

class StatusList extends StatelessWidget {
  const StatusList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PeopleController>(builder: (controller) {
      return Container(
        width: 100.w,
        height: 38,
        child: FutureBuilder(
            future: FirebaseFirestore.instance.collection('status').get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox(
                  width: 100.w,
                  height: 30,
                  child: Shimmer.fromColors(
                      child: Container(
                        width: 100.w,
                        height: 30,
                      ),
                      baseColor: AppColors.grey.shade400,
                      highlightColor: AppColors.white),
                );
              }
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    final statusData = (snapshot.data! as dynamic).docs[index];
                    return InkWell(
                      onTap: () {
                        controller.parsingStatus.value = statusData['title'];
                        controller.isSearch.value = false;
                        controller.searchC.text = '';
                        controller.update();
                        controller.refresh();
                        print(controller.parsingStatus.value.toString());
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        margin: EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: controller.parsingStatus.value ==
                                    statusData['title']
                                ? AppColors.primaryLight
                                : AppColors.white,
                            border: Border.all(
                                color: controller.parsingStatus.value ==
                                        statusData['title']
                                    ? AppColors.primaryLight
                                    : AppColors.grey.shade300)),
                        child: Builder(builder: (context) {
                          return Center(
                            child: Text(
                              statusData['title'],
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    color: controller.parsingStatus.value ==
                                            statusData['title']
                                        ? AppColors.white
                                        : AppColors.textColour70,
                                  ),
                            ),
                          );
                        }),
                      ),
                    );
                  });
            }),
      );
    });
  }
}
