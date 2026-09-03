import 'package:test/test.dart';
import 'package:sneaker_store/models/sneaker.dart';
import 'package:sneaker_store/providers/cart_provider.dart';

Sneaker _sneaker({
  int id = 1,
  String name = 'Air Max',
  double price = 100.0,
}) =>
    Sneaker(
      id: id,
      name: name,
      brand: 'Nike',
      price: price,
      description: '',
      sizes: ['US 9'],
      colors: ['White'],
      emoji: '👟',
      rating: 4.0,
      reviews: 10,
    );

void main() {
  late CartProvider cart;

  setUp(() {
    cart = CartProvider();
  });

  tearDown(() {
    cart.dispose();
  });
  group('Initial state', () {
    test('cart is empty', () {
      expect(cart.items, isEmpty);
    });

    test('itemCount is 0', () {
      expect(cart.itemCount, equals(0));
    });

    test('total is 0.0', () {
      expect(cart.total, equals(0.0));
    });
  });
  group('addItem()', () {
    test('adds a new item to the cart', () {
      cart.addItem(_sneaker(), 'US 9', 'White');

      expect(cart.items.length, equals(1));
      expect(cart.items.first.sneaker.name, equals('Air Max'));
    });

    test('itemCount becomes 1 after adding one item', () {
      cart.addItem(_sneaker(), 'US 9', 'White');
      expect(cart.itemCount, equals(1));
    });

    test('total equals sneaker price after adding one item', () {
      cart.addItem(_sneaker(price: 120.0), 'US 9', 'White');
      expect(cart.total, equals(120.0));
    });

    test('adds same sneaker with different size as separate item', () {
      final s = _sneaker();
      cart.addItem(s, 'US 9', 'White');
      cart.addItem(s, 'US 10', 'White');

      expect(cart.items.length, equals(2));
    });

    test('adds same sneaker with different color as separate item', () {
      final s = _sneaker();
      cart.addItem(s, 'US 9', 'White');
      cart.addItem(s, 'US 9', 'Black');

      expect(cart.items.length, equals(2));
    });

    test('increments quantity when same sneaker+size+color added again', () {
      final s = _sneaker();
      cart.addItem(s, 'US 9', 'White');
      cart.addItem(s, 'US 9', 'White');

      expect(cart.items.length, equals(1));
      expect(cart.items.first.quantity, equals(2));
      expect(cart.itemCount, equals(2));
    });

    test('total is correct for two different items', () {
      cart.addItem(_sneaker(id: 1, price: 100.0), 'US 9', 'White');
      cart.addItem(_sneaker(id: 2, price: 80.0), 'US 9', 'Black');

      expect(cart.total, closeTo(180.0, 0.001));
    });
  });
  group('removeItem()', () {
    test('removes item at given index', () {
      cart.addItem(_sneaker(), 'US 9', 'White');
      cart.removeItem(0);

      expect(cart.items, isEmpty);
    });

    test('cart is empty after removing the only item', () {
      cart.addItem(_sneaker(), 'US 9', 'White');
      cart.removeItem(0);

      expect(cart.itemCount, equals(0));
      expect(cart.total, equals(0.0));
    });

    test('removes correct item when multiple items exist', () {
      cart.addItem(_sneaker(id: 1, name: 'Shoe A'), 'US 9', 'White');
      cart.addItem(_sneaker(id: 2, name: 'Shoe B'), 'US 9', 'Black');
      cart.removeItem(0);

      expect(cart.items.length, equals(1));
      expect(cart.items.first.sneaker.name, equals('Shoe B'));
    });
  });
  group('incrementQuantity()', () {
    test('increases quantity by 1', () {
      cart.addItem(_sneaker(), 'US 9', 'White');
      cart.incrementQuantity(0);

      expect(cart.items.first.quantity, equals(2));
    });

    test('itemCount reflects incremented quantity', () {
      cart.addItem(_sneaker(), 'US 9', 'White');
      cart.incrementQuantity(0);
      cart.incrementQuantity(0);

      expect(cart.itemCount, equals(3));
    });
  });

  group('decrementQuantity()', () {
    test('decreases quantity by 1 when qty > 1', () {
      cart.addItem(_sneaker(), 'US 9', 'White');
      cart.incrementQuantity(0);
      cart.decrementQuantity(0);

      expect(cart.items.first.quantity, equals(1));
    });

    test('removes item when qty reaches 0 (qty was 1)', () {
      cart.addItem(_sneaker(), 'US 9', 'White');
      cart.decrementQuantity(0);

      expect(cart.items, isEmpty);
    });
  });
  group('clearCart()', () {
    test('removes all items', () {
      cart.addItem(_sneaker(id: 1), 'US 9', 'White');
      cart.addItem(_sneaker(id: 2), 'US 9', 'Black');
      cart.clearCart();

      expect(cart.items, isEmpty);
    });

    test('resets itemCount to 0', () {
      cart.addItem(_sneaker(), 'US 9', 'White');
      cart.clearCart();

      expect(cart.itemCount, equals(0));
    });

    test('resets total to 0.0', () {
      cart.addItem(_sneaker(price: 200.0), 'US 9', 'White');
      cart.clearCart();

      expect(cart.total, equals(0.0));
    });
  });
  group('cartStream', () {
    test('emits CartState after addItem', () async {
      final events = <int>[];
      final sub = cart.cartStream.listen((state) {
        events.add(state.itemCount);
      });

      cart.addItem(_sneaker(), 'US 9', 'White');
      cart.addItem(_sneaker(id: 2), 'US 9', 'Black');

      await Future.delayed(Duration.zero);
      await sub.cancel();

      expect(events, contains(1));
      expect(events, contains(2));
    });

    test('emits empty CartState after clearCart', () async {
      cart.addItem(_sneaker(), 'US 9', 'White');

      final states = <bool>[];
      final sub = cart.cartStream.listen((state) {
        states.add(state.isEmpty);
      });

      cart.clearCart();

      await Future.delayed(Duration.zero);
      await sub.cancel();

      expect(states, contains(true));
    });
  });
}
