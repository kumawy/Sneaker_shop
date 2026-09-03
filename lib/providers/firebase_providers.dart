import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_dao.dart';
import '../models/review_dao.dart';
import '../models/sneaker_review.dart';
import '../models/sneaker.dart';
import '../models/admin_product_dao.dart';

final userDaoProvider = Provider<UserDao>((ref) {
  final dao = UserDao();
  ref.onDispose(dao.dispose);
  return dao;
});

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final reviewDaoProvider = Provider<ReviewDao>((ref) {
  final userDao = ref.watch(userDaoProvider);
  return ReviewDao(userDao);
});

final reviewsProvider =
    StreamProvider.family<List<SneakerReview>, int>((ref, sneakerId) {
  final dao = ref.watch(reviewDaoProvider);
  return dao.getReviewStream(sneakerId);
});
final avgRatingProvider = StreamProvider.family<double, int>((ref, sneakerId) {
  final dao = ref.watch(reviewDaoProvider);
  return dao.getAverageRating(sneakerId);
});


final adminProductDaoProvider = Provider<AdminProductDao>((ref) {
  return AdminProductDao();
});

final catalogSneakersProvider = StreamProvider<List<Sneaker>>((ref) {
  final dao = ref.watch(adminProductDaoProvider);
  return dao.watchProducts();
});
