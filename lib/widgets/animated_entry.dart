import 'package:flutter/material.dart';

class AnimatedEntry extends StatelessWidget {
  const AnimatedEntry({
    super.key,
    required this.child,
    this.index = 0,
    this.slideOffset = 26,
    this.baseDelayMs = 40,
  });

  final Widget child;
  final int index;
  final double slideOffset;
  final int baseDelayMs;

  @override
  Widget build(BuildContext context) {
    final duration = Duration(milliseconds: 280 + (index.clamp(0, 8) * baseDelayMs));
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, slideOffset * (1 - value)),
            child: Transform.scale(
              scale: 0.96 + (0.04 * value),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
