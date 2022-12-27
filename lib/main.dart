import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:get/get.dart';
import 'package:unsikuy_app/app/theme/app_theme.dart';

import 'app/routes/app_pages.dart';

void main() {
  if (kDebugMode) {
    debugPrint = (String? message, {int? wrapWidth}) =>
        debugPrintSynchronously(message, wrapWidth: wrapWidth);
  } else {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  WidgetsFlutterBinding.ensureInitialized();
  // await Initializer.initFirebase();
  // await Initializer.init();
  // await Initializer.oneSignalInitial();
  //FileHelper.initDownloader();

  if (kDebugMode) {
    runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MyApp(),
      ),
    );
    // runApp(MyApp());
  } else {
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        // translations: AppTranslation(),
        // locale: LocaleHelper().getCurrentLocale(),
        // fallbackLocale: LocaleHelper().fallbackLocale,
        initialRoute: Routes.LOGIN,
        getPages: AppPages.routes,
        theme: AppTheme.buildThemeData(false),
        builder: (BuildContext context, child) {
          return MediaQuery(
            child: child ?? Container(),
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
      );
    });
  }
}
