import 'package:flutter/material.dart';
import 'package:unsikuy_app/app/resources/resource.dart';

class PasswordTextfield extends StatefulWidget {
  final TextEditingController textEditingController;
  final TextStyle? textStyle;
  final String? hintText;
  final String? titleText;
  final Widget? icon;
  bool? isObscure;
  final void Function()? onPressed;
  PasswordTextfield(
      {Key? key,
      required this.textEditingController,
      this.textStyle,
      this.hintText,
      this.titleText,
      this.isObscure,
      this.icon,
      this.onPressed})
      : super(key: key);

  @override
  State<PasswordTextfield> createState() => _PasswordTextfieldState();
}

class _PasswordTextfieldState extends State<PasswordTextfield> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.titleText ?? '',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(
          height: 8,
        ),
        TextField(
          obscureText: widget.isObscure!,
          controller: widget.textEditingController,
          style: widget.textStyle ??
              const TextStyle(
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
              hintText: widget.hintText ?? '',
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.isObscure = !widget.isObscure!;
                  });
                },
                child: Icon(
                  widget.isObscure == true
                      ? Icons.lock_outline_rounded
                      : Icons.lock_open_outlined,
                  color: AppColors.grey.shade500,
                  size: 24,
                ),
              )
              // icon: icon ?? Container()
              ),
        ),
      ],
    );
  }
}
