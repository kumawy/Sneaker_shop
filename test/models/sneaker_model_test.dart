import 'package:test/test.dart';
import 'package:sneaker_store/data/sneaker_data.dart';
import 'package:sneaker_store/models/sneaker.dart';
import 'package:sneaker_store/models/cart_item.dart';

Sneaker makeSneaker({
  int id = 1,
  String name = 'Air Max 90',
  String brand = 'Nike',
  double price = 120.0,
}) =>
    Sneaker(
      id: id,
      name: name,
      brand: brand,
      price: price,
      description: 'Classic running shoe',
      sizes: ['US 8', 'US 9', 'US 10'],
      colors: ['White', 'Black'],
      emoji: '👟',
      rating: 4.5,
      reviews: 200,
    );

void main() {
  group('Sneaker model', () {
    test('stores all fields correctly', () {
      final sneaker = makeSneaker();

      expect(sneaker.id, equals(1));
      expect(sneaker.name, equals('Air Max 90'));
      expect(sneaker.brand, equals('Nike'));
      expect(sneaker.price, equals(120.0));
      expect(sneaker.sizes, containsAll(['US 8', 'US 9', 'US 10']));
      expect(sneaker.colors, containsAll(['White', 'Black']));
      expect(sneaker.emoji, equals('👟'));
      expect(sneaker.rating, equals(4.5));
      expect(sneaker.reviews, equals(200));
    });

    test('toJson produces correct map', () {
      final sneaker = makeSneaker();
      final json = sneaker.toJson();

      expect(json['id'], equals(1));
      expect(json['name'], equals('Air Max 90'));
      expect(json['brand'], equals('Nike'));
      expect(json['price'], equals(120.0));
      expect(json['emoji'], equals('👟'));
      expect(json['rating'], equals(4.5));
    });

    test('fromJson rebuilds identical object', () {
      final original = makeSneaker();
      final json = original.toJson();
      final restored = Sneaker.fromJson(json);

      expect(restored.id, equals(original.id));
      expect(restored.name, equals(original.name));
      expect(restored.brand, equals(original.brand));
      expect(restored.price, equals(original.price));
      expect(restored.sizes, equals(original.sizes));
      expect(restored.colors, equals(original.colors));
      expect(restored.emoji, equals(original.emoji));
      expect(restored.rating, equals(original.rating));
      expect(restored.reviews, equals(original.reviews));
    });

    test('fromJson handles missing optional numeric fields gracefully', () {

      final json = {
        'id': 99,
        'name': 'Test Shoe',
        'brand': 'TestBrand',
        'price': 50.0,
        'description': '',
        'sizes': <String>[],
        'colors': <String>[],
        'emoji': '👟',
        'rating': 0.0,
        'reviews': 0,
      };

      final sneaker = Sneaker.fromJson(json);
      expect(sneaker.id, equals(99));
      expect(sneaker.rating, equals(0.0));
      expect(sneaker.reviews, equals(0));
    });

    test('toJson and fromJson roundtrip preserves list fields', () {
      final sneaker = makeSneaker();
      final roundtripped = Sneaker.fromJson(sneaker.toJson());

      expect(roundtripped.sizes, equals(sneaker.sizes));
      expect(roundtripped.colors, equals(sneaker.colors));
    });

    test('catalog sneakers all have photo URLs', () {
      expect(sneakerData, isNotEmpty);
      for (final sneaker in sneakerData) {
        expect(
          sneaker.imageUrl?.trim(),
          isNotEmpty,
          reason: '${sneaker.name} should have a photo URL',
        );
      }
    });
  });
  group('CartItem', () {
    late Sneaker sneaker;
    late CartItem cartItem;

    setUp(() {
      sneaker = makeSneaker(price: 100.0);
      cartItem = CartItem(
        sneaker: sneaker,
        selectedSize: 'US 9',
        selectedColor: 'White',
      );
    });

    test('default quantity is 1', () {
      expect(cartItem.quantity, equals(1));
    });

    test('total equals price × quantity for qty=1', () {
      expect(cartItem.total, equals(100.0));
    });

    test('total updates correctly when quantity changes', () {
      cartItem.quantity = 3;
      expect(cartItem.total, equals(300.0));
    });

    test('total is zero when quantity is 0', () {
      cartItem.quantity = 0;
      expect(cartItem.total, equals(0.0));
    });

    test('stores selected size and color', () {
      expect(cartItem.selectedSize, equals('US 9'));
      expect(cartItem.selectedColor, equals('White'));
    });

    test('selected size and color can be updated', () {
      cartItem.selectedSize = 'US 10';
      cartItem.selectedColor = 'Black';

      expect(cartItem.selectedSize, equals('US 10'));
      expect(cartItem.selectedColor, equals('Black'));
    });

    test('total is correct for fractional prices', () {
      final expensiveSneaker = makeSneaker(price: 199.99);
      final item = CartItem(
        sneaker: expensiveSneaker,
        selectedSize: 'US 8',
        selectedColor: 'Black',
        quantity: 2,
      );

      expect(item.total, closeTo(399.98, 0.001));
    });
  });
}
