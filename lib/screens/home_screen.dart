import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/sneaker_data.dart';
import '../models/sneaker.dart';
import '../providers/app_settings_provider.dart';
import '../providers/firebase_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_entry.dart';
import '../widgets/animated_press_button.dart';
import '../widgets/sneaker_card.dart';
import '../widgets/sneaker_image.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sneakers = ref.watch(catalogSneakersProvider).asData?.value ?? sneakerData;
    final featured = sneakers.take(5).toList();
    final heroSneaker = sneakers.isNotEmpty ? sneakers.first : null;
    final brandChips =
        ({for (final sneaker in sneakers) sneaker.brand}.toList()..sort())
            .take(18)
            .toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = context.watch<AppSettingsProvider>().strings;

    return Scaffold(
      appBar: AppBar(
        title: const SizedBox.shrink(),
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.go('/catalog'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _HeroSection(
              sneaker: heroSneaker,
              isDark: isDark,
              title: s.heroTitle.replaceAll(' 👟', ''),
              subtitle: s.heroSubtitle,
              buttonText: s.shopNow,
            ),
          ),
          SliverToBoxAdapter(
            child: _StatsStrip(totalSneakers: sneakers.length),
          ),
          SliverToBoxAdapter(
            child: _SectionHeader(
              title: s.featured,
              actionLabel: s.seeAll,
              onAction: () => context.go('/catalog'),
              isDark: isDark,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 236,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: featured.length,
                itemBuilder: (context, index) {
                  final sneaker = featured[index];
                  return AnimatedEntry(
                    index: index,
                    child: AnimatedPressButton(
                      onTap: () => context.pushNamed(
                        'detail',
                        pathParameters: {'id': '${sneaker.id}'},
                        queryParameters: {'ref': 'home-featured'},
                      ),
                      child: Container(
                        width: 164,
                        margin: const EdgeInsets.only(right: 12, bottom: 2),
                        child: SneakerCard(
                          sneaker: sneaker,
                          heroPrefix: 'home-featured',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionHeader(title: s.brands, isDark: isDark),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: brandChips.map((brand) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () => context
                        .go('/catalog?brand=${Uri.encodeComponent(brand)}'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.divider,
                        ),
                        color: isDark ? AppColors.darkCard : AppColors.white,
                      ),
                      child: Text(
                        brand.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? AppColors.darkText : AppColors.textDark,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionHeader(title: s.allSneakers, isDark: isDark),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final sneaker = sneakers[index];
                  return AnimatedEntry(
                    index: index,
                    child: AnimatedPressButton(
                      onTap: () => context.pushNamed(
                        'detail',
                        pathParameters: {'id': '${sneaker.id}'},
                        queryParameters: {'ref': 'home-grid'},
                      ),
                      child: SneakerCard(
                        sneaker: sneaker,
                        heroPrefix: 'home-grid',
                      ),
                    ),
                  );
                },
                childCount: sneakers.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.sneaker,
    required this.isDark,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });

  final Sneaker? sneaker;
  final bool isDark;
  final String title;
  final String subtitle;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkSurface : AppColors.primary;
    final card = isDark ? AppColors.darkCard : const Color(0xFF242447);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.primaryLighter,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.16),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'NEW DROP',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.8,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                AnimatedPressButton(
                  onTap: () => context.go('/catalog'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.28),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          buttonText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded,
                            size: 18, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.09),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -22,
                      top: -22,
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accent.withValues(alpha: 0.18),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -18,
                      bottom: -18,
                      child: Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.pixelCyan.withValues(alpha: 0.12),
                        ),
                      ),
                    ),
                    Center(
                      child: sneaker == null
                          ? const Icon(Icons.directions_run,
                              color: Colors.white, size: 84)
                          : Transform.rotate(
                              angle: -0.16,
                              child: SneakerImage.fromSneaker(
                                sneaker!,
                                width: 150,
                                height: 150,
                                backgroundColor: Colors.transparent,
                                borderRadius: 18,
                                padding: const EdgeInsets.all(4),
                                fallbackFontSize: 82,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({required this.totalSneakers});
  final int totalSneakers;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkCard : AppColors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.divider;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(value: '$totalSneakers+', label: 'Sneakers'),
          const _VerticalDivider(),
          const _StatItem(value: '55+', label: 'Brands'),
          const _VerticalDivider(),
          const _StatItem(value: '3-5★', label: 'Reviews'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 17,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkTextGrey
                : AppColors.textGrey,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkBorder
          : AppColors.divider,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.isDark,
    this.actionLabel,
    this.onAction,
  });
  final String title;
  final bool isDark;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 22, 12, 10),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(99),
            ),
            margin: const EdgeInsets.only(right: 9),
          ),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.textDark,
              letterSpacing: 1.8,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const Spacer(),
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
