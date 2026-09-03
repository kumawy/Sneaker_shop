import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/sneaker_review.dart';
import 'user_dao.dart';
import 'admin_product_dao.dart';

class ReviewDao {
  ReviewDao(this.userDao);

  final UserDao userDao;

  CollectionReference _collection(int sneakerId) {
    return FirebaseFirestore.instance
        .collection('reviews')
        .doc('$sneakerId')
        .collection('items');
  }

  Future<void> postReview({
    required int sneakerId,
    required String text,
    required double rating,
  }) async {
    final currentUserId = userDao.userId();
    final currentEmail = userDao.email();

    if (currentUserId == null) {
      throw Exception('Please log in before posting a review.');
    }

    final now = DateTime.now();

    final review = SneakerReview(
      sneakerId: sneakerId,
      email: currentEmail ?? 'anonymous',
      text: text,
      rating: rating,
      date: now,
      userId: currentUserId,
    );

    final data = review.toJson()
      ..addAll({
        'userEmail': currentEmail ?? 'anonymous',
        'comment': text,
        'createdAt': Timestamp.fromDate(now),
      });

    await _collection(sneakerId).add(data);
  }

  Stream<List<SneakerReview>> getReviewStream(int sneakerId) {
    return _collection(sneakerId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SneakerReview.fromSnapshot(doc))
              .toList(),
        );
  }

  Stream<double> getAverageRating(int sneakerId) {
    return getReviewStream(sneakerId).map((reviews) {
      if (reviews.isEmpty) return 0.0;

      final sum = reviews.fold<double>(
        0,
        (acc, review) => acc + review.rating,
      );

      return sum / reviews.length;
    });
  }

  Future<void> deleteReview(SneakerReview review) async {
    final currentUserId = userDao.userId();

    if (currentUserId == null) {
      throw Exception('Please log in before deleting a review.');
    }

    final admin = isAdminEmail(userDao.email());
    if (!admin && currentUserId != review.userId) {
      throw Exception('You can delete only your own review.');
    }

    if (review.reference == null) {
      throw Exception('Review document reference not found.');
    }

    await review.reference!.delete();
  }
}
