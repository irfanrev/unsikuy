import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadDialog extends StatelessWidget {
  const UploadDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
}
