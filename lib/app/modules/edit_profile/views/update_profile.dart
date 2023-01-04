import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/edit_profile/controllers/edit_profile_controller.dart';
import 'package:unsikuy_app/app/modules/edit_profile/widgets/form_edit_profile.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:get/get.dart';
import 'package:unsikuy_app/app/utils/widgets/primary_button.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Profile',
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
                        height: 24,
                      ),
                      InkWell(
                        onTap: () {
                          Get.defaultDialog(
                            title: 'Edit Profile Picture',
                            content: Column(
                              children: [
                                ListTile(
                                  leading:
                                      const Icon(CupertinoIcons.photo_camera),
                                  title: Text(
                                    'Take a Photo',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  onTap: () {
                                    controller.chooseCamera();
                                    Get.back();
                                  },
                                ),
                                ListTile(
                                  leading:
                                      Icon(CupertinoIcons.photo_on_rectangle),
                                  title: Text(
                                    'Choose from gallery',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  onTap: () {
                                    controller.chooseGallery();
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 130,
                          height: 130,
                          child: Stack(
                            children: [
                              SizedBox(
                                width: 130,
                                height: 130,
                                child: ImageLoad(
                                  shapeImage: ShapeImage.oval,
                                  placeholder:
                                      AppImages.userPlaceholder.image().image,
                                  fit: BoxFit.cover,
                                  image: controller.photoUrl,
                                ),
                              ),
                              Visibility(
                                visible: controller.file != null,
                                child: controller.file != null
                                    ? Container(
                                        width: 130,
                                        height: 130,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image:
                                                  MemoryImage(controller.file!),
                                              fit: BoxFit.cover),
                                        ),
                                      )
                                    : SizedBox(),
                              ),
                              Positioned(
                                right: 5,
                                bottom: 6,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    boxShadow: [AppElevation.elevation4px],
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      CupertinoIcons.camera,
                                      size: 18,
                                      color: AppColors.primaryLight,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(
                        height: 24,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Full Name",
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      color: AppColors.textColour70,
                                    ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 6),
                          TextFormField(
                            controller: controller.usernameC,
                            decoration: InputDecoration(
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
                            style: Theme.of(context).textTheme.bodyLarge,
                            keyboardType: TextInputType.text,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phone",
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      color: AppColors.textColour70,
                                    ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 6),
                          TextFormField(
                            controller: controller.phoneC,
                            decoration: InputDecoration(
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
                            style: Theme.of(context).textTheme.bodyLarge,
                            keyboardType: TextInputType.text,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Status',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          SizedBox(height: 6),
                          DropdownButtonFormField(
                            validator: FormBuilderValidators.required(),
                            decoration: InputDecoration(
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
                              hintText: 'Select current status',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(color: AppColors.textColour50),
                              filled: true,
                              fillColor: AppColors.grey.shade100,
                            ),
                            value: controller.status.toString(),
                            items: controller.statusOptions
                                .map((status) => DropdownMenuItem(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      value: status,
                                      child: Text(
                                        status,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              color: AppColors.textColour50,
                                            ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (String? value) {
                              controller.status = value.toString();
                            },
                          ),
                        ],
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
                            controller.updateProfile();
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
