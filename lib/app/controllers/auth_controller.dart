import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:unsikuy_app/app/model/chat.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserCredential? userCredential;
  String mToken = '';

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    initFirst();
    requestPermission();
    getToken();
    super.onInit();
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void initFirst() async {
    await FirebaseMessaging.instance.subscribeToTopic('all');
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: android.smallIcon,
              ),
            ));
      }
    });
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      mToken = token.toString();
      print('user token : $mToken');
      saveToken(token.toString());
    });
  }

  void saveToken(String token) async {
    await firestore.collection('userToken').doc(auth.currentUser!.uid).set({
      'token': token,
    });
  }

  void sendPustNotification(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAiySsgPE:APA91bFImNrylFdUbkA5WjIKqZ1oDjG42Xtfc4inm5K8xouoZ8BrmMe82Sy-0du7znCb8iyesYsJcEB38Ro87-S4HFWJBenxqldwxeRvZqQRXJSswIPptrysSOMsSOvmkgPCVhwmTPmL',
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'token': token,
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'title': title,
            'body': body,
          },
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
            'sound': 'default',
          },
          'to': token,
        }),
      );
      print('Notifikasi has sended');
    } catch (e) {
      print(e);
    }
  }

  void sendPostNotif(String body, String title) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic('all');
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAiySsgPE:APA91bFImNrylFdUbkA5WjIKqZ1oDjG42Xtfc4inm5K8xouoZ8BrmMe82Sy-0du7znCb8iyesYsJcEB38Ro87-S4HFWJBenxqldwxeRvZqQRXJSswIPptrysSOMsSOvmkgPCVhwmTPmL',
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'topic': 'all',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'title': title,
            'body': body,
          },
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
            'sound': 'default',
          },
        }),
      );
      print('Notifikasi has sended');
    } catch (e) {
      print(e);
    }
  }

  void addNewConnection(String friendEmail, String uuid, String name) async {
    isLoading.value = true;
    try {
      String date = DateTime.now().toString();
      bool flagNewConnection = false;
      CollectionReference chats = firestore.collection('chats');
      CollectionReference users = firestore.collection('users');
      var chat_id;
      //TOTO : Fixing chats collection

      final checkIsConnected = await users
          .doc(uuid)
          .collection('connected')
          .where('uuid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (checkIsConnected.docs.length != 0) {
        final docChats = await users
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('chats')
            .get();

        if (docChats.docs.length != 0) {
          // udah ada data
          final checkConnection = await users
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('chats')
              .where('connection', isEqualTo: friendEmail)
              .get();
          if (checkConnection.docs.length != 0) {
            flagNewConnection = false;
            //ambil chat id dari colletion
            chat_id = checkConnection.docs[0].id;
          } else {
            flagNewConnection = true;
          }
        } else {
          // belum ada data, buat baru!
          flagNewConnection = true;
        }

        if (flagNewConnection) {
          final chatDocs = await chats.where("connection", whereIn: [
            [
              FirebaseAuth.instance.currentUser!.email,
              friendEmail,
            ],
            [
              friendEmail,
              FirebaseAuth.instance.currentUser!.email,
            ],
          ]).get();

          if (chatDocs.docs.length != 0) {
            // ada data
            final String chatDataId = chatDocs.docs[0].id;
            final Map<String, dynamic> chatData =
                (chatDocs.docs[0].data() as Map<String, dynamic>);

            // Cek dan tambah chat

            await users
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('chats')
                .doc(chatDataId)
                .set({
              "connection": friendEmail,
              'lastTime': chatData['lastTime'],
              "uuid": uuid,
              "total_unread": 0,
              "name": name,
            });

            chat_id = chatDataId;
          } else {
            // buat baru
            final newChatDoc = await chats.add({
              "connection": [
                FirebaseAuth.instance.currentUser!.email,
                friendEmail,
              ],
            });

            await chats.doc(newChatDoc.id).collection('chat');

            await users
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('chats')
                .doc(newChatDoc.id)
                .set({
              "connection": friendEmail,
              'lastTime': date,
              "uuid": uuid,
              "total_unread": 0,
              "name": name,
            });

            chat_id = newChatDoc.id;
          }
        }

        final updateStatusChat = await chats
            .doc(chat_id)
            .collection('chat')
            .where('isRead', isEqualTo: false)
            .where('penerima',
                isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .get();

        updateStatusChat.docs.forEach((element) async {
          await chats.doc(chat_id).collection('chat').doc(element.id).update({
            'isRead': true,
          });
        });

        await users
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('chats')
            .doc(chat_id)
            .update({
          'total_unread': 0,
        });

        print(chat_id);
        Get.toNamed(Routes.CHAT_ROOM, arguments: {
          'chat_id': chat_id,
          'friendEmail': friendEmail,
          'uuid': uuid,
        });
      } else {
        showNotif('You mus be a connected',
            'Tap on Connect button to use Chat feature');
      }
      isLoading.value = false;

      // fixing diatas

      // final docUser = await users.doc(currentUserNow!.uid).get();
      // final docChats =
      //     (docUser.data() as Map<String, dynamic>)['chats'] as List;

      // if (docChats != null) {
      //   docChats.forEach((singleChat) {
      //     if (singleChat['connection'] == friendEmail) {
      //       chat_id = singleChat['chat_id'];
      //     }
      //   });

      //   if (chat_id != null) {
      //     flagNewConnection = false;
      //     // Get.toNamed(Routes.CHAT_ROOM, arguments: chat_id);
      //   } else {
      //     flagNewConnection = true;
      //   }
      // } else {
      //   flagNewConnection = true;
      // }

    } catch (e) {
      print(e);
    }
  }
}

showError(String title, String message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: AppColors.error,
    colorText: AppColors.white,
  );
}

void showNotif(String title, String message) {
  Get.snackbar(
    title,
    message.toString(),
    backgroundColor: AppColors.primaryLight,
    colorText: Colors.white,
  );
}
