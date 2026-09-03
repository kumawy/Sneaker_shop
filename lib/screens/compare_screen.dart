import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/sneaker.dart';
import '../models/sneaker_review.dart';
import '../providers/compare_provider.dart';
import '../providers/firebase_providers.dart';
import '../providers/firebase_status_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/sneaker_image.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final compare = context.watch<CompareProvider>();
    final items = compare.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare'),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () {
                compare.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Comparison cleared')),
                );
              },
              child: const Text('Clear all'),
            ),
        ],
      ),
      body: items.isEmpty ? _buildEmpty(context) : _CompareBody(items: items),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: AppColors.primaryLighter,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.compare_arrows_rounded,
                  color: Colors.white, size: 58),
            ),
            const SizedBox(height: 24),
            const Text(
              'No products to compare',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Open a sneaker and tap Compare.\nYou can compare up to 3 pairs.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGrey, height: 1.5),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              icon: const Icon(Icons.grid_view_rounded),
              label: const Text('Browse Catalog'),
              onPressed: () => context.go('/catalog'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewStats {
  const _ReviewStats({
    required this.average,
    required this.count,
    required this.loading,
  });

  final double average;
  final int count;
  final bool loading;
}

class _CompareBody extends ConsumerWidget {
  const _CompareBody({required this.items});
  final List<Sneaker> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compare = context.read<CompareProvider>();
    final firebaseStatus = context.watch<FirebaseStatusProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkCard : AppColors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.divider;

    final stats = items.map((sneaker) {
      if (!firebaseStatus.ready) {
        return const _ReviewStats(average: 0, count: 0, loading: false);
      }
      final asyncReviews = ref.watch(reviewsProvider(sneaker.id));
      final reviews = asyncReviews.asData?.value ?? const <SneakerReview>[];
      final count = reviews.length;
      final average = count == 0
          ? 0.0
          : reviews.fold<double>(0, (sum, review) => sum + review.rating) /
              count;
      return _ReviewStats(
        average: average,
        count: count,
        loading: asyncReviews.isLoading,
      );
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (items.length < CompareProvider.maxItems)
          _AddMoreBanner(remaining: CompareProvider.maxItems - items.length),
        const SizedBox(height: 12),
        ...List.generate(items.length, (index) {
          final sneaker = items[index];
          final stat = stats[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Dismissible(
              key: ValueKey('compare-${sneaker.id}'),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 22),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.delete_outline,
                    color: Colors.white, size: 30),
              ),
              onDismissed: (_) {
                compare.remove(sneaker.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${sneaker.name} removed')),
                );
              },
              child: _CompareCard(
                sneaker: sneaker,
                stats: stat,
                isBestPrice: _bestPrice(items) == index,
                isBestRating: _bestRating(stats) == index,
                isMostSizes: _mostSizes(items) == index,
              ),
            ),
          );
        }),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
          ),
          child: const Row(
            children: [
              Icon(Icons.swipe_left_rounded, color: AppColors.accent),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Swipe left on any product to remove it from comparison.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  int? _bestPrice(List<Sneaker> items) {
    if (items.length < 2) return null;
    var index = 0;
    for (var i = 1; i < items.length; i++) {
      if (items[i].price < items[index].price) index = i;
    }
    return index;
  }

  int? _bestRating(List<_ReviewStats> stats) {
    if (stats.length < 2 || stats.every((s) => s.count == 0)) return null;
    var index = 0;
    for (var i = 1; i < stats.length; i++) {
      if (stats[i].average > stats[index].average) index = i;
    }
    return index;
  }

  int? _mostSizes(List<Sneaker> items) {
    if (items.length < 2) return null;
    var index = 0;
    for (var i = 1; i < items.length; i++) {
      if (items[i].sizes.length > items[index].sizes.length) index = i;
    }
    return index;
  }
}

class _AddMoreBanner extends StatelessWidget {
  const _AddMoreBanner({required this.remaining});
  final int remaining;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryLighter,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'You can add $remaining more product${remaining == 1 ? '' : 's'} to compare',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.go('/catalog'),
            child: const Text('+ Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _CompareCard extends StatelessWidget {
  const _CompareCard({
    required this.sneaker,
    required this.stats,
    required this.isBestPrice,
    required this.isBestRating,
    required this.isMostSizes,
  });

  final Sneaker sneaker;
  final _ReviewStats stats;
  final bool isBestPrice;
  final bool isBestRating;
  final bool isMostSizes;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkCard : AppColors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.divider;
    final muted = isDark ? AppColors.darkTextGrey : AppColors.textGrey;
    final score = stats.count == 0 ? 0.0 : stats.average / 5;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SneakerImage.fromSneaker(
                sneaker,
                width: 78,
                height: 78,
                borderRadius: 16,
                fallbackFontSize: 36,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sneaker.brand.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      sneaker.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      sneaker.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: muted, fontSize: 12, height: 1.3),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Open product',
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                onPressed: () => context.push('/detail/${sneaker.id}'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: 'Price',
                  value: '\$${sneaker.price.toStringAsFixed(2)}',
                  highlighted: isBestPrice,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricTile(
                  label: 'Rating',
                  value: stats.loading
                      ? 'Loading'
                      : stats.count == 0
                          ? 'No rating'
                          : '${stats.average.toStringAsFixed(1)}/5',
                  highlighted: isBestRating,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricTile(
                  label: 'Sizes',
                  value: '${sneaker.sizes.length}',
                  highlighted: isMostSizes,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: score,
                    minHeight: 8,
                    backgroundColor:
                        isDark ? AppColors.darkBorder : AppColors.divider,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                stats.loading
                    ? 'Loading reviews'
                    : '${stats.count} review${stats.count == 1 ? '' : 's'}',
                style: TextStyle(color: muted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Colors: ${sneaker.colors.join(', ')}',
              style: TextStyle(color: muted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.highlighted,
  });

  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.accent.withValues(alpha: 0.14)
            : (isDark ? AppColors.darkSurface : AppColors.offWhite),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlighted
              ? AppColors.accent
              : (isDark ? AppColors.darkBorder : AppColors.divider),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? AppColors.darkTextGrey : AppColors.textGrey,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: highlighted ? AppColors.accent : null,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
