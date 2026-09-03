import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/favourite_item.dart';
import '../providers/favourite_providers.dart';
import '../providers/firebase_providers.dart';
import '../providers/firebase_status_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/shimmer_box.dart';
import '../widgets/sneaker_image.dart';

class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseStatus = context.watch<FirebaseStatusProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.accent : AppColors.primary;

    if (!firebaseStatus.ready) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cloud Favourites ☁️')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_off, size: 56, color: accentColor),
                const SizedBox(height: 16),
                const Text(
                  'Firebase is not configured',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Cloud favourites are unavailable right now.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => context.go('/profile'),
                  icon: const Icon(Icons.person_outline),
                  label: const Text('Go to Profile'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final userDao = ref.watch(userDaoProvider);
    final authState = ref.watch(authStateProvider);
    final isLoggedIn = authState.maybeWhen(
      data: (user) => user != null,
      orElse: () => userDao.isLoggedIn(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Favourites ☁️'),
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Log out',
              onPressed: () => userDao.logout(),
            ),
        ],
      ),
      body: isLoggedIn ? const _FavouritesList() : const _LoginPrompt(),
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('☁️', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'Sign in to sync favourites',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Your favourites will be saved to the cloud and synced across all your devices.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go('/profile'),
              icon: const Icon(Icons.login),
              label: const Text('Sign In / Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavouritesList extends ConsumerWidget {
  const _FavouritesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favAsync = ref.watch(favouritesStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.accent : AppColors.primary;
    final syncBgColor = isDark ? AppColors.darkCard : AppColors.primaryLighter;

    return favAsync.when(
      loading: () => const _FavouritesSkeleton(),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Error loading favourites: $error',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      data: (List<FavouriteItem> items) {
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🤍', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                const Text(
                  'No cloud favourites yet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap ❤️ on any sneaker detail page\nto save it to the cloud.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => context.go('/catalog'),
                  icon: const Icon(Icons.grid_view),
                  label: const Text('Browse Catalog'),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: syncBgColor,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.cloud_done, color: accentColor, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${items.length} item${items.length == 1 ? '' : 's'} synced to cloud',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _FavouriteCard(item: item);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FavouritesSkeleton extends StatelessWidget {
  const _FavouritesSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                ShimmerBox(width: 64, height: 64, borderRadius: 10),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(height: 16, borderRadius: 8),
                      SizedBox(height: 8),
                      ShimmerBox(width: 120, height: 12, borderRadius: 6),
                      SizedBox(height: 8),
                      ShimmerBox(width: 84, height: 12, borderRadius: 6),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FavouriteCard extends ConsumerWidget {
  const _FavouriteCard({required this.item});

  final FavouriteItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFmt = DateFormat('MMM d, y');
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMuted = isDark ? AppColors.darkTextGrey : AppColors.textGrey;
    final priceColor = isDark ? AppColors.accent : AppColors.primary;

    Future<void> removeFavourite() async {
      try {
        await ref.read(favouriteDaoProvider).removeFavourite(item.sneakerId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${item.name} removed from favourites')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    return Dismissible(
      key: ValueKey('cloud-favourite-${item.sneakerId}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => removeFavourite(),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.push('/detail/${item.sneakerId}'),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SneakerImage.fromSneakerId(
                  item.sneakerId,
                  imageUrl: item.imageUrl,
                  emoji: item.emoji,
                  width: 64,
                  height: 64,
                  fallbackFontSize: 34,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.brand,
                        style: TextStyle(color: textMuted, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: priceColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Saved ${dateFmt.format(item.savedAt)}',
                        style: TextStyle(fontSize: 11, color: textMuted),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  tooltip: 'Remove from favourites',
                  onPressed: removeFavourite,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
