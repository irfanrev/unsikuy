import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:unsikuy_app/app/modules/edit_profile/controllers/edit_profile_controller.dart';
import 'package:unsikuy_app/app/modules/edit_profile/views/update_profile.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/primary_button.dart';

class UpdateBio extends StatelessWidget {
  const UpdateBio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Update Bio',
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
                  controller: controller.bioC,
                  maxLines: 10,
                  maxLength: 160,
                  decoration: InputDecoration(
                    hintText:
                        controller.bioC.text != '' ? controller.bioC.text : '',
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
                    controller.updateBio();
                  },
                ),
              ],
            ),
          );
        }));
  }
}
