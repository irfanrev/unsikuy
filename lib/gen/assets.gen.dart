/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $LibGen {
  const $LibGen();

  $LibAppGen get app => const $LibAppGen();
}

class $LibAppGen {
  const $LibAppGen();

  $LibAppResourcesGen get resources => const $LibAppResourcesGen();
}

class $LibAppResourcesGen {
  const $LibAppResourcesGen();

  $LibAppResourcesImagesGen get images => const $LibAppResourcesImagesGen();
}

class $LibAppResourcesImagesGen {
  const $LibAppResourcesImagesGen();

  /// File path: lib/app/resources/images/empty_state_code.png
  AssetGenImage get emptyStateCode =>
      const AssetGenImage('lib/app/resources/images/empty_state_code.png');

  /// File path: lib/app/resources/images/ic_logo_suitcore_main.png
  AssetGenImage get icLogoSuitcoreMain =>
      const AssetGenImage('lib/app/resources/images/ic_logo_suitcore_main.png');

  /// File path: lib/app/resources/images/img_empty.png
  AssetGenImage get imgEmpty =>
      const AssetGenImage('lib/app/resources/images/img_empty.png');

  /// File path: lib/app/resources/images/img_error.png
  AssetGenImage get imgError =>
      const AssetGenImage('lib/app/resources/images/img_error.png');

  /// File path: lib/app/resources/images/img_login_ilust.png
  AssetGenImage get imgLoginIlust =>
      const AssetGenImage('lib/app/resources/images/img_login_ilust.png');

  /// File path: lib/app/resources/images/img_logo.png
  AssetGenImage get imgLogo =>
      const AssetGenImage('lib/app/resources/images/img_logo.png');

  /// File path: lib/app/resources/images/img_splashbg.png
  AssetGenImage get imgSplashbg =>
      const AssetGenImage('lib/app/resources/images/img_splashbg.png');

  /// File path: lib/app/resources/images/regis-success.png
  AssetGenImage get regisSuccess =>
      const AssetGenImage('lib/app/resources/images/regis-success.png');

  /// File path: lib/app/resources/images/user_placeholder.png
  AssetGenImage get userPlaceholder =>
      const AssetGenImage('lib/app/resources/images/user_placeholder.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        emptyStateCode,
        icLogoSuitcoreMain,
        imgEmpty,
        imgError,
        imgLoginIlust,
        imgLogo,
        imgSplashbg,
        regisSuccess,
        userPlaceholder
      ];
}

class Assets {
  Assets._();

  static const $LibGen lib = $LibGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider() => AssetImage(_assetName);

  String get path => _assetName;

  String get keyName => _assetName;
}
