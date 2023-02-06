import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/register/views/regsiter_success.dart';
import 'package:unsikuy_app/app/modules/register/widgets/form_register.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/primary_button.dart';
import 'package:unsikuy_app/app/utils/widgets/sm_app_bar.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SMAppBar(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FormBuilder(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: (kIsWeb) ? 400 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 24,
                ),
                Text(
                  'Register',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'Please fill the following',
                  style: Theme.of(context).textTheme.bodyText1!,
                ),
                const SizedBox(
                  height: 24,
                ),
                FormRegister(
                  title: 'Full Name',
                  name: 'username',
                  hint: 'Enter your name',
                ),
                const SizedBox(
                  height: 16,
                ),
                FormRegister(
                  title: 'Email Address',
                  name: 'email',
                  textInputType: TextInputType.emailAddress,
                  hint: 'Enter your student or staff email',
                ),
                const SizedBox(
                  height: 16,
                ),
                FormRegister(
                  title: 'Phone (62)',
                  name: 'phone',
                  textInputType: TextInputType.phone,
                  hint: 'Ex : 62812345',
                ),
                const SizedBox(
                  height: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gender',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 6),
                    FormBuilderDropdown<String>(
                      name: 'gender',
                      initialValue: 'Male',
                      validator: FormBuilderValidators.required(),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none, //<-- SEE HERE
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: AppColors.primaryLight), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // suffix: GestureDetector(
                        //   onTap: () {
                        //     controller.formKey.currentState!.fields['gender']
                        //         ?.reset();
                        //   },
                        //   child: Icon(Icons.close),
                        // ),
                        hintText: 'Select gender',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: AppColors.textColour50),
                        filled: true,
                        fillColor: AppColors.grey.shade100,
                      ),
                      items: controller.genderOptions
                          .map((gender) => DropdownMenuItem(
                                alignment: AlignmentDirectional.centerStart,
                                value: gender,
                                child: Text(
                                  gender,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: AppColors.textColour50,
                                      ),
                                ),
                              ))
                          .toList(),
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
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 6),
                    FormBuilderDropdown<String>(
                      name: 'status',
                      initialValue: 'Student',
                      validator: FormBuilderValidators.required(),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none, //<-- SEE HERE
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: AppColors.primaryLight), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // suffix: GestureDetector(
                        //   onTap: () {
                        //     controller.formKey.currentState!.fields['gender']
                        //         ?.reset();
                        //   },
                        //   child: Icon(Icons.close),
                        // ),
                        hintText: 'Select current status',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: AppColors.textColour50),
                        filled: true,
                        fillColor: AppColors.grey.shade100,
                      ),
                      items: controller.statusOptions
                          .map((status) => DropdownMenuItem(
                                alignment: AlignmentDirectional.centerStart,
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
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                FormRegister(
                  title: 'Password',
                  name: 'password',
                  hint: 'Enter password',
                  sufix: controller.isObscure = true,
                  textInputType: TextInputType.visiblePassword,
                ),
                const SizedBox(
                  height: 24,
                ),
                FormRegister(
                  title: 'Password Confirmation',
                  name: 'password_confirm',
                  hint: 'Re-enter password',
                  sufix: controller.isObscure = true,
                  textInputType: TextInputType.visiblePassword,
                ),
                FormBuilderCheckbox(
                  name: 'tnc',
                  title: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.TERMS_CONDITION);
                    },
                    child: Text(
                      'I aggree with the Terms and Conditions.',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: AppColors.primaryLight,
                            fontSize: 15,
                          ),
                    ),
                  ),
                  initialValue: controller.isAggree,
                  onChanged: (value) {
                    controller.isAggree = !controller.isAggree;
                    controller.update();
                  },
                  decoration: const InputDecoration(
                    filled: false,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none, //<-- SEE HERE
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none //<-- SEE HERE
                        ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(() => PrimaryButton(
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
                      onPressed: () {
                        if (controller.formKey.currentState!
                                .saveAndValidate() &&
                            controller.isAggree == true &&
                            controller
                                    .formKey.currentState?.value['password'] ==
                                controller.formKey.currentState
                                    ?.value['password_confirm']) {
                          controller.register();
                        }
                      },
                    )),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  width: 100.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: AppColors.black,
                            ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.offNamed(Routes.LOGIN);
                        },
                        child: Text(
                          ' Login',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: AppColors.primaryLight,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
