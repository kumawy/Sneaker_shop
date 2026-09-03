import 'package:flutter/material.dart';
import '../models/sneaker.dart';
import '../theme/app_theme.dart';
import 'sneaker_image.dart';

class SneakerCard extends StatelessWidget {
  final Sneaker sneaker;
  final String heroPrefix;
  const SneakerCard({
    super.key,
    required this.sneaker,
    this.heroPrefix = 'catalog',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.textDark;
    final bgCard = isDark ? AppColors.darkCard : AppColors.cardBg;
    return Container(
      decoration: BoxDecoration(
        color: bgCard,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 110,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.offWhite,
              border: Border(
                bottom: BorderSide(color: borderColor, width: 2),
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'sneaker-photo-$heroPrefix-${sneaker.id}',
                  child: SneakerImage.fromSneaker(
                    sneaker,
                    width: double.infinity,
                    height: 110,
                    borderRadius: 0,
                    backgroundColor:
                        isDark ? AppColors.darkSurface : AppColors.offWhite,
                    fallbackFontSize: 48,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      border: Border.all(color: AppColors.accent, width: 1),
                    ),
                    child: Text(
                      sneaker.brand.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sneaker.name,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          '\$${sneaker.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.pixelYellow.withValues(alpha: 0.2),
                          border: Border.all(
                              color: AppColors.pixelYellow, width: 1),
                        ),
                        child: Text(
                          '★${sneaker.rating}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.pixelYellow,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
