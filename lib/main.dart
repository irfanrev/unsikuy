import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';

import 'package:sizer/sizer.dart';

import 'package:get/get.dart';
import 'package:unsikuy_app/app/controllers/auth_controller.dart';
import 'package:unsikuy_app/app/modules/login/views/login_view.dart';
import 'package:unsikuy_app/app/theme/app_theme.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_view.dart';

import 'app/routes/app_pages.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title

  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  if (kDebugMode) {
    debugPrint = (String? message, {int? wrapWidth}) =>
        debugPrintSynchronously(message, wrapWidth: wrapWidth);
  } else {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCSiN5CRA0ZMjQW1JyvMxFedLc9q7YuCzQ',
        appId: '1:597615739121:web:927e9f37437206fc0e2950',
        messagingSenderId: '597615739121',
        projectId: 'unsika-connect',
        authDomain: 'unsika-connect.firebaseapp.com',
        storageBucket: 'unsika-connect.appspot.com',
        measurementId: 'G-F3XL1S8VQG',
      ),
    );
  } else {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
  await GetStorage.init();
  //await Initializer.init();
  // await Initializer.oneSignalInitial();
  //FileHelper.initDownloader();

  // if (kDebugMode) {
  //   runApp(
  //     DevicePreview(
  //       enabled: !kReleaseMode,
  //       builder: (context) => MyApp(),
  //     ),
  //   );
  //   // runApp(MyApp());
  // } else {
  //   runApp(MyApp());
  // }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      GetStorage box = GetStorage();
      final authC = Get.put(AuthController(), permanent: true);
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        // translations: AppTranslation(),
        // locale: LocaleHelper().getCurrentLocale(),
        // fallbackLocale: LocaleHelper().fallbackLocale,
        initialRoute: (kIsWeb)
            ? box.hasData('token')
                ? Routes.HOME
                : Routes.LOGIN
            : box.hasData('skipOnboard')
                ? box.hasData('token')
                    ? Routes.HOME
                    : Routes.LOGIN
                : Routes.ONBOARDING,
        getPages: AppPages.routes,
        theme: AppTheme.buildThemeData(false),
        // builder: (BuildContext context, child) {
        //   return MediaQuery(
        //     child: child ?? Container(),
        //     data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        //   );
        // },
      );
    });
  }
}
