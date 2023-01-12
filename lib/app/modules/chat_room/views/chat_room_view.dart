import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  const ChatRoomView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                children: [
                  BubbleNormal(
                    text:
                        'Added iMassage shape bubbles Added iMassage shape bubbles Added iMassage shape bubbles Added iMassage shape bubbles Added iMassage shape bubbles Added iMassage shape bubbles Added iMassage shape bubbles Added iMassage shape bubbles Added iMassage shape bubbles Added iMassage shape bubbles Added iMassage shape bubbles',
                    color: Color(0xFF1B97F3),
                    tail: true,
                    textStyle: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  BubbleNormal(
                    text: 'Added iMassage shape bubbles',
                    color: Color(0xFF1B97F3),
                    tail: true,
                    isSender: false,
                    textStyle: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  BubbleNormal(
                    text: 'Added iMassage shape bubbles',
                    color: Color(0xFF1B97F3),
                    tail: true,
                    isSender: false,
                    textStyle: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          )),
          MessageBar(
            sendButtonColor: AppColors.primaryLight,
            onSend: (_) => print(_),
            actions: [
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: InkWell(
                  child: Icon(
                    Icons.emoji_emotions,
                    color: Colors.green,
                    size: 24,
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
