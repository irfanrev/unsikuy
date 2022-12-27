import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EmptyPage extends StatelessWidget {
  final AssetImage image;
  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  const EmptyPage(
      {required this.image,
      required this.message,
      required this.buttonText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 120.sp, height: 120.sp, child: Image(image: image)),
          SizedBox(
            height: 20.sp,
          ),
          Text(
            message,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 15.sp,
          ),
          ElevatedButton(onPressed: onPressed, child: Text(buttonText))
        ],
      ),
    );
  }
}
