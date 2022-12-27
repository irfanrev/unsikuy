import 'package:flutter/material.dart';
import 'package:unsikuy_app/app/resources/resource.dart';

class CustomizeTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextStyle? textStyle;
  final String? hintText;
  final String? titleText;
  final Widget? icon;
  const CustomizeTextField(
      {Key? key,
      required this.textEditingController,
      this.textStyle,
      this.hintText,
      this.titleText,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText ?? '',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(
          height: 8,
        ),
        TextField(
          controller: textEditingController,
          style: textStyle ??
              TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textColour80,
              ),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none, //<-- SEE HERE
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1, color: AppColors.primaryLight), //<-- SEE HERE
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: AppColors.grey.shade100,
            hintText: hintText ?? '',
            // icon: icon ?? Container()
          ),
        ),
      ],
    );
  }
}
