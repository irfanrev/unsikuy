import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/edit_profile/views/update_bio.dart';
import 'package:unsikuy_app/app/modules/edit_profile/views/update_profile.dart';
import 'package:unsikuy_app/app/modules/edit_profile/widgets/setting_item.dart';
import 'package:unsikuy_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/theme/app_theme.dart';
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
                          child: ImageLoad(
                            shapeImage: ShapeImage.oval,
                            placeholder:
                                AppImages.userPlaceholder.image().image,
                            image: photoUrl ?? '',
                            fit: BoxFit.cover,
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
                        title: 'Edit Profile',
                        icon: CupertinoIcons.pencil_ellipsis_rectangle,
                        onTap: () => Get.toNamed(Routes.UPDATE_PROFILE),
                      ),
                      SettingItem(
                        title: 'Change Theme',
                        icon: CupertinoIcons.color_filter,
                        onTap: () {
                          Get.defaultDialog(
                              title: 'Switch theme to',
                              titlePadding:
                                  EdgeInsets.only(top: 20, bottom: 10),
                              titleStyle: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(),
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Get.changeTheme(
                                          AppTheme.buildThemeData(false));
                                      Get.back();
                                    },
                                    child: Text(
                                      'Light',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3!
                                          .copyWith(),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.changeTheme(
                                          AppTheme.buildThemeData(true));
                                      Get.back();
                                    },
                                    child: Text(
                                      'Dark',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3!
                                          .copyWith(),
                                    ),
                                  ),
                                ],
                              ));
                        },
                      ),
                      const SizedBox(height: 32),
                      PrimaryButton(
                        title: 'Logout',
                        onPressed: () {
                          controller.logout();
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
