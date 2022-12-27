import 'package:flutter/material.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/colored_status_bar.dart';

class SMAppBar extends StatelessWidget {
  const SMAppBar({
    Key? key,
    this.color,
    required this.body,
    this.brightness = Brightness.dark,
    this.backImage,
    this.title,
    this.titleStyle,
    this.backgroundColor,
    this.bgScaffold,
    this.actions,
    this.backCallback,
    this.resizeToAvoidBottomInset,
    this.usingDefaultColorStatusBar = true,
    this.bottom,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.showLeading = true,
  }) : super(key: key);

  final Color? color;
  final Widget body;
  final Brightness brightness;
  final ImageProvider? backImage;
  final String? title;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final Color? bgScaffold;
  final List<Widget>? actions;
  final void Function()? backCallback;
  final bool usingDefaultColorStatusBar;
  final bool? resizeToAvoidBottomInset;
  final PreferredSizeWidget? bottom;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool showLeading;

  @override
  Widget build(BuildContext context) {
    return ColoredStatusBar(
      brightness: brightness,
      color: usingDefaultColorStatusBar ? AppColors.appBar : color,
      child: Scaffold(
        backgroundColor: bgScaffold,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: AppBar(
          title: Text(
            title ?? '',
            style: titleStyle ??
                Theme.of(context).textTheme.headline3?.copyWith(
                    fontWeight: FontWeight.w500, color: Colors.white),
          ),
          centerTitle: false,
          backgroundColor: backgroundColor ?? Colors.transparent,
          elevation: 0.0,
          leading: showLeading
              ? InkWell(
                  onTap: backCallback ?? () => Navigator.of(context).pop(),
                  child: backImage == null
                      ? Icon(Icons.arrow_back_rounded,
                          color: AppColors.textColour80)
                      : Image(image: backImage!, width: 24, height: 24),
                )
              : null,
          actions: actions ?? [],
          bottom: bottom,
        ),
        body: body,
        floatingActionButtonLocation: floatingActionButtonLocation ?? null,
        floatingActionButton: floatingActionButton ?? null,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }

  /// Gunakan `Primary Appbar` untuk membuat AppBar default secara global
  /// agar jenis AppBar utama terpusat dan modular
  /// *boleh di-edit sesuai kebutuhan*
  ///
  static AppBar primaryAppbar({required String titleString}) {
    return AppBar(
      backgroundColor: AppColors.primaryLight,
      title: Text(
        titleString,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// `Secondary Appbar` digunakan apabila membutuhkan jenis AppBar yang berbeda
  /// dari AppBar utama. Misal untuk AppBar Detail
  /// *boleh di-edit sesuai kebutuhan*
  ///
  static AppBar secondaryAppbar({required String titleString}) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: AppColors.colorSecondary,
      title: Text(
        titleString,
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        IconButton(
          splashColor: AppColors.primaryLight,
          icon: const Icon(Icons.edit),
          onPressed: () {},
        ),
      ],
    );
  }

  /// Apabila ada tambahan jenis AppBar, silahkan untuk ditambahkan
  /// sesuai kebutuhan
  ///
}
