import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

import 'package:sneaker_store/network/sneaker_api_service.dart';

@GenerateMocks([http.Client])

void main() {

  group('SneakerApiService — unit contract', () {
    late SneakerApiService service;

    setUp(() {
      service = SneakerApiService();
    });
    test('shoeCategories contains expected categories', () {
      expect(
        SneakerApiService.shoeCategories,
        containsAll(['mens-shoes', 'womens-shoes']),
      );
    });
    test('fetchCategories returns success with shoe categories list', () async {
      final response = await service.fetchCategories();

      expect(response.isSuccess, isTrue);
      expect(response.data, isNotNull);
      expect(response.data, containsAll(['mens-shoes', 'womens-shoes']));
    });

    test('fetchCategories never returns an error', () async {
      final response = await service.fetchCategories();
      expect(response.isSuccess, isTrue);
    });
    test('fetchByCategory returns error for unknown category', () async {
      final response = await service.fetchByCategory('electronics');

      expect(response.isSuccess, isFalse);
      expect(response.errorMessage, contains('Only shoe categories'));
    });

    test('fetchByCategory returns error for empty string category', () async {
      final response = await service.fetchByCategory('');

      expect(response.isSuccess, isFalse);
    });

    test('fetchByCategory returns error for sneakers (not in allowed list)',
        () async {
      final response = await service.fetchByCategory('sneakers');

      expect(response.isSuccess, isFalse);
      expect(response.errorMessage, isNotNull);
    });
  });
  group('NetworkResponse helpers', () {
    test('success wraps data and sets isSuccess', () {
      final r = NetworkResponse.success('hello');
      expect(r.isSuccess, isTrue);
      expect(r.data, equals('hello'));
      expect(r.errorMessage, isNull);
    });

    test('error wraps message and clears data', () {
      final r = NetworkResponse<String>.error('oops');
      expect(r.isSuccess, isFalse);
      expect(r.errorMessage, equals('oops'));
      expect(r.data, isNull);
    });
  });
}
