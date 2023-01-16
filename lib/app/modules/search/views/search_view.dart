import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/search/widgets/post_search_card.dart';
import 'package:unsikuy_app/app/utils/widgets/form/form_input_field_with_icon.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_overlay.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 28,
        title: FormInputFieldWithIcon(
          controller: controller.searchC,
          labelText: 'Search post',
          onCompleted: (value) {
            if (value != '') {
              print(value.toString());
              controller.isSearch.value = true;
            } else {
              controller.isSearch.value = false;
            }
          },
        ),
      ),
      body: Obx(
        () => controller.isSearch.value == true
            ? Container(
                width: 100.w,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("posts")
                        .where("description",
                            isGreaterThanOrEqualTo: controller.searchC.text)
                        .where('description',
                            isLessThan: controller.searchC.text + 'z')
                        .orderBy("description", descending: true)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return LoadingOverlay();
                      }
                      return ListView.builder(
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          itemBuilder: (context, index) {
                            return PostSearchCard(
                              snap: (snapshot.data! as dynamic).docs[index],
                              controller: controller,
                            );
                          });
                    }),
              )
            : Center(
                child: Container(
                  width: 200,
                  child: Lottie.asset('lib/app/resources/images/emptybox.json'),
                ),
              ),
      ),
    );
  }
}

class AppColors {}
