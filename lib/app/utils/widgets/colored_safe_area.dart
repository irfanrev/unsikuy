import 'package:flutter/material.dart';

class ColoredSafeArea extends StatelessWidget {
  final Widget child;
  final Color color;

  const ColoredSafeArea({required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color, //Theme.of(context).colorScheme.primaryVariant
      child: SafeArea(
        child: child,
      ),
    );
  }
}
