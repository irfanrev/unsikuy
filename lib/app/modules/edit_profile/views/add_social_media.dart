import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.close)),
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
                            "WhatsApp Status",
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      color: AppColors.textColour70,
                                      fontSize: 18,
                                    ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 6),
                          InkWell(
                            onTap: () {
                              showBarModalBottomSheet(
                                  //constraints: BoxConstraints(maxHeight: 300),
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      width: 100.w,
                                      height: 260,
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Change your WhastApp information to public or private!',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4!
                                                .copyWith(
                                                  color: AppColors.black,
                                                  fontSize: 18,
                                                ),
                                          ),
                                          const SizedBox(
                                            height: 18,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              controller.updateWaPrivate();
                                            },
                                            child: Container(
                                              width: 100.w,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                                color: AppColors.primaryLight,
                                              ),
                                              child: Center(
                                                  child: Text(
                                                'Private',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5!
                                                    .copyWith(
                                                      color: AppColors.white,
                                                    ),
                                              )),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              controller.updateWaPublic();
                                            },
                                            child: Container(
                                              width: 100.w,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                                color: AppColors.primaryOrange,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Public',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5!
                                                      .copyWith(
                                                        color: AppColors.white,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: AppColors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.whatsapp,
                                    size: 32,
                                    color: AppColors.grey.shade600,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Obx(
                                    () => Text(
                                      controller.box.hasData('whatsapp')
                                          ? controller.waStatusPublic.value
                                          : controller.waStatus.value,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
