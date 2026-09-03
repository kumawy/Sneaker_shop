import 'package:flutter/material.dart';

import '../data/sneaker_data.dart';
import '../models/sneaker.dart';
import '../theme/app_theme.dart';
import 'shimmer_box.dart';

class SneakerImage extends StatelessWidget {
  const SneakerImage({
    super.key,
    required this.imageUrl,
    required this.emoji,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.padding = const EdgeInsets.all(6),
    this.borderRadius = 10,
    this.backgroundColor,
    this.fallbackFontSize = 34,
  });

  factory SneakerImage.fromSneaker(
    Sneaker sneaker, {
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    EdgeInsets padding = const EdgeInsets.all(6),
    double borderRadius = 10,
    Color? backgroundColor,
    double fallbackFontSize = 34,
  }) {
    return SneakerImage(
      key: key,
      imageUrl: sneaker.imageUrl,
      emoji: sneaker.emoji,
      width: width,
      height: height,
      fit: fit,
      padding: padding,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      fallbackFontSize: fallbackFontSize,
    );
  }

  factory SneakerImage.fromSneakerId(
    int sneakerId, {
    Key? key,
    String? imageUrl,
    String emoji = '👟',
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    EdgeInsets padding = const EdgeInsets.all(6),
    double borderRadius = 10,
    Color? backgroundColor,
    double fallbackFontSize = 34,
  }) {
    final index = sneakerData.indexWhere((s) => s.id == sneakerId);
    final sneaker = index == -1 ? null : sneakerData[index];

    return SneakerImage(
      key: key,
      imageUrl: imageUrl ?? sneaker?.imageUrl,
      emoji: sneaker?.emoji ?? emoji,
      width: width,
      height: height,
      fit: fit,
      padding: padding,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      fallbackFontSize: fallbackFontSize,
    );
  }

  final String? imageUrl;
  final String emoji;
  final double? width;
  final double? height;
  final BoxFit fit;
  final EdgeInsets padding;
  final double borderRadius;
  final Color? backgroundColor;
  final double fallbackFontSize;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.primaryLighter;
    final url = imageUrl?.trim();

    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: url != null && url.isNotEmpty
          ? Padding(
              padding: padding,
              child: Image.network(
                url,
                fit: fit,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const ShimmerBox();
                },
                errorBuilder: (context, error, stackTrace) =>
                    _Fallback(emoji: emoji, fontSize: fallbackFontSize),
              ),
            )
          : _Fallback(emoji: emoji, fontSize: fallbackFontSize),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.emoji, required this.fontSize});

  final String emoji;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        emoji,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}
