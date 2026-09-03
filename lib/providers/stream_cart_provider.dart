import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/sneaker.dart';

class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  double get total => items.fold(0.0, (sum, item) => sum + item.total);
  bool get isEmpty => items.isEmpty;
}

class StreamCartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  final StreamController<CartState> _cartStreamController =
      StreamController<CartState>.broadcast();

  Stream<CartState> get cartStream => _cartStreamController.stream;

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get total => _items.fold(0.0, (sum, item) => sum + item.total);

  void _pushToStream() {
    if (!_cartStreamController.isClosed) {
      _cartStreamController.sink.add(CartState(items: List.from(_items)));
    }
    notifyListeners();
  }

  void addItem(Sneaker sneaker, String size, String color) {
    final existingIndex = _items.indexWhere(
      (item) =>
          item.sneaker.id == sneaker.id &&
          item.selectedSize == size &&
          item.selectedColor == color,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(
        sneaker: sneaker,
        selectedSize: size,
        selectedColor: color,
        quantity: 1,
      ));
    }
    _pushToStream();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    _pushToStream();
  }

  void incrementQuantity(int index) {
    _items[index].quantity++;
    _pushToStream();
  }

  void decrementQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    _pushToStream();
  }

  void clearCart() {
    _items.clear();
    _pushToStream();
  }

  @override
  void dispose() {
    _cartStreamController.close();
    super.dispose();
  }
}
