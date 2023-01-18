import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/modules/post/controllers/post_controller.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentCard extends StatelessWidget {
  final snap;
  final PostController controller;
  const CommentCard({super.key, required this.snap, required this.controller});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(snap['published_at']);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipRRect(
                child: ImageLoad(
              shapeImage: ShapeImage.oval,
              placeholder: AppImages.userPlaceholder.image().image,
              image: snap['profilePict'] ?? '',
              fit: BoxFit.cover,
            )),
          ),
          const SizedBox(
            width: 6,
          ),
          Expanded(
            child: Container(
              width: 100.w,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16)),
                  color: AppColors.grey.shade100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        snap['username'],
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: AppColors.textColour80,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      // Icon(
                      //   CupertinoIcons.hand_thumbsup,
                      //   size: 20,
                      //   color: AppColors.grey.shade500,
                      // )
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    DateFormat.Hm().format(dateTime),
                    //DateFormat.Hm().format(snap['published_at'].toDate()),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.textColour50,
                          fontSize: 10,
                        ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Linkify(
                    text: snap['text'],
                    onOpen: (value) async {
                      Uri url = Uri.parse(value.url);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Could not launch $value.url';
                      }
                    },
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColors.black,
                          height: 1.4,
                        ),
                    linkStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    DateFormat.yMMMMEEEEd().format(dateTime),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.textColour50,
                          fontSize: 12,
                        ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
