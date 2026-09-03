import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sneaker.dart';

class StreamBookmarkProvider extends ChangeNotifier {
  static const String _prefsKey = 'bookmarked_sneakers';

  final List<Sneaker> _bookmarks = [];

  late final StreamController<List<Sneaker>> _streamController;

  late final Stream<List<Sneaker>> bookmarkStream;

  StreamBookmarkProvider() {
    _streamController = StreamController<List<Sneaker>>.broadcast(
      onListen: () {
        _streamController.sink.add(List.unmodifiable(_bookmarks));
      },
    );

    bookmarkStream = _streamController.stream;
  }

  List<Sneaker> get bookmarks => List.unmodifiable(_bookmarks);
  int get count => _bookmarks.length;
  bool isBookmarked(int id) => _bookmarks.any((s) => s.id == id);

  void _pushToStream() {
    if (!_streamController.isClosed) {
      _streamController.sink.add(List.unmodifiable(_bookmarks));
    }
    notifyListeners();
  }

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_prefsKey)) return;

    final jsonList = prefs.getStringList(_prefsKey) ?? [];
    final loaded = jsonList.map((s) {
      final map = jsonDecode(s) as Map<String, dynamic>;
      return Sneaker.fromJson(map);
    }).toList();

    _bookmarks
      ..clear()
      ..addAll(loaded);

    _pushToStream();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _bookmarks.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList(_prefsKey, jsonList);
  }

  Future<void> toggle(Sneaker sneaker) async {
    if (isBookmarked(sneaker.id)) {
      _bookmarks.removeWhere((s) => s.id == sneaker.id);
    } else {
      _bookmarks.add(sneaker);
    }
    _pushToStream();
    await _save();
  }

  Future<void> remove(int sneakerId) async {
    _bookmarks.removeWhere((s) => s.id == sneakerId);
    _pushToStream();
    await _save();
  }

  Future<void> clearAll() async {
    _bookmarks.clear();
    _pushToStream();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
