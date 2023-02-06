import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unsikuy_app/app/modules/chats/views/chats_view.dart';
import 'package:unsikuy_app/app/modules/discussion/views/discussion_view.dart';
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
                  DiscussionView(),
                  ChatsView(),
                  ProfileView(
                    uuid: FirebaseAuth.instance.currentUser!.uid,
                  ),
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
                showSelectedLabels: false,
                showUnselectedLabels: false,
                unselectedItemColor: Colors.black,
                selectedItemColor: AppColors.primaryDark,
                landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
                items: [
                  _bottomNavigationBarItem(
                    icon: EvaIcons.homeOutline,
                  ),
                  _bottomNavigationBarItem(
                    icon: EvaIcons.peopleOutline,
                  ),
                  _bottomNavigationBarItem(
                    icon: CupertinoIcons.chat_bubble_2,
                  ),
                  _bottomNavigationBarItem(
                    icon: EvaIcons.messageCircleOutline,
                  ),
                  _bottomNavigationBarItem(
                    icon: CupertinoIcons.person_crop_circle,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _bottomNavigationBarItem({required IconData icon}) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
      ),
      label: '',
    );
  }
}
