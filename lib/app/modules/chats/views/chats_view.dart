import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:unsikuy_app/app/modules/chats/widgets/user_card_chat.dart';
import 'package:unsikuy_app/app/resources/resource.dart';

import '../controllers/chats_controller.dart';

class ChatsView extends GetView<ChatsController> {
  const ChatsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Chat',
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: AppColors.textColour80),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              UserCardChat(),
              UserCardChat(),
            ],
          ),
        ));
  }
}
