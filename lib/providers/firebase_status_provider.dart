import 'package:flutter/foundation.dart';

class FirebaseStatusProvider extends ChangeNotifier {
  bool _ready = false;
  String? _error;

  bool get ready => _ready;
  String? get error => _error;

  void markReady() {
    _ready = true;
    _error = null;
    notifyListeners();
  }

  void markError(Object error) {
    _ready = false;
    _error = error.toString();
    notifyListeners();
  }
}
