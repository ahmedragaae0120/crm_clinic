import 'package:flutter/material.dart';

class ScreenTitleAnimation extends StatelessWidget {
  final String title;
  const ScreenTitleAnimation({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(opacity: value, child: child);
      },
      child: Text(title, style: theme.textTheme.headlineLarge),
    );
  }
}
