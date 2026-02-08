import 'package:flutter/material.dart';

class AnimatedCount extends StatelessWidget {
  final int count;
  final TextStyle? style;
  final String? suffix;

  const AnimatedCount({
    super.key,
    required this.count,
    this.style,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: count),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Text(
          '$value${suffix ?? ''}',
          style: style,
        );
      },
    );
  }
}
