import 'package:flutter/material.dart';
import 'package:unsikuy_app/app/resources/resource.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: AppColors.primaryLight,
        ),
      ),
    );
  }
}
