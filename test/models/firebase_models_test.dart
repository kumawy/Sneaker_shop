import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/test.dart';

import 'package:sneaker_store/models/sneaker_review.dart';
import 'package:sneaker_store/models/favourite_item.dart';

void main() {
  group('SneakerReview', () {
    final baseDate = DateTime(2024, 6, 15, 12, 0);

    Map<String, dynamic> validJson({
      int sneakerId = 42,
      String email = 'user@example.com',
      String text = 'Great shoe!',
      double rating = 4.5,
    }) =>
        {
          'sneakerId': sneakerId,
          'email': email,
          'text': text,
          'rating': rating,
          'date': Timestamp.fromDate(baseDate),
          'userId': 'uid_abc123',
        };

    test('fromJson parses all standard fields', () {
      final review = SneakerReview.fromJson(validJson());

      expect(review.sneakerId, equals(42));
      expect(review.email, equals('user@example.com'));
      expect(review.text, equals('Great shoe!'));
      expect(review.rating, equals(4.5));
      expect(review.userId, equals('uid_abc123'));
      expect(review.date, equals(baseDate));
    });

    test('fromJson accepts "comment" field as alias for "text"', () {
      final json = validJson();
      json.remove('text');
      json['comment'] = 'Alias comment field';

      final review = SneakerReview.fromJson(json);
      expect(review.text, equals('Alias comment field'));
    });

    test('fromJson accepts "userEmail" as alias for "email"', () {
      final json = validJson();
      json.remove('email');
      json['userEmail'] = 'alias@example.com';

      final review = SneakerReview.fromJson(json);
      expect(review.email, equals('alias@example.com'));
    });

    test('fromJson accepts "createdAt" as alias for "date"', () {
      final json = validJson();
      json.remove('date');
      json['createdAt'] = Timestamp.fromDate(baseDate);

      final review = SneakerReview.fromJson(json);
      expect(review.date, equals(baseDate));
    });

    test('fromJson defaults to anonymous when email is missing', () {
      final json = validJson()..remove('email');
      final review = SneakerReview.fromJson(json);
      expect(review.email, equals('anonymous'));
    });

    test('fromJson handles integer rating as double', () {
      final json = validJson();
      json['rating'] = 4;
      final review = SneakerReview.fromJson(json);
      expect(review.rating, equals(4.0));
    });

    test('toJson includes all required fields', () {
      final review = SneakerReview(
        sneakerId: 42,
        email: 'user@example.com',
        text: 'Great shoe!',
        rating: 4.5,
        date: baseDate,
        userId: 'uid_abc123',
      );

      final json = review.toJson();

      expect(json.containsKey('sneakerId'), isTrue);
      expect(json.containsKey('email'), isTrue);
      expect(json.containsKey('text'), isTrue);
      expect(json.containsKey('rating'), isTrue);
      expect(json.containsKey('date'), isTrue);
      expect(json.containsKey('userId'), isTrue);
    });

    test('toJson roundtrip preserves values', () {
      final original = SneakerReview(
        sneakerId: 7,
        email: 'test@test.com',
        text: 'Fits perfectly',
        rating: 5.0,
        date: baseDate,
        userId: 'user_7',
      );

      final json = original.toJson();
      final restored = SneakerReview.fromJson(json);

      expect(restored.sneakerId, equals(original.sneakerId));
      expect(restored.email, equals(original.email));
      expect(restored.text, equals(original.text));
      expect(restored.rating, equals(original.rating));
      expect(restored.userId, equals(original.userId));
    });

    test('rating boundaries: accepts 1.0 and 5.0', () {
      final low = SneakerReview.fromJson(validJson(rating: 1.0));
      final high = SneakerReview.fromJson(validJson(rating: 5.0));

      expect(low.rating, equals(1.0));
      expect(high.rating, equals(5.0));
    });
  });
  group('FavouriteItem', () {
    final savedDate = DateTime(2025, 1, 20, 10, 30);

    test('toJson produces correct map', () {
      final item = FavouriteItem(
        sneakerId: 3,
        name: 'Air Force 1',
        brand: 'Nike',
        price: 110.0,
        emoji: '👟',
        imageUrl: 'https://example.com/shoe.jpg',
        savedAt: savedDate,
      );

      final json = item.toJson();

      expect(json['sneakerId'], equals(3));
      expect(json['name'], equals('Air Force 1'));
      expect(json['brand'], equals('Nike'));
      expect(json['price'], equals(110.0));
      expect(json['emoji'], equals('👟'));
      expect(json['imageUrl'], equals('https://example.com/shoe.jpg'));
      expect(json['savedAt'], isA<Timestamp>());
    });

    test('toJson Timestamp matches original DateTime', () {
      final item = FavouriteItem(
        sneakerId: 1,
        name: 'Test',
        brand: 'Brand',
        price: 50.0,
        emoji: '👟',
        savedAt: savedDate,
      );

      final json = item.toJson();
      final ts = json['savedAt'] as Timestamp;

      expect(ts.toDate(), equals(savedDate));
    });

    test('defaults emoji to 👟 when field is missing from JSON', () {

      final item = FavouriteItem(
        sneakerId: 1,
        name: 'Shoe',
        brand: 'Brand',
        price: 50.0,
        emoji: '👟',
        savedAt: savedDate,
      );

      expect(item.emoji, equals('👟'));
    });
  });
}
