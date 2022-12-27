import 'package:flutter/material.dart';
import 'package:unsikuy_app/app/resources/resource.dart';

///  default button on this project with primary color
///  change it as needed
class PrimaryButton extends StatelessWidget {
  /// first option to use widget inside the button
  final Widget? child;

  /// the option to change button color
  final Gradient? gradient;

  /// the width of the button.
  final double width;

  /// the height of the button.
  final double? height;

  /// action function when button is onClick
  final void Function()? onPressed;

  /// The radius of the button shape
  final double? borderRadius;

  /// wether the button is can be clicked or not
  final bool enabled;

  final double marginHorizontal;

  /// this is the second option if the requirement only need a String inside the button
  final String? title;

  /// for reversing only the color of the button including text if the code is using [title]
  final bool reverse;

  const PrimaryButton({
    Key? key,
    this.title,
    this.child,
    this.gradient,
    this.width = double.infinity,
    this.height = 48,
    this.onPressed,
    this.borderRadius,
    this.enabled = true,
    this.reverse = false,
    this.marginHorizontal = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
      decoration: BoxDecoration(
        gradient: gradient ??
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              colors: enabled
                  ? <Color>[
                      reverse ? AppColors.white : AppColors.primaryLight,
                      reverse ? AppColors.white : AppColors.primaryLight
                    ]
                  : <Color>[AppColors.gray, AppColors.gray],
            ),
        boxShadow: [
          enabled
              ? BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.5),
                  blurRadius: 1.5,
                )
              : BoxShadow(color: Colors.transparent),
        ],
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          onTap: enabled ? onPressed ?? () {} : null,
          child: Center(
              child: child ??
                  Text(
                    title.toString(),
                    style: Theme.of(context).textTheme.button?.copyWith(
                        color: reverse ? AppColors.primaryLight : null),
                  )),
        ),
      ),
    );
  }
}
