import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:unsikuy_app/app/modules/edit_profile/controllers/edit_profile_controller.dart';
import 'package:unsikuy_app/app/modules/edit_profile/views/update_profile.dart';
import 'package:unsikuy_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/primary_button.dart';
import 'package:get/get.dart';

class EditAbout extends StatelessWidget {
  const EditAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.close)),
          title: Text(
            'Edit About',
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: AppColors.textColour80),
          ),
        ),
        body: GetBuilder<EditProfileController>(builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: controller.aboutC,
                  maxLines: 17,
                  decoration: InputDecoration(
                    hintText: controller.aboutC.text != ''
                        ? controller.aboutC.text
                        : 'Write anything about you',
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0,
                        color: AppColors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1,
                          color: AppColors.primaryLight), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(
                  height: 32,
                ),
                PrimaryButton(
                  title: 'Update',
                  onPressed: () {
                    controller.updateAbout();
                  },
                ),
              ],
            ),
          );
        }));
  }
}
