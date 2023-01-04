import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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
    return InkWell(
      onTap: () {
        Get.to(ProfileView(
          uuid: snap['uuid'],
        ));
      },
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(vertical: 16),
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.grey.shade200),
          ),
          //borderRadius: BorderRadius.circular(12),
          //border: Border.all(color: AppColors.grey.shade300, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              child: ImageLoad(
                fit: BoxFit.cover,
                shapeImage: ShapeImage.oval,
                placeholder: AppImages.userPlaceholder.image().image,
                image: snap['photoUrl'],
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
                    snap['username'],
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: AppColors.textColour80,
                        ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Visibility(
                    visible: snap['bio'] != '',
                    child: Text(
                      snap['bio'],
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.textColour50,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  Text(
                    snap['status'],
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.shadesPrimaryDark60,
                        ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: snap['uuid'] != FirebaseAuth.instance.currentUser!.uid,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryLight),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Center(
                  child: Text(
                    'Connect',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: AppColors.white,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // child: ListTile(
        //   isThreeLine: true,
        //   leading: Container(
        //     width: 45,
        //     height: 45,
        //     child: ImageLoad(
        //       fit: BoxFit.cover,
        //       shapeImage: ShapeImage.oval,
        //       placeholder: AppImages.userPlaceholder.image().image,
        //       image: snap['photoUrl'] == ''
        //           ? 'https://firebasestorage.googleapis.com/v0/b/unsika-connect.appspot.com/o/user_placeholder.png?alt=media&token=d78dc4cb-0e08-4023-bc8d-6a361c4cd461'
        //           : snap['photoUrl'],
        //     ),
        //   ),
        //   title: Text(
        //     snap['username'],
        //     style: Theme.of(context).textTheme.headline5!.copyWith(
        //           color: AppColors.textColour70,
        //         ),
        //   ),
        //   subtitle: Text(
        //     snap['status'],
        //     style: Theme.of(context).textTheme.bodyText1!.copyWith(
        //           color: AppColors.textColour70,
        //         ),
        //   ),
        // ),
      ),
    );
  }
}
