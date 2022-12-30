import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          IconButton(
              onPressed: () {
                controller.logout();
              },
              icon: Icon(CupertinoIcons.download_circle)),
          Center(
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
