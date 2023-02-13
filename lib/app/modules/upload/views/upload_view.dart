import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/controllers/auth_controller.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/bottom_sheet_helper.dart';
import 'package:unsikuy_app/app/utils/widgets/form/form_image_picker.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:unsikuy_app/app/utils/widgets/image_source_sheet.dart';
import 'package:unsikuy_app/app/utils/widgets/primary_button.dart';
import 'package:unsikuy_app/app/utils/widgets/sm_app_bar.dart';

import '../controllers/upload_controller.dart';

class UploadView extends GetView<UploadController> {
  const UploadView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    chooseImage() {
      return SimpleDialog(
        title: Text('Create a Post'),
        children: [
          SimpleDialogOption(
            child: Text('Take a photo'),
            onPressed: () {},
          ),
          SimpleDialogOption(
            child: Text('Take a photo'),
            onPressed: () {},
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.close)),
        title: Text(
          'Sharing',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          placeholder: AppImages.userPlaceholder.image().image,
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
                      Obx(() => Text(controller.displayName.value.toString(),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              width: 0.8, color: AppColors.grey.shade300),
                        ),
                        child: Text('Posts are set public by default',
                            style:
                                Theme.of(context).textTheme.bodyText2?.copyWith(
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
                textCapitalization: TextCapitalization.sentences,
                maxLines: 14,
                decoration: InputDecoration(
                  fillColor: AppColors.white,
                  hintText: "What do you think?",
                  focusedErrorBorder: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 18, color: AppColors.textColour50, height: 1.3),
                ),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 18, height: 1.4),
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(
                height: 18,
              ),
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
                              width: 1.0, color: AppColors.grey.shade300),
                        ),
                        child: controller.file != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
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
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    backgroundColor: AppColors.shadesPrimaryDark10,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          CupertinoIcons.photo_camera,
                          size: 24,
                          color: AppColors.primaryDark,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            controller.chooseCamera();
                          },
                          child: Text('Add Images from Camera',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: AppColors.primaryDark)),
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    backgroundColor: AppColors.shadesPrimaryDark10,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          CupertinoIcons.photo_on_rectangle,
                          size: 24,
                          color: AppColors.primaryDark,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            controller.chooseGallery();
                          },
                          child: Text('Add Images from Gallery',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: AppColors.primaryDark)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 16,
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
                          'Upload',
                          style: Theme.of(context).textTheme.button?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                  onPressed: () {
                    if (controller.desc.text.isNotEmpty ||
                        controller.file != null) {
                      controller.upload();
                    }
                    //controller.formKey.currentState?.reset();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
