import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:get/get.dart';

import '../../../resources/resource.dart';

class ViewAvatar extends StatelessWidget {
  final photo;

  const ViewAvatar({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.close,
            color: AppColors.white,
          ),
        ),
        title: Text(
          'Photo Profile',
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: AppColors.white),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          width: 350,
          height: 350,
          child: ImageLoad(
            shapeImage: ShapeImage.oval,
            placeholder: AppImages.userPlaceholder.image().image,
            image: photo,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
