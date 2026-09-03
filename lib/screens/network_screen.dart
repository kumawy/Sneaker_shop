import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as pv;
import '../models/sneaker.dart';
import '../network/api_product.dart';
import '../providers/riverpod_providers.dart';
import '../providers/stream_cart_provider.dart';
import '../theme/app_theme.dart';

Sneaker apiProductToSneaker(ApiProduct p) {
  return Sneaker(
    id: p.id + 10000,
    name: p.title.length > 40 ? '${p.title.substring(0, 40)}…' : p.title,
    brand: p.displayCategory,
    price: p.price,
    description: p.description,
    sizes: const ['S', 'M', 'L', 'XL'],
    colors: const ['Default'],
    emoji: '🛍️',
    rating: p.rating.rate,
    reviews: p.rating.count,
  );
}

class NetworkScreen extends ConsumerStatefulWidget {
  const NetworkScreen({super.key});

  @override
  ConsumerState<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends ConsumerState<NetworkScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = ref.watch(filteredProductsProvider);
    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final notifierState = ref.watch(productsNotifierProvider);

    final streamCart =
        pv.Provider.of<StreamCartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Products'),
        actions: [
          StreamBuilder<CartState>(
            stream: streamCart.cartStream,
            initialData: CartState(items: streamCart.items),
            builder: (context, snapshot) {
              final count = snapshot.data?.itemCount ?? 0;
              return Stack(children: [
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.shopping_cart_outlined),
                ),
                if (count > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      child: Text('$count',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10)),
                    ),
                  ),
              ]);
            },
          ),
          if (notifierState.isRefreshing)
            const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2)))
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () =>
                  ref.read(productsNotifierProvider.notifier).refresh(),
            ),
        ],
      ),
      body: Column(children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: AppColors.primaryLighter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(children: [
                Icon(Icons.wifi, size: 14, color: AppColors.primary),
                SizedBox(width: 6),
                Text('Live data · fakestoreapi.com',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ]),
              const SizedBox(height: 2),
              if (notifierState.lastRefreshed != null)
                Text(
                  'Refreshed: ${_fmt(notifierState.lastRefreshed!)}',
                  style:
                      const TextStyle(fontSize: 10, color: AppColors.textGrey),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search…',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(networkSearchProvider.notifier).set('');
                      })
                  : null,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (v) => ref.read(networkSearchProvider.notifier).set(v),
          ),
        ),
        categories.when(
          loading: () => const SizedBox(height: 44),
          error: (_, __) => const SizedBox(height: 44),
          data: (cats) => SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: cats.length,
              itemBuilder: (_, i) {
                final cat = cats[i];
                final sel = selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat == 'all' ? 'All' : _cap(cat),
                        style: TextStyle(
                            fontSize: 12,
                            color: sel ? AppColors.white : AppColors.primary)),
                    selected: sel,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.primaryLighter,
                    onSelected: (_) =>
                        ref.read(selectedCategoryProvider.notifier).set(cat),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: filteredProducts.when(
            loading: () => const Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Loading products…',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textGrey)),
                ])),
            error: (e, _) => _buildError(e.toString()),
            data: (products) => products.isEmpty
                ? _buildEmpty()
                : _buildGrid(products, streamCart),
          ),
        ),
      ]),
    );
  }

  Widget _buildGrid(List<ApiProduct> products, StreamCartProvider streamCart) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) =>
          _ProductCard(product: products[i], streamCart: streamCart),
    );
  }

  Widget _buildError(String msg) => Center(
          child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.wifi_off, size: 64, color: AppColors.textGrey),
          const SizedBox(height: 16),
          const Text('Network Error',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(msg,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            onPressed: () =>
                ref.read(productsNotifierProvider.notifier).refresh(),
          ),
        ]),
      ));

  Widget _buildEmpty() => const Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('📦', style: TextStyle(fontSize: 56)),
          SizedBox(height: 12),
          Text('No products found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ));

  String _cap(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

class _ProductCard extends StatelessWidget {
  final ApiProduct product;
  final StreamCartProvider streamCart;
  const _ProductCard({required this.product, required this.streamCart});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                width: double.infinity,
                errorBuilder: (_, __, ___) => const Center(
                    child: Text('🛍️', style: TextStyle(fontSize: 36))),
                loadingBuilder: (_, child, p) => p == null
                    ? child
                    : const Center(
                        child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(product.displayCategory,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textGrey)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.formattedPrice,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 13)),
                    Row(children: [
                      const Icon(Icons.star, size: 11, color: Colors.amber),
                      Text(product.rating.rate.toStringAsFixed(1),
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.textGrey)),
                    ]),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  height: 28,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        textStyle: const TextStyle(fontSize: 11)),
                    onPressed: () {
                      streamCart.addItem(
                          apiProductToSneaker(product), 'M', 'Default');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added via Stream'),
                          duration: Duration(seconds: 1),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    child: const Text('Add to cart'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
