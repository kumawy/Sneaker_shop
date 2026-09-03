import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/bookmark_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/sneaker_image.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarks = context.watch<BookmarkProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        actions: [
          if (bookmarks.count > 0)
            TextButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear Bookmarks'),
                    content: const Text(
                        'Remove all bookmarks?\nThis will also delete them from SharedPreferences.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text('Clear all'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await bookmarks.clearAll();
                }
              },
              child: const Text('Clear'),
            ),
        ],
      ),
      body: bookmarks.count == 0
          ? _buildEmpty(context)
          : _buildList(context, bookmarks),
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
              child: const Center(
                child: Text('🔖', style: TextStyle(fontSize: 52)),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No bookmarks yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the bookmark icon on any\nproduct to save it here.\n\nBookmarks are saved with\nSharedPreferences ().',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGrey, height: 1.6),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.grid_view),
              label: const Text('Browse Catalog'),
              onPressed: () => context.go('/catalog'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, BookmarkProvider bookmarks) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.accent : AppColors.primary;
    final infoBgColor = isDark ? AppColors.darkCard : AppColors.primaryLighter;
    final mutedColor = isDark ? AppColors.darkTextGrey : AppColors.textGrey;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: infoBgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.save, size: 14, color: accentColor),
                  const SizedBox(width: 6),
                  Text(
                    '${bookmarks.count} sneaker${bookmarks.count == 1 ? '' : 's'} saved',
                    style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Stored in SharedPreferences • Serialized as JSON',
                style: TextStyle(fontSize: 11, color: mutedColor),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: bookmarks.bookmarks.length,
            itemBuilder: (context, index) {
              final sneaker = bookmarks.bookmarks[index];

              return Dismissible(
                key: Key('bookmark-${sneaker.id}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete, color: Colors.red, size: 28),
                ),
                onDismissed: (_) async {
                  await bookmarks.remove(sneaker.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${sneaker.name} removed from bookmarks'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  }
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: SneakerImage.fromSneaker(
                      sneaker,
                      width: 56,
                      height: 56,
                      fallbackFontSize: 28,
                    ),
                    title: Text(
                      sneaker.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sneaker.brand,
                            style: TextStyle(color: accentColor, fontSize: 12)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 12, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text('${sneaker.rating}',
                                style: const TextStyle(
                                    fontSize: 11, color: AppColors.textGrey)),
                          ],
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${sneaker.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ).copyWith(color: accentColor),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => context.push('/detail/${sneaker.id}'),
                          child: Text(
                            'View →',
                            style: TextStyle(color: accentColor, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
