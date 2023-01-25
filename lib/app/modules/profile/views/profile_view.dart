import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/controllers/auth_controller.dart';
import 'package:unsikuy_app/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:unsikuy_app/app/modules/post/controllers/post_controller.dart';
import 'package:unsikuy_app/app/modules/post/widgets/post_card.dart';
import 'package:unsikuy_app/app/modules/profile/views/view_avatar.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_overlay.dart';
import 'package:unsikuy_app/app/utils/widgets/primary_button.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends StatefulWidget {
  String? uuid;
  ProfileView({Key? key, this.uuid}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  var userData = {};
  int postLen = 0;
  int discussLen = 0;
  int connecters = 0;
  bool isLoading = false;
  bool isConnecters = false;
  bool checkIsConnected = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uuid)
          .get();
      var connecterLength = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uuid)
          .collection('connected')
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uuid', isEqualTo: widget.uuid)
          .get();
      var disSnap = await FirebaseFirestore.instance
          .collection('discussion')
          .where('uuid', isEqualTo: widget.uuid)
          .get();

      postLen = postSnap.docs.length;
      discussLen = disSnap.docs.length;
      userData = snap.data()!;
      connecters = connecterLength.docs.length;
      var cekkoneksi = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uuid)
          .collection('connected')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();
      checkIsConnected = cekkoneksi
          .data()!['uuid']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      // isConnecters = snap
      //     .data()!['connecters']
      //     .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  void dispose() {
    userData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PostController());
    final authC = Get.find<AuthController>();
    final profC = Get.put(ProfileController());
    return isLoading
        ? LoadingOverlay()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Profile',
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: AppColors.textColour80),
              ),
              centerTitle: false,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: 100.w,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(ViewAvatar(
                                photo: userData['photoUrl'],
                              ));
                            },
                            child: Container(
                              width: 90,
                              height: 90,
                              child: ImageLoad(
                                  shapeImage: ShapeImage.oval,
                                  placeholder:
                                      AppImages.userPlaceholder.image().image,
                                  image: userData['photoUrl'],
                                  fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData['username'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                        color: AppColors.textColour80,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  userData['status'],
                                  style: Theme.of(context).textTheme.bodyText1!,
                                )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: widget.uuid !=
                                FirebaseAuth.instance.currentUser!.uid,
                            child: InkWell(
                              onTap: () {
                                authC.addNewConnection(
                                    userData['email'], userData['uuid']);
                              },
                              child: const Icon(
                                CupertinoIcons.chat_bubble_text,
                                size: 30,
                                color: AppColors.primaryLight,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          // InkWell(
                          //   onTap: () {},
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(10),
                          //         color: AppColors.primaryLight),
                          //     padding: EdgeInsets.symmetric(
                          //         horizontal: 10, vertical: 6),
                          //     child: Center(
                          //       child: Text(
                          //         'Message',
                          //         style: Theme.of(context)
                          //             .textTheme
                          //             .headline6!
                          //             .copyWith(
                          //               color: AppColors.white,
                          //             ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),

                    Visibility(
                      visible: userData['bio'] != '',
                      child: SizedBox(
                        height: 12,
                      ),
                    ),
                    Container(
                      width: 100.w,
                      //height: 200,
                      //color: AppColors.shadesPrimaryDark20,
                      child: Text(
                        userData['bio'],
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: AppColors.black,
                              height: 1.4,
                            ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: 100.w,
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                postLen.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                      color: AppColors.primaryDark,
                                    ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Sharing',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: AppColors.primaryDark,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.MYDISCUSS,
                                  arguments: userData['uuid']);
                            },
                            child: Row(
                              children: [
                                Text(
                                  discussLen.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        color: AppColors.primaryDark,
                                      ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'Discussion',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: AppColors.primaryDark,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          // Text('|',
                          //     style: Theme.of(context).textTheme.headline3),
                          // const SizedBox(
                          //   width: 8,
                          // ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.CONNECTED_VIEW,
                                  arguments: userData['uuid']);
                            },
                            child: Row(
                              children: [
                                Text(
                                  connecters.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        color: AppColors.primaryDark,
                                      ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'Connecters',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: AppColors.primaryDark,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FirebaseAuth.instance.currentUser!.uid == widget.uuid
                        ? InkWell(
                            onTap: () {
                              Get.offAll(EditProfileView(
                                photoUrl: userData['photoUrl'].toString(),
                                username: userData['username'].toString(),
                                email: userData['email'].toString(),
                              ));
                            },
                            child: Container(
                              width: 100.w,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: AppColors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 0.8,
                                      color: AppColors.grey.shade300)),
                              child: Center(
                                child: Text(
                                  'Edit Profile',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(color: AppColors.textColour80),
                                ),
                              ),
                            ),
                          )
                        : checkIsConnected
                            ? InkWell(
                                onTap: () async {
                                  await c.disconnectUser(
                                    userData['uuid'],
                                    userData['username'],
                                    userData['email'],
                                    userData['photoUrl'],
                                    userData['status'],
                                    userData['bio'],
                                  );
                                  setState(() {
                                    checkIsConnected = false;
                                    connecters--;
                                  });
                                },
                                child: Container(
                                  width: 100.w,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: AppColors.grey.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 0.8,
                                          color: AppColors.grey.shade300)),
                                  child: Center(
                                    child: Text(
                                      'Disconnect',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(
                                              color: AppColors.textColour80),
                                    ),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () async {
                                  await c.connectUser(
                                    userData['uuid'],
                                    userData['username'],
                                    userData['email'],
                                    userData['photoUrl'],
                                    userData['status'],
                                    userData['bio'],
                                  );
                                  setState(() {
                                    checkIsConnected = true;
                                    connecters++;
                                  });
                                },
                                child: Container(
                                  width: 100.w,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: AppColors.grey.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 0.8,
                                          color: AppColors.grey.shade300)),
                                  child: Center(
                                    child: Text(
                                      'Connect',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(
                                              color: AppColors.textColour80),
                                    ),
                                  ),
                                ),
                              ),

                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 100.w,
                      child: Text(
                        'Sharing History',
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: AppColors.textColour80),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uuid', isEqualTo: widget.uuid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 60),
                              child: LoadingOverlay(),
                            );
                          }
                          if ((snapshot.data! as dynamic).docs.length == 0) {
                            return Center(
                              child: Container(
                                width: 150,
                                child: Lottie.asset(
                                    'lib/app/resources/images/not-found.json'),
                              ),
                            );
                          } else {
                            return ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount:
                                    (snapshot.data! as dynamic).docs.length,
                                itemBuilder: (context, index) {
                                  return PostCardItem(
                                      snap: (snapshot.data! as dynamic)
                                          .docs[index],
                                      controller: c);
                                });
                          }
                        }),

                    // IconButton(
                    //     onPressed: () {
                    //       controller.logout();
                    //     },
                    //     icon: Icon(CupertinoIcons.download_circle)),
                    // Center(
                    //   child: Text(
                    //     'Logout',
                    //     style: TextStyle(fontSize: 20),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ));
  }
}
