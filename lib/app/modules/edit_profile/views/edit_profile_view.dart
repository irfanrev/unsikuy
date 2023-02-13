import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/edit_profile/views/update_bio.dart';
import 'package:unsikuy_app/app/modules/edit_profile/views/update_profile.dart';
import 'package:unsikuy_app/app/modules/edit_profile/widgets/setting_item.dart';
import 'package:unsikuy_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:unsikuy_app/app/modules/profile/views/profile_view.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/theme/app_theme.dart';
import 'package:unsikuy_app/app/utils/widgets/bottom_sheet_helper.dart';
import 'package:unsikuy_app/app/utils/widgets/form/form_image_picker.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_overlay.dart';
import 'package:unsikuy_app/app/utils/widgets/primary_button.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends StatelessWidget {
  String? photoUrl;
  String? username;
  String? email;
  EditProfileView({Key? key, this.photoUrl, this.username, this.email})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());
    final profC = Get.put(ProfileController);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.offAllNamed(Routes.HOME);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
            )),
        title: const Text('EditProfileView'),
        centerTitle: true,
      ),
      body: GetBuilder<EditProfileController>(
          init: EditProfileController(),
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 100.w,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AvatarGlow(
                        glowColor: AppColors.primaryLight,
                        endRadius: 90.0,
                        duration: Duration(milliseconds: 2000),
                        repeat: true,
                        showTwoGlows: true,
                        repeatPauseDuration: Duration(milliseconds: 100),
                        child: Container(
                          width: 140,
                          height: 140,
                          child: Hero(
                            tag: 'pp',
                            child: ImageLoad(
                              shapeImage: ShapeImage.oval,
                              placeholder:
                                  AppImages.userPlaceholder.image().image,
                              image: photoUrl ?? '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        username ?? '',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: AppColors.textColour80, fontSize: 24),
                      ),
                      Text(
                        email ?? '',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18, color: AppColors.textColour60),
                      ),
                      const SizedBox(height: 38),
                      SettingItem(
                        title: 'Add or Update Bio',
                        icon: CupertinoIcons.lightbulb,
                        onTap: () => Get.toNamed(Routes.UPDATE_BIO),
                      ),
                      SettingItem(
                        title: 'Edit About',
                        icon: CupertinoIcons.person,
                        onTap: () => Get.toNamed(Routes.ABOUT),
                      ),
                      SettingItem(
                        title: 'Edit Profile',
                        icon: CupertinoIcons.pencil_ellipsis_rectangle,
                        onTap: () => Get.toNamed(Routes.UPDATE_PROFILE),
                      ),
                      SettingItem(
                        title: 'Add Social Media',
                        icon: CupertinoIcons.link,
                        onTap: () => Get.toNamed(Routes.SOSMED),
                      ),
                      SettingItem(
                        title: 'Change Theme',
                        icon: CupertinoIcons.color_filter,
                        onTap: () {
                          showBarModalBottomSheet(
                              //constraints: BoxConstraints(maxHeight: 300),
                              context: context,
                              builder: (context) {
                                return Container(
                                  width: 100.w,
                                  height: 200,
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Stay tuned for the dark mode feature in the next version',
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
                                          Get.back();
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
                                            'Oke',
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
                                    ],
                                  ),
                                );
                              });
                        },
                      ),
                      const SizedBox(height: 32),
                      PrimaryButton(
                        title: 'Logout',
                        onPressed: () {
                          showBarModalBottomSheet(
                              //constraints: BoxConstraints(maxHeight: 300),
                              context: context,
                              builder: (context) {
                                return Container(
                                  width: 100.w,
                                  height: 300,
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Are you sure you want to log out of the app?',
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
                                          controller.logout();
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
                                            'Oke',
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
                                          Get.back();
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
                                            'Cancel',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5!
                                                .copyWith(
                                                  color: AppColors.white,
                                                ),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      bottomNavigationBar: Container(
        width: 100.w,
        height: 100,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Unsika Connect App',
              style: Theme.of(context).textTheme.headline3!,
            ),
            const SizedBox(height: 6),
            Text(
              'v1.0.0',
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
          ],
        ),
      ),
    );
  }
}
