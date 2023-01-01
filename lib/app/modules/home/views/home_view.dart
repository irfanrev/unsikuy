import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unsikuy_app/app/modules/chats/views/chats_view.dart';
import 'package:unsikuy_app/app/modules/home/controllers/home_controller.dart';
import 'package:unsikuy_app/app/modules/people/views/people_view.dart';
import 'package:unsikuy_app/app/modules/post/views/post_view.dart';
import 'package:unsikuy_app/app/modules/profile/views/profile_view.dart';
import 'package:unsikuy_app/app/modules/upload/views/upload_view.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/colored_status_bar.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return ColoredStatusBar(
          child: Scaffold(
            body: SafeArea(
              child: IndexedStack(
                index: controller.tabIndex,
                children: [
                  PostView(),
                  PeopleView(),
                  UploadView(),
                  ChatsView(),
                  ProfileView(),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                  color: Colors.grey,
                  border:
                      Border(top: BorderSide(color: Colors.white, width: 1.0))),
              child: BottomNavigationBar(
                onTap: controller.changeTabIndex,
                currentIndex: controller.tabIndex,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                unselectedItemColor: Colors.grey,
                selectedItemColor: AppColors.primaryLight,
                items: [
                  _bottomNavigationBarItem(
                    icon: CupertinoIcons.home,
                    label: 'Home',
                  ),
                  _bottomNavigationBarItem(
                    icon: CupertinoIcons.person_3,
                    label: 'Connect',
                  ),
                  _bottomNavigationBarItem(
                    icon: CupertinoIcons.add_circled,
                    label: 'Post',
                  ),
                  _bottomNavigationBarItem(
                    icon: CupertinoIcons.chat_bubble,
                    label: 'Chat',
                  ),
                  _bottomNavigationBarItem(
                    icon: CupertinoIcons.person_crop_circle,
                    label: 'Profile',
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _bottomNavigationBarItem({required IconData icon, required String label}) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
