//
// `flutter_riverpod` are in the same project. Replaced with NotifierProvider
// which is the modern Riverpod 2.x equivalent and has no name conflicts.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/sneaker_api_service.dart';
import '../network/api_product.dart';

final apiServiceProvider = Provider<SneakerApiService>((ref) {
  return SneakerApiService();
});

final productsProvider = FutureProvider<List<ApiProduct>>((ref) async {
  final service = ref.read(apiServiceProvider);
  final response = await service.fetchProducts(limit: 20);
  if (response.isSuccess) return response.data!;
  throw Exception(response.errorMessage ?? 'Failed to load products');
});

final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final service = ref.read(apiServiceProvider);
  final response = await service.fetchCategories();
  if (response.isSuccess) return ['all', ...response.data!];
  throw Exception(response.errorMessage);
});

// Replaced StateProvider with NotifierProvider (Riverpod 2.x, no name conflict)
class _StringNotifier extends Notifier<String> {
  final String _initial;
  _StringNotifier(this._initial);
  @override
  String build() => _initial;
  void set(String value) => state = value;
}

final selectedCategoryProvider =
    NotifierProvider<_StringNotifier, String>(() => _StringNotifier('all'));

final networkSearchProvider =
    NotifierProvider<_StringNotifier, String>(() => _StringNotifier(''));

final filteredProductsProvider = Provider<AsyncValue<List<ApiProduct>>>((ref) {
  final products = ref.watch(productsProvider);
  final category = ref.watch(selectedCategoryProvider);
  final search = ref.watch(networkSearchProvider).toLowerCase();

  return products.when(
    loading: () => const AsyncValue.loading(),
    error: (e, s) => AsyncValue.error(e, s),
    data: (list) {
      var filtered = list;
      if (category != 'all') {
        filtered = filtered.where((p) => p.category == category).toList();
      }
      if (search.isNotEmpty) {
        filtered = filtered
            .where((p) =>
                p.title.toLowerCase().contains(search) ||
                p.category.toLowerCase().contains(search))
            .toList();
      }
      return AsyncValue.data(filtered);
    },
  );
});

class ProductsNotifier extends Notifier<ProductsState> {
  @override
  ProductsState build() => const ProductsState();

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true);
    ref.invalidate(productsProvider);
    await ref.read(productsProvider.future);
    state = state.copyWith(isRefreshing: false, lastRefreshed: DateTime.now());
  }

  void setProductDetail(ApiProduct? product) {
    state = state.copyWith(selectedProduct: product);
  }
}

final productsNotifierProvider =
    NotifierProvider<ProductsNotifier, ProductsState>(ProductsNotifier.new);

class ProductsState {
  final bool isRefreshing;
  final DateTime? lastRefreshed;
  final ApiProduct? selectedProduct;

  const ProductsState({
    this.isRefreshing = false,
    this.lastRefreshed,
    this.selectedProduct,
  });

  ProductsState copyWith({
    bool? isRefreshing,
    DateTime? lastRefreshed,
    ApiProduct? selectedProduct,
  }) {
    return ProductsState(
      isRefreshing: isRefreshing ?? this.isRefreshing,
      lastRefreshed: lastRefreshed ?? this.lastRefreshed,
      selectedProduct: selectedProduct ?? this.selectedProduct,
    );
  }
}
