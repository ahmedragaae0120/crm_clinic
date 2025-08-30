import 'package:flutter/material.dart';

class ListItemAnimation extends StatelessWidget {
  final Widget child;
  final int index;
  const ListItemAnimation({
    super.key,
    required this.child,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20), // يتحرك من تحت لفوق
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
