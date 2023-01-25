import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/costumize_textfield.dart';
import 'package:unsikuy_app/app/utils/widgets/form/form_input_field_with_icon.dart';
import 'package:unsikuy_app/app/utils/widgets/password_textfield.dart';
import 'package:unsikuy_app/app/utils/widgets/primary_button.dart';
import 'package:unsikuy_app/app/utils/widgets/sm_app_bar.dart';
import 'package:unsikuy_app/app/utils/widgets/state_handle_widget.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SMAppBar(
      showLeading: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100.w,
                height: 260,
                child: Lottie.asset(
                  'lib/app/resources/images/login.json',
                  fit: BoxFit.contain,
                ),
              ),

              Text(
                'Login',
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: AppColors.black,
                    ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                'Enter your credentials',
                style: Theme.of(context).textTheme.bodyText1!,
              ),
              const SizedBox(
                height: 24,
              ),
              CustomizeTextField(
                textEditingController: controller.emailC,
                titleText: 'Email',
                hintText: 'Enter your email address',
                textStyle: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(
                height: 20,
              ),
              PasswordTextfield(
                textEditingController: controller.passC,
                titleText: 'Password',
                isObscure: controller.isSecure,
                hintText: 'Enter your password',
                textStyle: Theme.of(context).textTheme.bodyText1,
                onPressed: () {
                  controller.isSecure = false;
                  controller.update();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              // Container(
              //   width: 100.w,
              //   child: InkWell(
              //     onTap: () {},
              //     child: Text(
              //       'Forgot Password?',
              //       style: Theme.of(context).textTheme.bodyText1!.copyWith(
              //             color: AppColors.primaryLight,
              //           ),
              //       textAlign: TextAlign.end,
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(() {
                        return PrimaryButton(
                          child: controller.isLoading.value == true
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: AppColors.white,
                                ))
                              : Text(
                                  'Done',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: Colors.white),
                                ),
                          borderRadius: 10,
                          onPressed: () {
                            if (controller.emailC.text.isNotEmpty &&
                                controller.passC.text.isNotEmpty) {
                              controller.login();
                            } else {
                              Get.snackbar(
                                'Error',
                                'Email or password must be filled',
                                backgroundColor: AppColors.error,
                                colorText: AppColors.white,
                              );
                            }
                          },
                        );
                      }),
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: 100.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Do not have an Account?',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: AppColors.black,
                                  ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.REGISTER);
                              },
                              child: Text(
                                ' Register',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: AppColors.primaryLight,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
