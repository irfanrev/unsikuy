import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../image_picker_avatar.dart';

class FormImagePicker extends FormBuilderField<List<dynamic>> {
  final double previewWidth;
  final EdgeInsets? previewMargin;
  final ImageProvider? placeholderImage;

  final Color? iconColor;
  final double? maxHeight;
  final double? maxWidth;

  final int? imageQuality;
  final CameraDevice preferredCameraDevice;

  final void Function(Image)? onImage;
  final int? maxImages;
  final Widget cameraIcon;
  final Widget galleryIcon;
  final Widget cameraLabel;
  final Widget galleryLabel;
  final EdgeInsets bottomSheetPadding;

  FormImagePicker({
    Key? key,
    required String name,
    FormFieldValidator<List<dynamic>>? validator,
    List<dynamic>? initialValue,
    InputDecoration decoration = const InputDecoration(),
    ValueChanged<List<dynamic>?>? onChanged,
    ValueTransformer<List<dynamic>>? valueTransformer,
    bool enabled = true,
    FormFieldSetter<List<dynamic>>? onSaved,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    VoidCallback? onReset,
    FocusNode? focusNode,
    this.previewWidth = 130,
    double previewHeight = 40,
    this.previewMargin,
    this.iconColor,
    this.maxHeight,
    this.maxWidth,
    this.imageQuality,
    this.preferredCameraDevice = CameraDevice.rear,
    this.onImage,
    this.maxImages,
    this.cameraIcon = const Icon(Icons.camera_alt_rounded),
    this.galleryIcon = const Icon(Icons.image),
    this.cameraLabel = const Text('Camera'),
    this.galleryLabel = const Text('Gallery'),
    this.bottomSheetPadding = EdgeInsets.zero,
    this.placeholderImage,
  })  : assert(maxImages == null || maxImages >= 0),
        super(
            key: key,
            name: name,
            validator: validator,
            // ignore: unnecessary_question_mark
            valueTransformer: (List<dynamic?>? value) {
              if (value != null && value.isNotEmpty) {
                return value[0];
              }
            },
            onChanged: onChanged,
            autovalidateMode: autovalidateMode,
            onSaved: onSaved,
            enabled: enabled,
            onReset: onReset,
            decoration: decoration,
            focusNode: focusNode,
            builder: (FormFieldState<List<dynamic>?> field) {
              final state = field as FormImagePickerState;
              return ImagePickerAvatar(
                  initialValue: initialValue,
                  state: state,
                  maxHeight: maxHeight,
                  maxWidth: maxWidth,
                  imageQuality: imageQuality,
                  preferredCameraDevice: preferredCameraDevice,
                  bottomSheetPadding: bottomSheetPadding,
                  cameraIcon: cameraIcon,
                  cameraLabel: Text('txt_button_camera'.tr),
                  galleryIcon: galleryIcon,
                  galleryLabel: Text('txt_button_gallery'.tr),
                  field: field,
                  onChanged: onChanged);
            });

  @override
  FormImagePickerState createState() => FormImagePickerState();
}

class FormImagePickerState
    extends FormBuilderFieldState<FormImagePicker, List<dynamic>> {
  bool get hasMaxImages =>
      widget.maxImages != null &&
      value != null &&
      value!.length >= widget.maxImages!;
}
