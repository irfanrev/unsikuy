import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/people/controllers/people_controller.dart';
import 'package:unsikuy_app/app/modules/profile/views/profile_view.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:get/get.dart';

class UserCardChat extends StatelessWidget {
  const UserCardChat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.CHAT_ROOM);
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
                    'irfan',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: AppColors.textColour80,
                        ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Student',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.shadesPrimaryDark60,
                        ),
                  ),
                ],
              ),
            ),

            Text(
              '19.00',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: AppColors.textColour70,
                  ),
            ),
            const SizedBox(
              width: 16,
            ),
            // Visibility(
            //   visible: snap['uuid'] != FirebaseAuth.instance.currentUser!.uid,
            //   child: snap['connecters']
            //           .contains(FirebaseAuth.instance.currentUser!.uid)
            //       ? InkWell(
            //           onTap: () {},
            //           child: Container(
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(10),
            //                 border: Border.all(
            //                     width: 0.8, color: AppColors.grey.shade300),
            //                 color: AppColors.grey.shade100),
            //             padding:
            //                 EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            //             child: Center(
            //               child: Text(
            //                 'Disconnect',
            //                 style:
            //                     Theme.of(context).textTheme.headline6!.copyWith(
            //                           color: AppColors.textColour50,
            //                         ),
            //               ),
            //             ),
            //           ),
            //         )
            //       : InkWell(
            //           onTap: () {},
            //           child: Container(
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(10),
            //                 color: AppColors.primaryLight),
            //             padding:
            //                 EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            //             child: Center(
            //               child: Text(
            //                 'Connect',
            //                 style:
            //                     Theme.of(context).textTheme.headline6!.copyWith(
            //                           color: AppColors.white,
            //                         ),
            //               ),
            //             ),
            //           ),
            //         ),
            // ),
          ],
        ),
      ),
    );
  }
}
