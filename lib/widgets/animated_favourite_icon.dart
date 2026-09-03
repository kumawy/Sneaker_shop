import 'package:flutter/material.dart';

class AnimatedFavouriteIcon extends StatelessWidget {
  const AnimatedFavouriteIcon({
    super.key,
    required this.isFavourite,
    this.size,
  });

  final bool isFavourite;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final inactiveColor = IconTheme.of(context).color ?? Colors.grey;

    return TweenAnimationBuilder<double>(
      key: ValueKey(isFavourite),
      tween: Tween(begin: 0.72, end: 1),
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: TweenAnimationBuilder<Color?>(
            tween: ColorTween(
              begin: isFavourite ? inactiveColor : Colors.red,
              end: isFavourite ? Colors.red : inactiveColor,
            ),
            duration: const Duration(milliseconds: 180),
            builder: (context, color, _) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  isFavourite ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(isFavourite),
                  color: color,
                  size: size,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
