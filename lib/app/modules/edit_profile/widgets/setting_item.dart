import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/resources/resource.dart';

class SettingItem extends StatelessWidget {
  String? title;
  IconData? icon;
  final GestureTapCallback? onTap;
  SettingItem({super.key, this.title, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100.w,
        margin: EdgeInsets.only(bottom: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon!,
                  color: AppColors.grey.shade500,
                ),
                const SizedBox(
                  width: 24,
                ),
                Text(
                  title!,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 20,
                        color: AppColors.textColour80,
                      ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: AppColors.textColour80,
            ),
          ],
        ),
      ),
    );
  }
}
