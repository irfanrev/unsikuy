import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/people/controllers/people_controller.dart';
import 'package:unsikuy_app/app/modules/profile/views/profile_view.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:get/get.dart';

class UserCard extends StatelessWidget {
  final snap;
  const UserCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PeopleController>();
    return InkWell(
      onTap: () {
        Get.to(ProfileView(
          uuid: snap['uuid'] ?? '',
        ));
      },
      child: Container(
        width: 100.w,
        margin: EdgeInsets.only(bottom: 22),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              child: ImageLoad(
                fit: BoxFit.cover,
                shapeImage: ShapeImage.oval,
                placeholder: AppImages.userPlaceholder.image().image,
                image: snap['photoUrl'] ?? '',
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snap['username'] ?? '',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: AppColors.textColour80,
                        ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Visibility(
                    visible: snap['bio'] != '',
                    child: Text(
                      snap['bio'],
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.textColour50,
                          overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    snap['status'] ?? '',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.shadesPrimaryDark60,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
