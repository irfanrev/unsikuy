import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/model/user.dart';
import 'package:unsikuy_app/app/modules/people/controllers/people_controller.dart';
import 'package:unsikuy_app/app/modules/profile/views/profile_view.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:get/get.dart';

class UserCard extends StatelessWidget {
  final User snap;
  const UserCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PeopleController>();
    return InkWell(
      onTap: () {
        Get.to(ProfileView(
          uuid: snap.uuid ?? '',
        ));
      },
      child: Container(
        width: 100.w,
        margin: EdgeInsets.only(bottom: 22),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: snap.photoUrl!,
              imageBuilder: (context, imgProvider) => Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image:
                        DecorationImage(image: imgProvider, fit: BoxFit.cover),
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AppImages.userPlaceholder.image().image,
                      fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        snap.username ?? '',
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: AppColors.textColour80,
                            ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Visibility(
                        visible: snap.isVerify == true,
                        child: Icon(
                          CupertinoIcons.checkmark_seal_fill,
                          color: Colors.red[900],
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Visibility(
                    visible: snap.bio != '',
                    child: Text(
                      snap.bio!,
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
                    snap.status ?? '',
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
