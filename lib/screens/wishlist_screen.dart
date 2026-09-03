// Uses a StreamBuilder to reactively display wishlist items from the DB.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/database/sneaker_db.dart';
import '../providers/db_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/sneaker_image.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(sneakerDatabaseProvider);
    final fmt = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear all',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Clear wishlist?'),
                  content: const Text(
                      'All saved sneakers will be removed from the local database.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Clear')),
                  ],
                ),
              );
              if (confirm == true) {
                await db.wishlistDao.clearAll();
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<DbWishlistItemData>>(
        stream: db.wishlistDao.watchAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🗄️', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Long-press any sneaker card to save it here.\nData persists in SQLite — even after the app restarts!',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              return Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.red.shade400,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) async {
                  await db.wishlistDao.removeBySneakerId(item.sneakerId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item.name} removed from wishlist'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: ListTile(
                  leading: SneakerImage.fromSneakerId(
                    item.sneakerId,
                    emoji: item.emoji,
                    width: 48,
                    height: 48,
                    borderRadius: 24,
                    fallbackFontSize: 22,
                  ),
                  title: Text(item.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    '${item.brand} · Saved ${DateFormat.yMd().format(item.savedAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: Text(
                    fmt.format(item.price),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
