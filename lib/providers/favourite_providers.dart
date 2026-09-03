import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/favourite_dao.dart';
import '../models/favourite_item.dart';
import 'firebase_providers.dart';

/// Provides FavouriteDao (depends on UserDao for auth).
final favouriteDaoProvider = Provider<FavouriteDao>((ref) {
  // Watch auth state so favourites streams refresh immediately after
  // login/logout even though userDaoProvider itself is a plain Provider.
  ref.watch(authStateProvider);

  final userDao = ref.watch(userDaoProvider);
  return FavouriteDao(userDao);
});

/// Live stream of all favourites for the current user.
final favouritesStreamProvider = StreamProvider<List<FavouriteItem>>((ref) {
  final dao = ref.watch(favouriteDaoProvider);
  return dao.getFavouritesStream();
});

/// Stream that emits true/false whether a given sneakerId is favourited.
final isFavouriteProvider = StreamProvider.family<bool, int>((ref, sneakerId) {
  final dao = ref.watch(favouriteDaoProvider);
  return dao.isFavouriteStream(sneakerId);
});
