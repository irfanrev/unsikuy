import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:sizer/sizer.dart';

import 'package:get/get.dart';
import 'package:unsikuy_app/app/controllers/auth_controller.dart';
import 'package:unsikuy_app/app/modules/login/views/login_view.dart';
import 'package:unsikuy_app/app/theme/app_theme.dart';
import 'package:unsikuy_app/app/utils/widgets/loading_view.dart';

import 'app/routes/app_pages.dart';

void main() async {
  if (kDebugMode) {
    debugPrint = (String? message, {int? wrapWidth}) =>
        debugPrintSynchronously(message, wrapWidth: wrapWidth);
  } else {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      final profC = Get.put(AuthController(), permanent: true);
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        // translations: AppTranslation(),
        // locale: LocaleHelper().getCurrentLocale(),
        // fallbackLocale: LocaleHelper().fallbackLocale,
        initialRoute: box.hasData('token') ? Routes.HOME : Routes.LOGIN,
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
