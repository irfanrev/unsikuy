import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:unsikuy_app/app/controllers/auth_controller.dart';
import 'package:unsikuy_app/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:unsikuy_app/app/modules/post/controllers/post_controller.dart';
import 'package:unsikuy_app/app/modules/post/widgets/post_card.dart';
import 'package:unsikuy_app/app/modules/profile/views/view_avatar.dart';
import 'package:unsikuy_app/app/modules/profile/widgets/mydiscuss_card.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:unsikuy_app/app/utils/widgets/bottom_sheet_helper.dart';
import 'package:unsikuy_app/app/utils/widgets/image_load.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_overlay.dart';
import 'package:unsikuy_app/app/utils/widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends StatefulWidget {
  String? uuid;
  ProfileView({Key? key, this.uuid}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  var userData = {};
  int postLen = 0;
  int discussLen = 0;
  int connecters = 0;
  bool isLoading = false;
  bool isConnecters = false;
  bool checkIsConnected = false;
  GetStorage box = GetStorage();

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
    TabController tabController = TabController(length: 3, vsync: this);
    return isLoading
        ? LoadingOverlay()
        : Scaffold(
            appBar: AppBar(
              leadingWidth: 28,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    userData['username'],
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: AppColors.textColour80),
                  ),
                  Visibility(
                    visible: userData['isVerify'] == true,
                    child: const SizedBox(
                      width: 4,
                    ),
                  ),
                  Visibility(
                    visible: userData['isVerify'] == true,
                    child: Icon(
                      CupertinoIcons.checkmark_seal_fill,
                      color: Colors.red[900],
                      size: 14,
                    ),
                  ),
                ],
              ),
              centerTitle: false,
              actions: [
                Visibility(
                  visible:
                      widget.uuid != FirebaseAuth.instance.currentUser!.uid,
                  child: PopupMenuButton(
                    padding: const EdgeInsets.all(4),
                    iconSize: 16,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: ListTile(
                          onTap: () {
                            showBarBottomSheet(context, expand: false,
                                builder: (context) {
                              return Container(
                                width: 100.w,
                                color: AppColors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              icon: Icon(Icons.close))
                                        ],
                                      ),
                                      Divider(),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        'Why are you reporting this account?',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Obx(
                                        () => ChipsChoice<int>.single(
                                          value: profC.tag.value,
                                          onChanged: (val) {
                                            profC.tag.value = val;
                                          },
                                          choiceItems:
                                              C2Choice.listFrom<int, String>(
                                            source: profC.options,
                                            value: (i, v) => i,
                                            label: (i, v) => v,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        'Other reason',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      TextFormField(
                                        controller: profC.reportC,
                                        decoration: InputDecoration(
                                          hintText: 'Enter your reason',
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide:
                                                BorderSide.none, //<-- SEE HERE
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide.none, //<-- SEE HERE
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: AppColors
                                                    .primaryLight), //<-- SEE HERE
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.copyWith(
                                                  color: AppColors.textColour50,
                                                  fontSize: 16),
                                          filled: true,
                                          fillColor: AppColors.grey.shade100,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(fontSize: 16),
                                        keyboardType: TextInputType.text,
                                      ),
                                      const SizedBox(
                                        height: 32,
                                      ),
                                      PrimaryButton(
                                        title: 'Submit',
                                        onPressed: () {
                                          profC.sendEmail(userData['username'],
                                              userData['uuid']);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(CupertinoIcons.flag),
                          title: Text(
                            'Report account',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                          child: ListTile(
                        onTap: () {
                          Get.defaultDialog(
                              radius: 8,
                              titlePadding: EdgeInsets.symmetric(vertical: 16),
                              title: 'Block this account?',
                              titleStyle: Theme.of(context).textTheme.headline4,
                              middleText: 'Block this account permanently',
                              cancel: TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  'Cancel',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              confirm: TextButton(
                                onPressed: () {
                                  profC.blockUser(userData['username']);
                                  Get.back();
                                },
                                child: Text(
                                  'Oke',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ));
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(CupertinoIcons.shield_slash),
                        title: Text(
                          'Block account',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ))
                    ],
                  ),
                ),
              ],
            ),
            body: Obx(
              () => authC.isLoading.value == true
                  ? LoadingOverlay()
                  : Padding(
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
                                      width: 60,
                                      height: 60,
                                      child: Hero(
                                        tag: 'pp',
                                        child: ImageLoad(
                                            shapeImage: ShapeImage.oval,
                                            placeholder: AppImages
                                                .userPlaceholder
                                                .image()
                                                .image,
                                            image: userData['photoUrl'],
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                userData['username'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4!
                                                    .copyWith(
                                                      color: AppColors
                                                          .textColour80,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          userData['status'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Visibility(
                                    visible: widget.uuid !=
                                        FirebaseAuth.instance.currentUser!.uid,
                                    child: InkWell(
                                      onTap: () {
                                        authC.addNewConnection(
                                            userData['email'],
                                            userData['uuid'],
                                            userData['username']);
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
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
                                  Chip(
                                    backgroundColor: AppColors.grey.shade200,
                                    label: Row(
                                      children: [
                                        Text(
                                          postLen.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(
                                                color: AppColors.textColour60,
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
                                                color: AppColors.textColour60,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(Routes.MYDISCUSS,
                                          arguments: userData['uuid']);
                                    },
                                    child: Chip(
                                      backgroundColor: AppColors.grey.shade200,
                                      label: Row(
                                        children: [
                                          Text(
                                            discussLen.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(
                                                    color:
                                                        AppColors.textColour60),
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
                                                    color:
                                                        AppColors.textColour60),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
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
                                    child: Chip(
                                      backgroundColor: AppColors.grey.shade200,
                                      label: Row(
                                        children: [
                                          Text(
                                            connecters.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(
                                                    color:
                                                        AppColors.textColour60),
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
                                                    color:
                                                        AppColors.textColour60),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            FirebaseAuth.instance.currentUser!.uid ==
                                    widget.uuid
                                ? InkWell(
                                    onTap: () {
                                      Get.offAll(EditProfileView(
                                        photoUrl:
                                            userData['photoUrl'].toString(),
                                        username:
                                            userData['username'].toString(),
                                        email: userData['email'].toString(),
                                      ));
                                    },
                                    child: Container(
                                      width: 100.w,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: AppColors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 0.8,
                                              color: AppColors.grey.shade300)),
                                      child: Center(
                                        child: Text(
                                          'Edit Profile',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(
                                                  color:
                                                      AppColors.textColour80),
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  width: 0.8,
                                                  color:
                                                      AppColors.grey.shade300)),
                                          child: Center(
                                            child: Text(
                                              'Disconnect',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5!
                                                  .copyWith(
                                                      color: AppColors
                                                          .textColour80),
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
                                            userData['isVerify'],
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  width: 0.8,
                                                  color:
                                                      AppColors.grey.shade300)),
                                          child: Center(
                                            child: Text(
                                              'Connect',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5!
                                                  .copyWith(
                                                      color: AppColors
                                                          .textColour80),
                                            ),
                                          ),
                                        ),
                                      ),

                            const SizedBox(
                              height: 20,
                            ),
                            // Container(
                            //   width: 100.w,
                            //   child: Text(
                            //     'Sharing History',
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .headline5!
                            //         .copyWith(color: AppColors.textColour80),
                            //     textAlign: TextAlign.left,
                            //   ),
                            // ),
                            Container(
                              child: TabBar(
                                controller: tabController,
                                labelColor: AppColors.black,
                                unselectedLabelColor: AppColors.textColour50,
                                labelStyle:
                                    Theme.of(context).textTheme.headline6,
                                tabs: [
                                  Tab(
                                    child: Text(
                                      userData['username'],
                                      maxLines: 1,
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      'Sharing',
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      'Discussion',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 100.w,
                              height: Get.height * 0.77,
                              child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Visibility(
                                            visible: userData['about'] != '',
                                            child: Container(
                                              margin: EdgeInsets.only(top: 22),
                                              width: 100.w,
                                              child: Text(
                                                'About',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5!
                                                    .copyWith(
                                                        color: AppColors
                                                            .textColour80),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Visibility(
                                            visible: userData['about'] != '',
                                            child: Container(
                                              width: 100.w,
                                              child: Container(
                                                width: 100.w,
                                                //height: 200,
                                                //color: AppColors.shadesPrimaryDark20,
                                                child: Text(
                                                  userData['about'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                        color: AppColors.black,
                                                        height: 1.5,
                                                        fontSize: 15,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: userData['about'] != '',
                                            child: const SizedBox(
                                              height: 10,
                                            ),
                                          ),
                                          Visibility(
                                            visible: userData['about'] != '',
                                            child: Divider(
                                              color: AppColors.grey.shade200,
                                              indent: 2,
                                              thickness: 1.3,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 16),
                                            width: 100.w,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Connect with other platforms',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5!
                                                      .copyWith(
                                                          color: AppColors
                                                              .textColour80),
                                                  textAlign: TextAlign.left,
                                                ),
                                                // Visibility(
                                                //   visible: userData['uuid'] ==
                                                //       FirebaseAuth.instance
                                                //           .currentUser!.uid,
                                                //   child: Container(
                                                //     padding: EdgeInsets.all(6),
                                                //     decoration: BoxDecoration(
                                                //       shape: BoxShape.circle,
                                                //       color: AppColors
                                                //           .grey.shade200,
                                                //     ),
                                                //     child: Icon(
                                                //       Icons.edit_rounded,
                                                //       size: 14,
                                                //       color: AppColors
                                                //           .grey.shade600,
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Wrap(
                                            spacing: 10.0,
                                            children: [
                                              Visibility(
                                                visible:
                                                    box.hasData('whatsapp'),
                                                child: InkWell(
                                                  onTap: () async {
                                                    Uri url = Uri.parse(
                                                        'https://wa.me/${userData['phone']}');
                                                    if (await canLaunchUrl(
                                                        url)) {
                                                      await launchUrl(url,
                                                          mode: LaunchMode
                                                              .externalApplication);
                                                    } else {
                                                      throw 'Could not launch';
                                                    }
                                                  },
                                                  child: Container(
                                                    child: Chip(
                                                      backgroundColor: AppColors
                                                          .shadesPrimaryDark10,
                                                      label: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .whatsapp,
                                                            color: AppColors
                                                                .primaryDark,
                                                            size: 28,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            'WhatsApp',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: userData['ig'] != '',
                                                child: InkWell(
                                                  onTap: () async {
                                                    Uri url = Uri.parse(
                                                        userData['ig']);
                                                    if (await canLaunchUrl(
                                                        url)) {
                                                      await launchUrl(url,
                                                          mode: LaunchMode
                                                              .externalApplication);
                                                    } else {
                                                      throw 'Could not launch';
                                                    }
                                                  },
                                                  child: Container(
                                                    child: Chip(
                                                      backgroundColor: AppColors
                                                          .shadesPrimaryDark10,
                                                      label: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .instagram,
                                                            color: AppColors
                                                                .primaryDark,
                                                            size: 28,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            'Instagram',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible:
                                                    userData['linkedin'] != '',
                                                child: InkWell(
                                                  onTap: () async {
                                                    Uri url = Uri.parse(
                                                        userData['linkedin']);
                                                    if (await canLaunchUrl(
                                                        url)) {
                                                      await launchUrl(url,
                                                          mode: LaunchMode
                                                              .externalApplication);
                                                    } else {
                                                      throw 'Could not launch';
                                                    }
                                                  },
                                                  child: Container(
                                                    child: Chip(
                                                      backgroundColor: AppColors
                                                          .shadesPrimaryDark10,
                                                      label: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .linkedin,
                                                            color: AppColors
                                                                .primaryDark,
                                                            size: 28,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            'LinkedIn',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible:
                                                    userData['twitter'] != '',
                                                child: InkWell(
                                                  onTap: () async {
                                                    Uri url = Uri.parse(
                                                        userData['twitter']);
                                                    if (await canLaunchUrl(
                                                        url)) {
                                                      await launchUrl(url,
                                                          mode: LaunchMode
                                                              .externalApplication);
                                                    } else {
                                                      throw 'Could not launch';
                                                    }
                                                  },
                                                  child: Container(
                                                    child: Chip(
                                                      backgroundColor: AppColors
                                                          .shadesPrimaryDark10,
                                                      label: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .twitter,
                                                            color: AppColors
                                                                .primaryDark,
                                                            size: 28,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            'Twitter',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: userData['web'] != '',
                                                child: InkWell(
                                                  onTap: () async {
                                                    Uri url = Uri.parse(
                                                        userData['web']);
                                                    if (await canLaunchUrl(
                                                        url)) {
                                                      await launchUrl(url,
                                                          mode: LaunchMode
                                                              .externalApplication);
                                                    } else {
                                                      throw 'Could not launch';
                                                    }
                                                  },
                                                  child: Container(
                                                    child: Chip(
                                                      backgroundColor: AppColors
                                                          .shadesPrimaryDark10,
                                                      label: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .link,
                                                            size: 20,
                                                            color: AppColors
                                                                .primaryDark,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            'Personal Website',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Divider(
                                            color: AppColors.grey.shade200,
                                            indent: 2,
                                            thickness: 1.3,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      width: 100.w,
                                      child: FutureBuilder(
                                          future: FirebaseFirestore.instance
                                              .collection('posts')
                                              .where('uuid',
                                                  isEqualTo: widget.uuid)
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 60),
                                                child: LoadingOverlay(),
                                              );
                                            }
                                            if ((snapshot.data! as dynamic)
                                                    .docs
                                                    .length ==
                                                0) {
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
                                                  itemCount: (snapshot.data!
                                                          as dynamic)
                                                      .docs
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return PostCardItem(
                                                        snap: (snapshot.data!
                                                                as dynamic)
                                                            .docs[index],
                                                        controller: c);
                                                  });
                                            }
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      child: FutureBuilder(
                                        future: FirebaseFirestore.instance
                                            .collection('discussion')
                                            .where('uuid',
                                                isEqualTo: userData['uuid'])
                                            .get(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return LoadingOverlay();
                                          }
                                          if ((snapshot.data! as dynamic)
                                                  .docs
                                                  .length ==
                                              0) {
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
                                                    (snapshot.data! as dynamic)
                                                        .docs
                                                        .length,
                                                itemBuilder: (context, index) {
                                                  return MydiscussCard(
                                                    snap: (snapshot.data!
                                                            as dynamic)
                                                        .docs[index],
                                                    controller: profC,
                                                  );
                                                });
                                          }
                                        },
                                      ),
                                    ),
                                  ]),
                            ),

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
                    ),
            ),
          );
  }
}
