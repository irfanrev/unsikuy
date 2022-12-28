import 'package:flutter/material.dart';
import 'package:unsikuy_app/gen/assets.gen.dart' as asset;

// ignore: non_constant_identifier_names
final AppImages = asset.Assets.lib.app.resources.images;

class AppColors {
  static const appBar = Color(0xFF00BCB4);
  static const primaryLight = Color(0xFF00BCB4);
  static const primaryDark = Color(0xFF009490);
  static const primaryOrange = Color(0xFFFF9933);
  static const buttonAlt = Color(0xFFF5AC07);
  static const dangerMain = Color(0xFFEC1C24);
  static const dangerBorder = Color(0xFFF58B8F);
  static const dangerSurface = Color(0xFFFDE3E4);
  static const warningMain = Color(0xFFF5AC07);
  static const warningBorder = Color(0xFFF7BD39);
  static const warningSurface = Color(0xFFFBDE9C);
  static const successMain = Color(0xFF009490);
  static const successBorder = Color(0xFF4DB4B1);
  static const successSurface = Color(0xFFB3DFDE);
  static const textColour00 = Color(0xFFFFFFFF);
  static const textColour10 = Color(0xFFE7E7E7);
  static const textColour20 = Color(0xFFCFCFCF);
  static const textColour30 = Color(0xFFB6B6B6);
  static const textColour40 = Color(0xFF9E9E9E);
  static const textColour50 = Color(0xFF868686);
  static const textColour60 = Color(0xFF6E6E6E);
  static const textColour70 = Color(0xFF565656);
  static const textColour80 = Color(0xFF3D3D3D);
  static const textColour90 = Color(0xFF252525);
  static const textColour100 = Color(0xFF0D0D0D);

  // shades and tint
  static const shadesPrimaryLight10 = Color(0xFFE5F8F7);
  static const shadesPrimaryLight20 = Color(0xFFCCF2F0);
  static const shadesPrimaryLight30 = Color(0xFFB3EBE9);
  static const shadesPrimaryLight40 = Color(0xFF99E4E1);
  static const shadesPrimaryLight50 = Color(0xFF80DDD9);
  static const shadesPrimaryLight60 = Color(0xFF66D7D2);
  static const shadesPrimaryLight70 = Color(0xFF4DD0CB);
  static const shadesPrimaryLight80 = Color(0xFF33C9C3);
  static const shadesPrimaryLight90 = Color(0xFF1AC3BB);
  static const shadesPrimaryLight100 = Color(0xFF00BCB4);
  static const shadesPrimaryDark10 = Color(0xFFE5F4F4);
  static const shadesPrimaryDark20 = Color(0xFFCCEAE9);
  static const shadesPrimaryDark30 = Color(0xFFB3DFDE);
  static const shadesPrimaryDark40 = Color(0xFF99D4D3);
  static const shadesPrimaryDark50 = Color(0xFF80C9C7);
  static const shadesPrimaryDark60 = Color(0xFF66BFBC);
  static const shadesPrimaryDark70 = Color(0xFF4DB4B1);
  static const shadesPrimaryDark80 = Color(0xFF33A9A6);
  static const shadesPrimaryDark90 = Color(0xFF1A9F9B);
  static const shadesPrimaryDark100 = Color(0xFF009490);

  // from suitcore
  static const colorSecondary = Colors.teal;
  static const colorAccent = Colors.white;
  static const black = Colors.black;
  static const white = Colors.white;
  static const grey = Colors.grey;
  static const grey20 = Color(0xFFF3F4F6);
  static const red = Colors.red;
  static const borderColor = Colors.black12;
  static const textHintColor = Color(0xFF868686);
  static const error = Color(0xFFEC1C24);
  static const errorField = Color(0xFFFDE3E4);
  static const subHintColor = Colors.black45;
  static const gray = Color(0xFF838BA1);
  static const shadesPrimary = Color(0xFFB3EBE9);
  static const turquoiseDark = Color(0xFF009490);
  static const pink = Color(0xFFFAD9DB);
}

class AppElevation {
  static BoxShadow elevation2px = BoxShadow(
    color: AppColors.black.withOpacity(0.05),
    spreadRadius: 0,
    blurRadius: 7,
    offset: const Offset(0, 3),
  );
  static BoxShadow elevation4px = BoxShadow(
    color: Color(0xFF000E33).withOpacity(0.10),
    spreadRadius: 0,
    blurRadius: 10,
    offset: const Offset(0, 2),
  );
  static BoxShadow elevation4pxBottom = BoxShadow(
    color: Color(0xFF000E33).withOpacity(0.04),
    spreadRadius: 0,
    blurRadius: 4,
    offset: const Offset(0, 4),
  );
  static BoxShadow elevation4pxUp = BoxShadow(
    color: Color(0xFF000E33).withOpacity(0.04),
    spreadRadius: 0,
    blurRadius: 4,
    offset: const Offset(0, -4),
  );
  static BoxShadow elevation7px = BoxShadow(
    color: Color(0xFF000E33).withOpacity(0.20),
    spreadRadius: 0,
    blurRadius: 7,
    offset: const Offset(0, 2),
  );
  static BoxShadow elevation9px = BoxShadow(
    color: Color(0xFF000E33).withOpacity(0.20),
    spreadRadius: 0,
    blurRadius: 11,
    offset: const Offset(0, 2),
  );
}

class AppGradient {
  static LinearGradient turquoiseLight = LinearGradient(
    begin: Alignment.center,
    end: Alignment.topLeft,
    colors: <Color>[Color(0xFF00C5BC), Color(0xFF99E4E1)],
  );
  static LinearGradient turquoiseDark = LinearGradient(
    begin: Alignment.center,
    end: Alignment.topLeft,
    colors: <Color>[
      Color(0xFF009490),
      Color(0xFFB3DFDE),
    ],
  );
}
