import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sneaker_store/models/sneaker.dart';
import 'package:sneaker_store/providers/bookmark_provider.dart';

Sneaker _sneaker({int id = 1, String name = 'Air Max', double price = 100.0}) =>
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

  TestWidgetsFlutterBinding.ensureInitialized();

  late BookmarkProvider bookmarks;

  setUp(() {

    SharedPreferences.setMockInitialValues({});
    bookmarks = BookmarkProvider();
  });

  tearDown(() {
    bookmarks.dispose();
  });
  group('Initial state', () {
    test('bookmarks list is empty', () {
      expect(bookmarks.bookmarks, isEmpty);
    });

    test('count is 0', () {
      expect(bookmarks.count, equals(0));
    });

    test('isBookmarked returns false for any id', () {
      expect(bookmarks.isBookmarked(1), isFalse);
    });
  });
  group('toggle()', () {
    test('adds sneaker when not already bookmarked', () async {
      await bookmarks.toggle(_sneaker());

      expect(bookmarks.count, equals(1));
      expect(bookmarks.isBookmarked(1), isTrue);
    });

    test('removes sneaker when already bookmarked', () async {
      await bookmarks.toggle(_sneaker());
      await bookmarks.toggle(_sneaker());

      expect(bookmarks.count, equals(0));
      expect(bookmarks.isBookmarked(1), isFalse);
    });

    test('can bookmark multiple different sneakers', () async {
      await bookmarks.toggle(_sneaker(id: 1));
      await bookmarks.toggle(_sneaker(id: 2));
      await bookmarks.toggle(_sneaker(id: 3));

      expect(bookmarks.count, equals(3));
    });

    test('removes only the toggled sneaker, not others', () async {
      await bookmarks.toggle(_sneaker(id: 1));
      await bookmarks.toggle(_sneaker(id: 2));
      await bookmarks.toggle(_sneaker(id: 1));

      expect(bookmarks.count, equals(1));
      expect(bookmarks.isBookmarked(1), isFalse);
      expect(bookmarks.isBookmarked(2), isTrue);
    });
  });
  group('remove()', () {
    test('removes sneaker by id', () async {
      await bookmarks.toggle(_sneaker(id: 5));
      await bookmarks.remove(5);

      expect(bookmarks.isBookmarked(5), isFalse);
    });

    test('does nothing when removing a non-existent id', () async {
      await bookmarks.toggle(_sneaker(id: 1));
      await bookmarks.remove(999);

      expect(bookmarks.count, equals(1));
    });
  });
  group('clearAll()', () {
    test('removes all bookmarks', () async {
      await bookmarks.toggle(_sneaker(id: 1));
      await bookmarks.toggle(_sneaker(id: 2));
      await bookmarks.clearAll();

      expect(bookmarks.bookmarks, isEmpty);
      expect(bookmarks.count, equals(0));
    });

    test('after clearAll, isBookmarked returns false for all', () async {
      await bookmarks.toggle(_sneaker(id: 1));
      await bookmarks.clearAll();

      expect(bookmarks.isBookmarked(1), isFalse);
    });
  });
  group('isBookmarked()', () {
    test('returns true after bookmarking', () async {
      await bookmarks.toggle(_sneaker(id: 42));
      expect(bookmarks.isBookmarked(42), isTrue);
    });

    test('returns false for id that was never added', () {
      expect(bookmarks.isBookmarked(999), isFalse);
    });
  });
  group('bookmarkStream', () {
    test('emits updated list after toggle', () async {
      final events = <int>[];
      final sub = bookmarks.bookmarkStream.listen(
        (list) => events.add(list.length),
      );

      await bookmarks.toggle(_sneaker(id: 1));
      await bookmarks.toggle(_sneaker(id: 2));

      await Future.delayed(Duration.zero);
      await sub.cancel();

      expect(events, contains(1));
      expect(events, contains(2));
    });

    test('emits empty list after clearAll', () async {
      await bookmarks.toggle(_sneaker(id: 1));

      final lengths = <int>[];
      final sub = bookmarks.bookmarkStream.listen(
        (list) => lengths.add(list.length),
      );

      await bookmarks.clearAll();
      await Future.delayed(Duration.zero);
      await sub.cancel();

      expect(lengths, contains(0));
    });
  });
}
