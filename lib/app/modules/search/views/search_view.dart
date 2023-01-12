import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
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
              controller.isSearch = true;
            } else {
              controller.isSearch = false;
            }
          },
        ),
      ),
      body: controller.isSearch
          ? Container(
              width: 100.w,
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
              child: Text('Kosong nihh'),
            ),
    );
  }
}

class AppColors {}
