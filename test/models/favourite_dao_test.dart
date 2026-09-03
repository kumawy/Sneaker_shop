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
    name: 'Air Max 90',
    brand: 'Nike',
    price: 120.0,
    emoji: '👟',
    imageUrl: 'https://example.com/air-max-90.jpg',
    savedAt: DateTime(2025, 1, 1),
  );
}

void main() {
  group('FavouriteDao without logged in user', () {
    late FavouriteDao dao;

    setUp(() {
      dao = FavouriteDao(
        TestUserDao(null),
        firestore: FakeFirebaseFirestore(),
      );
    });

    test('getFavouritesStream() returns empty stream when user is not logged in',
        () async {
      final values = <List<FavouriteItem>>[];
      final subscription = dao.getFavouritesStream().listen(values.add);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      await subscription.cancel();

      expect(values, isEmpty);
    });

    test('isFavouriteStream() emits false when user is not logged in', () async {
      expect(await dao.isFavouriteStream(1).first, isFalse);
    });

    test('addFavourite() throws when user is not logged in', () async {
      expect(
        () => dao.addFavourite(favouriteItem()),
        throwsA(isA<Exception>()),
      );
    });

    test('removeFavourite() throws when user is not logged in', () async {
      expect(
        () => dao.removeFavourite(1),
        throwsA(isA<Exception>()),
      );
    });

    test('toggleFavourite() throws when user is not logged in', () async {
      expect(
        () => dao.toggleFavourite(favouriteItem()),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('FavouriteItem.toJson', () {
    test('serialises sneakerId correctly', () {
      final json = favouriteItem(sneakerId: 7).toJson();

      expect(json['sneakerId'], 7);
    });

    test('serialises name, brand, price, emoji, imageUrl', () {
      final json = favouriteItem().toJson();

      expect(json['name'], 'Air Max 90');
      expect(json['brand'], 'Nike');
      expect(json['price'], 120.0);
      expect(json['emoji'], '👟');
      expect(json['imageUrl'], 'https://example.com/air-max-90.jpg');
    });

    test('savedAt is stored as a Firestore Timestamp', () {
      final json = favouriteItem().toJson();

      expect(json['savedAt'], isNot(isA<DateTime>()));
    });
  });
}
