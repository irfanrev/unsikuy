import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';

class UserCard extends StatelessWidget {
  final snap;
  const UserCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              image: snap['photoUrl'] == ''
                  ? 'https://firebasestorage.googleapis.com/v0/b/unsika-connect.appspot.com/o/user_placeholder.png?alt=media&token=d78dc4cb-0e08-4023-bc8d-6a361c4cd461'
                  : snap['photoUrl'],
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
                        color: AppColors.textColour70,
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
    );
  }
}
