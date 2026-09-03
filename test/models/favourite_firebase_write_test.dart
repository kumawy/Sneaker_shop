import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sneaker_store/models/favourite_dao.dart';
import 'package:sneaker_store/models/favourite_item.dart';
import 'package:sneaker_store/models/user_dao.dart';

class TestUserDao extends ChangeNotifier implements UserDao {
  TestUserDao(this.uid);

  final String? uid;

  @override
  String? userId() => uid;

  @override
  bool isLoggedIn() => uid != null;

  @override
  String? email() => uid == null ? null : 'test@example.com';

  @override
  Future<String?> login(String email, String password) async => null;

  @override
  Future<void> logout() async {}

  @override
  Future<String?> signup(String email, String password) async => null;

  @override
  String errorMsg = 'An error has occurred.';

  @override
  FirebaseAuth get auth => throw UnimplementedError();
}

FavouriteItem favouriteItem({int sneakerId = 1}) {
  return FavouriteItem(
    sneakerId: sneakerId,
    name: 'Nike Air Max Pro',
    brand: 'Nike',
    price: 149.99,
    emoji: '👟',
    imageUrl: 'https://example.com/nike-air-max-pro.png',
    savedAt: DateTime(2026, 1, 1, 12),
  );
}

void main() {
  group('FavouriteDao Firebase write tests', () {
    test('addFavourite() writes sneaker to users/{uid}/favourites/{sneakerId}',
        () async {
      final firestore = FakeFirebaseFirestore();
      final userDao = TestUserDao('test-user-uid');
      final dao = FavouriteDao(userDao, firestore: firestore);

      await dao.addFavourite(favouriteItem(sneakerId: 7));

      final doc = await firestore
          .collection('users')
          .doc('test-user-uid')
          .collection('favourites')
          .doc('7')
          .get();

      expect(doc.exists, isTrue);
      expect(doc.data()?['sneakerId'], 7);
      expect(doc.data()?['name'], 'Nike Air Max Pro');
      expect(doc.data()?['brand'], 'Nike');
      expect(doc.data()?['price'], 149.99);
      expect(doc.data()?['emoji'], '👟');
      expect(doc.data()?['imageUrl'], 'https://example.com/nike-air-max-pro.png');
      expect(doc.data()?['savedAt'], isNotNull);
    });

    test('toggleFavourite() adds sneaker if it is not saved yet', () async {
      final firestore = FakeFirebaseFirestore();
      final userDao = TestUserDao('test-user-uid');
      final dao = FavouriteDao(userDao, firestore: firestore);

      final added = await dao.toggleFavourite(favouriteItem(sneakerId: 10));

      final doc = await firestore
          .collection('users')
          .doc('test-user-uid')
          .collection('favourites')
          .doc('10')
          .get();

      expect(added, isTrue);
      expect(doc.exists, isTrue);
      expect(doc.data()?['sneakerId'], 10);
    });

    test('toggleFavourite() deletes sneaker if it already exists', () async {
      final firestore = FakeFirebaseFirestore();
      final userDao = TestUserDao('test-user-uid');
      final dao = FavouriteDao(userDao, firestore: firestore);

      await dao.addFavourite(favouriteItem(sneakerId: 12));
      final added = await dao.toggleFavourite(favouriteItem(sneakerId: 12));

      final doc = await firestore
          .collection('users')
          .doc('test-user-uid')
          .collection('favourites')
          .doc('12')
          .get();

      expect(added, isFalse);
      expect(doc.exists, isFalse);
    });

    test('removeFavourite() deletes saved sneaker from Firebase', () async {
      final firestore = FakeFirebaseFirestore();
      final userDao = TestUserDao('test-user-uid');
      final dao = FavouriteDao(userDao, firestore: firestore);

      await dao.addFavourite(favouriteItem(sneakerId: 15));
      await dao.removeFavourite(15);

      final doc = await firestore
          .collection('users')
          .doc('test-user-uid')
          .collection('favourites')
          .doc('15')
          .get();

      expect(doc.exists, isFalse);
    });
  });
}
