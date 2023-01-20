import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:unsikuy_app/app/resources/resource.dart';

class FormInputFieldWithIcon extends StatelessWidget {
  FormInputFieldWithIcon({
    required this.controller,
    this.iconPrefix,
    this.labelText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.minLines = 1,
    this.maxLines,
    this.onChanged,
    this.onSaved,
    this.onCompleted,
    this.onClear,
  });

  final TextEditingController controller;
  final IconData? iconPrefix;
  final String? labelText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool? obscureText;
  final bool? enabled;
  final int? minLines;
  final int? maxLines;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String?)? onCompleted;
  final void Function()? onClear;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(
          CupertinoIcons.search,
          color: AppColors.grey.shade400,
        ),
        suffixIcon: InkWell(
          onTap: onClear,
          child: Icon(
            Icons.close,
            color: AppColors.grey.shade400,
            size: 18,
          ),
        ),
        filled: true,
        //prefixIcon: Icon(iconPrefix),
        hintText: labelText,
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
          borderSide: const BorderSide(
              width: 1, color: AppColors.primaryLight), //<-- SEE HERE
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: Theme.of(context).textTheme.bodyText1,
      enabled: enabled,
      controller: controller,
      onSaved: onSaved,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText!,
      maxLines: maxLines,
      minLines: minLines,
      validator: validator,
      onFieldSubmitted: onCompleted,
    );
  }
}
