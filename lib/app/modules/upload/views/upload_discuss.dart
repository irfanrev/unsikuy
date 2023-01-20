import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:unsikuy_app/app/modules/upload/controllers/upload_controller.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:unsikuy_app/app/utils/widgets/primary_button.dart';
import 'package:unsikuy_app/app/utils/widgets/sm_app_bar.dart';

class UploadDiscuss extends StatelessWidget {
  const UploadDiscuss({super.key});

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
          'Open Discussion',
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: AppColors.textColour80),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
            child: GetBuilder<UploadController>(
                init: UploadController(),
                builder: (controller) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Obx(() => ImageLoad(
                                  shapeImage: ShapeImage.oval,
                                  placeholder:
                                      AppImages.userPlaceholder.image().image,
                                  image: controller.displayPhoto.toString(),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(
                                  controller.displayName.value.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        color: AppColors.textColour70,
                                      ))),
                              const SizedBox(
                                height: 4,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      width: 0.8,
                                      color: AppColors.grey.shade300),
                                ),
                                child: Text('Public',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        ?.copyWith(
                                          color: AppColors.textColour70,
                                        )),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      TextFormField(
                        controller: controller.desc,
                        maxLines: 12,
                        decoration: InputDecoration(
                          fillColor: AppColors.white,
                          hintText:
                              "Write down the title of your question or discussion, for example starting with 'What', 'How', 'Why', etc.",
                          focusedErrorBorder: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: 18,
                                  color: AppColors.textColour50,
                                  height: 1.3),
                        ),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 20,
                            ),
                        keyboardType: TextInputType.multiline,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GetBuilder<UploadController>(
                              init: UploadController(),
                              builder: (value) {
                                return Visibility(
                                  visible: controller.file != null,
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    margin: const EdgeInsets.only(right: 22),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          width: 1.0,
                                          color: AppColors.grey.shade300),
                                    ),
                                    child: controller.file != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.memory(
                                              controller.file!,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Container(),
                                  ),
                                );
                              }),
                          const SizedBox(
                            width: 16,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 46,
                      ),
                      Obx(() {
                        return PrimaryButton(
                          child: controller.isDismiss.value == true
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: AppColors.white,
                                ))
                              : Text(
                                  'Open Discussion',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: Colors.white),
                                ),
                          onPressed: () {
                            controller.openDiscuss();

                            //controller.formKey.currentState?.reset();
                          },
                        );
                      }),
                    ],
                  );
                })),
      ),
    );
  }
}
