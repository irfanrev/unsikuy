import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/form/form_image_picker.dart';
import 'bottom_sheet_helper.dart';
import 'image_load.dart';
import 'image_source_sheet.dart';

class ImagePickerAvatar extends StatelessWidget {
  const ImagePickerAvatar({
    Key? key,
    required this.state,
    required this.maxHeight,
    required this.maxWidth,
    required this.imageQuality,
    required this.preferredCameraDevice,
    required this.bottomSheetPadding,
    required this.cameraIcon,
    required this.cameraLabel,
    required this.galleryIcon,
    required this.galleryLabel,
    required this.field,
    required this.onChanged,
    required this.initialValue,
  }) : super(key: key);

  final FormImagePickerState state;
  final double? maxHeight;
  final double? maxWidth;
  final int? imageQuality;
  final CameraDevice preferredCameraDevice;
  final EdgeInsets? bottomSheetPadding;
  final Widget? cameraIcon;
  final Widget? cameraLabel;
  final Widget? galleryIcon;
  final Widget? galleryLabel;
  final FormImagePickerState field;
  final ValueChanged<List?>? onChanged;
  final List<dynamic>? initialValue;

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    ImageProvider? image;
    var item;

    if (field.value != null && field.value!.isNotEmpty) {
      item = field.value?[0];
      if (item != null) {
        assert(
            item is File); //add if needed|| item is String || item is Uint8List
        image = FileImage(item as File);
      }
    }
    var photo = initialValue?[0] ?? '';
    return Container(
      width: 80.0,
      height: 80.0,
      child: Container(
        child: Stack(
          children: [
            GestureDetector(
              child: image != null
                  ? Container(
                      width: 80.0,
                      height: 80.0,
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage:
                              AppImages.userPlaceholder.image().image,
                          child: ClipOval(
                            child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: image, fit: BoxFit.cover))),
                          )),
                    )
                  : ImageLoad(
                      width: 80.0,
                      height: 80.0,
                      shapeImage: ShapeImage.oval,
                      image: photo.toString(),
                      fit: BoxFit.fitWidth,
                      placeholder: AppImages.userPlaceholder.image().image,
                    ),
              onTap: () {
                showBarBottomSheet<void>(
                  state.context,
                  builder: (_) {
                    return ImageSourceBottomSheet(
                      maxHeight: maxHeight,
                      maxWidth: maxWidth,
                      imageQuality: imageQuality,
                      preferredCameraDevice: preferredCameraDevice,
                      bottomSheetPadding: bottomSheetPadding,
                      cameraIcon: cameraIcon,
                      cameraLabel: cameraLabel,
                      galleryIcon: galleryIcon,
                      galleryLabel: galleryLabel,
                      onImageSelected: (image) {
                        state.requestFocus();
                        field.didChange(
                            <dynamic>[...?field.value]..remove(item));
                        field.didChange(<dynamic>[...?field.value, image]);
                        Navigator.pop(state.context);
                      },
                      onImage: (image) {
                        field.didChange(
                            <dynamic>[...?field.value]..remove(item));
                        field.didChange(<dynamic>[...?field.value, image]);
                        onChanged?.call(field.value);
                        Navigator.pop(state.context);
                      },
                    );
                  },
                );
              },
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  showBarBottomSheet<void>(
                    state.context,
                    builder: (_) {
                      return ImageSourceBottomSheet(
                        maxHeight: 1700,
                        maxWidth: 1700,
                        imageQuality: imageQuality,
                        preferredCameraDevice: preferredCameraDevice,
                        bottomSheetPadding: bottomSheetPadding,
                        cameraIcon: cameraIcon,
                        cameraLabel: cameraLabel,
                        galleryIcon: galleryIcon,
                        galleryLabel: galleryLabel,
                        onImageSelected: (image) {
                          state.requestFocus();
                          field.didChange(
                              <dynamic>[...?field.value]..remove(item));
                          field.didChange(<dynamic>[...?field.value, image]);
                          Navigator.pop(state.context);
                        },
                        onImage: (image) {
                          field.didChange(
                              <dynamic>[...?field.value]..remove(item));
                          field.didChange(<dynamic>[...?field.value, image]);
                          onChanged?.call(field.value);
                          Navigator.pop(state.context);
                        },
                      );
                    },
                  );
                },
                child: Container(
                  width: 25.9,
                  height: 22.9,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 1,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.mode_edit,
                    size: 15.9,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            image != null
                ? GestureDetector(
                    onTap: () {
                      field.didChange(<dynamic>[...?field.value]..remove(item));
                      // field.didChange(<dynamic>[...?field.value, image]);
                      image = null;
                      onChanged?.call(field.value);
                    },
                    child: Container(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 25.9,
                        height: 22.9,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 1,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 15.9,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
