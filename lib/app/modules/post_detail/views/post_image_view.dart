import 'package:flutter/material.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:get/get.dart';

class PostImageView extends StatelessWidget {
  final image;
  const PostImageView({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox.expand(
        child: InteractiveViewer(
          maxScale: 4.0,
          child: Hero(
            tag: 'post',
            child: Image.network(
              image,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}
