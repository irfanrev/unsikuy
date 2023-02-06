import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/edit_profile/controllers/edit_profile_controller.dart';
import 'package:unsikuy_app/app/modules/edit_profile/widgets/form_edit_profile.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:get/get.dart';
import 'package:unsikuy_app/app/utils/widgets/primary_button.dart';

class AddSocialMedia extends StatelessWidget {
  const AddSocialMedia({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Social Media',
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: AppColors.textColour80),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GetBuilder<EditProfileController>(builder: (controller) {
              return Container(
                width: 100.w,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Instagram",
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      color: AppColors.textColour70,
                                      fontSize: 18,
                                    ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 6),
                          TextFormField(
                            controller: controller.igC,
                            decoration: InputDecoration(
                              hintText: 'Enter your Instagram profile',
                              prefixIcon: Container(
                                margin: EdgeInsets.all(10),
                                child: FaIcon(
                                  FontAwesomeIcons.instagram,
                                  size: 28,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide.none, //<-- SEE HERE
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none, //<-- SEE HERE
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color:
                                        AppColors.primaryLight), //<-- SEE HERE
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                      color: AppColors.textColour50,
                                      fontSize: 16),
                              filled: true,
                              fillColor: AppColors.grey.shade100,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 16),
                            keyboardType: TextInputType.text,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "LinkedIn",
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      color: AppColors.textColour70,
                                      fontSize: 18,
                                    ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 6),
                          TextFormField(
                            controller: controller.linkedinC,
                            decoration: InputDecoration(
                              hintText: 'Enter your LinkedIn profile',
                              prefixIcon: Container(
                                margin: EdgeInsets.all(10),
                                child: FaIcon(
                                  FontAwesomeIcons.linkedin,
                                  size: 28,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide.none, //<-- SEE HERE
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none, //<-- SEE HERE
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color:
                                        AppColors.primaryLight), //<-- SEE HERE
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                      color: AppColors.textColour50,
                                      fontSize: 16),
                              filled: true,
                              fillColor: AppColors.grey.shade100,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 16),
                            keyboardType: TextInputType.text,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Twitter",
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      color: AppColors.textColour70,
                                      fontSize: 18,
                                    ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 6),
                          TextFormField(
                            controller: controller.twitterC,
                            decoration: InputDecoration(
                              hintText: 'Enter your Twitter profile',
                              prefixIcon: Container(
                                margin: EdgeInsets.all(10),
                                child: FaIcon(
                                  FontAwesomeIcons.twitter,
                                  size: 28,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide.none, //<-- SEE HERE
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none, //<-- SEE HERE
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color:
                                        AppColors.primaryLight), //<-- SEE HERE
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                      color: AppColors.textColour50,
                                      fontSize: 16),
                              filled: true,
                              fillColor: AppColors.grey.shade100,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 16),
                            keyboardType: TextInputType.text,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Web",
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      color: AppColors.textColour70,
                                      fontSize: 18,
                                    ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 6),
                          TextFormField(
                            controller: controller.webC,
                            decoration: InputDecoration(
                              hintText: 'Enter your personal website',
                              prefixIcon: Container(
                                margin: EdgeInsets.all(10),
                                child: FaIcon(
                                  FontAwesomeIcons.link,
                                  size: 28,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide.none, //<-- SEE HERE
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none, //<-- SEE HERE
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color:
                                        AppColors.primaryLight), //<-- SEE HERE
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                      color: AppColors.textColour50,
                                      fontSize: 16),
                              filled: true,
                              fillColor: AppColors.grey.shade100,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 16),
                            keyboardType: TextInputType.text,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Obx(() {
                        return PrimaryButton(
                          child: controller.isLoading.value == true
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: AppColors.white,
                                ))
                              : Text(
                                  'Update',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: Colors.white),
                                ),
                          onPressed: () {
                            controller.updateSosmed();
                          },
                        );
                      })
                    ],
                  ),
                ),
              );
            })));
  }
}
