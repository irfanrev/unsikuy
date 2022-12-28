import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
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

    return SMAppBar(
      showLeading: false,
      title: 'Post',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: ImageLoad(
                      shapeImage: ShapeImage.oval,
                      placeholder: AppImages.userPlaceholder.image().image,
                      image: controller.photoUrl == ''
                          ? 'https://firebasestorage.googleapis.com/v0/b/unsika-connect.appspot.com/o/user_placeholder.png?alt=media&token=d78dc4cb-0e08-4023-bc8d-6a361c4cd461'
                          : controller.photoUrl.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(controller.username.toString(),
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: AppColors.textColour70,
                          ))
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              TextFormField(
                controller: controller.desc,
                maxLines: 12,
                decoration: InputDecoration(
                  hintText: 'What do you think?',
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.0,
                      color: AppColors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: AppColors.primaryLight), //<-- SEE HERE
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.photo_on_rectangle,
                        size: 32,
                        color: AppColors.textColour50,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Get.defaultDialog(
                            title: 'Create a Post',
                            content: Column(
                              children: [
                                ListTile(
                                  leading: Icon(CupertinoIcons.photo_camera),
                                  title: Text(
                                    'Take a Photo',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  onTap: () {
                                    controller.chooseCamera();
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
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text('Add Images',
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: AppColors.textColour50)),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: controller.file?.isNotEmpty ?? false,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          CupertinoIcons.check_mark_circled,
                          size: 28,
                          color: AppColors.primaryLight,
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 46,
              ),
              PrimaryButton(
                child: controller.isDismiss == true
                    ? Center(child: CircularProgressIndicator())
                    : Text(
                        'Upload',
                        style: Theme.of(context).textTheme.button?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                onPressed: () {
                  controller.upload();
                  //controller.formKey.currentState?.reset();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
