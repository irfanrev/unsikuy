import 'package:flutter/material.dart';
import 'package:unsikuy_app/app/resources/resource.dart';
import 'package:unsikuy_app/app/utils/widgets/sm_app_bar.dart';

class RegisterSuccess extends StatelessWidget {
  const RegisterSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SMAppBar(
        showLeading: false,
        body: Column(
          children: [
            AppImages.imgLoginIlust.image(
              width: 100,
            ),
          ],
        ));
  }
}
