import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/database/sneaker_db.dart';
import '../data/sneaker_data.dart';
import '../models/favourite_item.dart';
import '../models/sneaker_review.dart';
import '../models/sneaker.dart';
import '../providers/cart_provider.dart';
import '../providers/compare_provider.dart';
import '../providers/db_providers.dart';
import '../providers/favourite_providers.dart';
import '../providers/firebase_providers.dart';
import '../providers/firebase_status_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_favourite_icon.dart';
import '../widgets/animated_press_button.dart';
import '../widgets/sneaker_image.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final int sneakerId;
  final String? refSource;
  final String? promoCode;

  const DetailScreen({
    super.key,
    required this.sneakerId,
    this.refSource,
    this.promoCode,
  });

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  String? _selectedSize;
  String? _selectedColor;

  Sneaker get sneaker {
    final catalog = ref.read(catalogSneakersProvider).asData?.value ?? sneakerData;
    return catalog.firstWhere(
      (s) => s.id == widget.sneakerId,
      orElse: () => Sneaker(
        id: widget.sneakerId,
        name: 'Sneaker ${widget.sneakerId}',
        brand: 'Custom',
        price: 0,
        description: 'This sneaker is loading or was removed.',
        sizes: const ['40'],
        colors: const ['White'],
        emoji: '👟',
        imageUrl: null,
        rating: 0,
        reviews: 0,
      ),
    );
  }

  String? get _heroPrefix {
    const animatedSources = {
      'catalog',
      'home-featured',
      'home-grid',
      'recommendation',
    };
    return animatedSources.contains(widget.refSource) ? widget.refSource : null;
  }

  Future<void> _addToWishlist() async {
    final db = ref.read(sneakerDatabaseProvider);
    final exists = await db.wishlistDao.contains(sneaker.id);
    if (exists) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${sneaker.name} is already in Wishlist')),
      );
      return;
    }

    await db.wishlistDao.insert(
      DbWishlistItemCompanion.insert(
        sneakerId: sneaker.id,
        name: sneaker.name,
        brand: sneaker.brand,
        price: sneaker.price,
        emoji: sneaker.emoji,
        savedAt: DateTime.now(),
      ),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${sneaker.name} saved locally in SQLite'),
        action: SnackBarAction(
          label: 'Wishlist',
          onPressed: () => context.go('/wishlist'),
        ),
      ),
    );
  }

  Future<void> _toggleCloudFavourite() async {
    final firebaseStatus = context.read<FirebaseStatusProvider>();
    if (!firebaseStatus.ready) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Firebase not configured yet.')),
      );
      return;
    }

    final userDao = ref.read(userDaoProvider);
    if (!userDao.isLoggedIn()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Sign in to save cloud favourites'),
          action: SnackBarAction(
            label: 'Sign In',
            onPressed: () => context.go('/profile'),
          ),
        ),
      );
      return;
    }

    try {
      final item = FavouriteItem(
        sneakerId: sneaker.id,
        name: sneaker.name,
        brand: sneaker.brand,
        price: sneaker.price,
        emoji: sneaker.emoji,
        imageUrl: sneaker.imageUrl,
        savedAt: DateTime.now(),
      );

      final added = await ref.read(favouriteDaoProvider).toggleFavourite(item);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              added
                  ? '❤️ ${sneaker.name} added to Cloud Favourites'
                  : '🤍 ${sneaker.name} removed from Cloud Favourites',
            ),
            action: added
                ? SnackBarAction(
                    label: 'View',
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      context.goNamed('favourites');
                    },
                  )
                : null,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addToCart() {
    if (_selectedSize == null || _selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select size and color first')),
      );
      return;
    }

    context.read<CartProvider>().addItem(
          sneaker,
          _selectedSize!,
          _selectedColor!,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${sneaker.name} added to cart'),
        action: SnackBarAction(
          label: 'Cart',
          onPressed: () => context.go('/cart'),
        ),
      ),
    );
  }


  void _openCompare() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    context.go('/compare');
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/catalog');
    }
  }

  void _toggleCompare({bool openAfterAdd = false}) {
    final compare = context.read<CompareProvider>();
    final wasAdded = compare.isAdded(sneaker.id);
    final error = compare.toggle(sneaker);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          action: SnackBarAction(
            label: 'View Compare',
            onPressed: _openCompare,
          ),
        ),
      );
      return;
    }

    if (openAfterAdd && !wasAdded) {
      _openCompare();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasAdded
              ? '${sneaker.name} removed from Compare'
              : '${sneaker.name} added to Compare',
        ),
        action: SnackBarAction(
          label: 'View Compare',
          onPressed: _openCompare,
        ),
      ),
    );
  }

  void _copyDeepLink() {
    final link = '/detail/${sneaker.id}?ref=share';
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deep link copied: $link')),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedSize = sneaker.sizes.isNotEmpty ? sneaker.sizes.first : null;
    _selectedColor = sneaker.colors.isNotEmpty ? sneaker.colors.first : null;
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(catalogSneakersProvider).asData?.value ?? sneakerData;
    final currentSneaker = catalog.firstWhere(
      (s) => s.id == widget.sneakerId,
      orElse: () => Sneaker(
        id: widget.sneakerId,
        name: 'Sneaker ${widget.sneakerId}',
        brand: 'Custom',
        price: 0,
        description: 'This sneaker is loading or was removed.',
        sizes: const ['40'],
        colors: const ['White'],
        emoji: '👟',
        imageUrl: null,
        rating: 0,
        reviews: 0,
      ),
    );
    final sneaker = currentSneaker;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final priceColor = isDark ? AppColors.accent : AppColors.primary;
    final firebaseStatus = context.watch<FirebaseStatusProvider>();
    final compare = context.watch<CompareProvider>();
    final isCompared = compare.isAdded(sneaker.id);
    final userDao = ref.watch(userDaoProvider);

    final isFavAsync = (firebaseStatus.ready && userDao.isLoggedIn())
        ? ref.watch(isFavouriteProvider(sneaker.id))
        : const AsyncData<bool>(false);

    final isFav = isFavAsync.asData?.value ?? false;
    final reviewsAsync = firebaseStatus.ready
        ? ref.watch(reviewsProvider(sneaker.id))
        : const AsyncData<List<SneakerReview>>([]);
    final reviews = reviewsAsync.asData?.value ?? const <SneakerReview>[];
    final reviewCount = reviews.length;
    final averageRating = reviewCount == 0
        ? 0.0
        : reviews.fold<double>(0, (sum, review) => sum + review.rating) /
            reviewCount;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _goBack,
        ),
        title: Text(sneaker.name),
        actions: [
          IconButton(
            tooltip: isCompared ? 'Remove from Compare' : 'Add to Compare',
            icon: Icon(
              isCompared
                  ? Icons.compare_arrows_rounded
                  : Icons.compare_arrows_outlined,
            ),
            onPressed: () => _toggleCompare(),
          ),
          IconButton(
            tooltip: isFav
                ? 'Remove from Cloud Favourites'
                : 'Add to Cloud Favourites',
            icon: AnimatedFavouriteIcon(isFavourite: isFav),
            onPressed: _toggleCloudFavourite,
          ),
          IconButton(
            tooltip: 'Copy deep link',
            icon: const Icon(Icons.link),
            onPressed: _copyDeepLink,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.divider,
              ),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\$${sneaker.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: priceColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedPressButton(
                  onTap: _addToCart,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.24),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          HeroMode(
            enabled: _heroPrefix != null,
            child: Hero(
              tag: 'sneaker-photo-$_heroPrefix-${sneaker.id}',
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.offWhite,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: SneakerImage.fromSneaker(
                  sneaker,
                  width: double.infinity,
                  height: 280,
                  borderRadius: 18,
                  padding: const EdgeInsets.all(12),
                  backgroundColor:
                      isDark ? AppColors.darkSurface : AppColors.offWhite,
                  fallbackFontSize: 96,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            sneaker.brand,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sneaker.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      reviewsAsync.isLoading
                          ? '...'
                          : reviewCount == 0
                              ? 'No reviews'
                              : '${averageRating.toStringAsFixed(1)} · $reviewCount reviews',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '\$${sneaker.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: priceColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(sneaker.description),
          const SizedBox(height: 20),
          const Text('Size', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: sneaker.sizes.map((size) {
              return ChoiceChip(
                label: Text(size),
                selected: _selectedSize == size,
                onSelected: (_) => setState(() => _selectedSize = size),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: sneaker.colors.map((color) {
              return ChoiceChip(
                label: Text(color),
                selected: _selectedColor == color,
                onSelected: (_) => setState(() => _selectedColor = color),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isFav ? Colors.red.shade50 : null,
                foregroundColor: isFav ? Colors.red : null,
              ),
              onPressed: _toggleCloudFavourite,
              icon: AnimatedFavouriteIcon(isFavourite: isFav),
              label: Text(
                isFav
                    ? 'Remove from Cloud Favourites'
                    : 'Save to Cloud Favourites',
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addToWishlist,
              icon: const Icon(Icons.bookmark_border),
              label: const Text('Local Wishlist'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _toggleCompare(openAfterAdd: true),
              icon: Icon(
                isCompared
                    ? Icons.compare_arrows_rounded
                    : Icons.compare_arrows_outlined,
              ),
              label: Text(isCompared ? 'Remove from Compare' : 'Compare'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonalIcon(
              onPressed: () => context.push(
                '/reviews/${sneaker.id}?name=${Uri.encodeComponent(sneaker.name)}',
              ),
              icon: const Icon(Icons.reviews_outlined),
              label: const Text('Reviews'),
            ),
          ),
          const SizedBox(height: 24),
          _RecommendationSection(current: sneaker),
        ],
      ),
    );
  }
}

class _RecommendationSection extends StatelessWidget {
  const _RecommendationSection({required this.current});
  final Sneaker current;

  @override
  Widget build(BuildContext context) {
    final items = sneakerData.where((s) => s.id != current.id).take(4).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.cardBg;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.divider;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'You might also like',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 135,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                onTap: () =>
                    context.push('/detail/${item.id}?ref=recommendation'),
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Hero(
                          tag: 'sneaker-photo-recommendation-${item.id}',
                          child: SneakerImage.fromSneaker(
                            item,
                            width: 118,
                            height: 58,
                            borderRadius: 8,
                            backgroundColor: isDark
                                ? AppColors.darkSurface
                                : AppColors.white,
                            fallbackFontSize: 42,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ],
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
