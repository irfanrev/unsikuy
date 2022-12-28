import 'package:flutter/material.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/primary_button.dart';
import 'package:unsikuy_app/app/utils/widgets/sm_app_bar.dart';
import 'package:get/get.dart';

class RegisterSuccess extends StatelessWidget {
  const RegisterSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SMAppBar(
        showLeading: false,
        body: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImages.regisSuccess.image(
                  width: 200,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  'Welcome',
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: AppColors.black,
                      ),
                ),
                const SizedBox(
                  height: 32,
                ),
                PrimaryButton(
                  title: 'Continue to login',
                  onPressed: () {
                    Get.offAllNamed(Routes.LOGIN);
                  },
                )
              ],
            ),
          ),
        ));
  }
}
