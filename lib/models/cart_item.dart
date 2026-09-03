import 'sneaker.dart';

class CartItem {
  final Sneaker sneaker;
  String selectedSize;
  String selectedColor;
  int quantity;

  CartItem({
    required this.sneaker,
    required this.selectedSize,
    required this.selectedColor,
    this.quantity = 1,
  });

  double get total => sneaker.price * quantity;
}
