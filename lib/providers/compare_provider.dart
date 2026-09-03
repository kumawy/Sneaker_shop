import 'package:flutter/material.dart';
import '../models/sneaker.dart';

class CompareProvider extends ChangeNotifier {
  static const int maxItems = 3;

  final List<Sneaker> _items = [];

  List<Sneaker> get items => List.unmodifiable(_items);
  int get count => _items.length;
  bool get isFull => _items.length >= maxItems;

  bool isAdded(int sneakerId) => _items.any((s) => s.id == sneakerId);

  String? toggle(Sneaker sneaker) {
    if (isAdded(sneaker.id)) {
      _items.removeWhere((s) => s.id == sneaker.id);
      notifyListeners();
      return null;
    }
    if (isFull) {
      return 'Maximum 3 items can be compared. Remove one first.';
    }
    _items.add(sneaker);
    notifyListeners();
    return null;
  }

  void remove(int sneakerId) {
    _items.removeWhere((s) => s.id == sneakerId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
