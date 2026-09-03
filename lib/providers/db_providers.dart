// Exposes the SneakerDatabase singleton and derived wishlist/order streams.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/sneaker_db.dart';

/// Singleton Drift database instance.
/// Created once and kept alive for the app's lifetime.
final sneakerDatabaseProvider = Provider<SneakerDatabase>((ref) {
  final db = SneakerDatabase();
  // Close the database when the provider is disposed.
  ref.onDispose(db.close);
  return db;
});

final wishlistStreamProvider = StreamProvider<List<DbWishlistItemData>>((ref) {
  final db = ref.watch(sneakerDatabaseProvider);
  return db.wishlistDao.watchAll();
});

/// Number of items currently on the wishlist (for badges, etc.).
final wishlistCountProvider = Provider<int>((ref) {
  final async = ref.watch(wishlistStreamProvider);
  return async.maybeWhen(data: (list) => list.length, orElse: () => 0);
});

final ordersStreamProvider = StreamProvider<List<DbOrderData>>((ref) {
  final db = ref.watch(sneakerDatabaseProvider);
  return db.orderDao.watchAll();
});
