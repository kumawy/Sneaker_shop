import 'package:test/test.dart';
import 'package:sneaker_store/network/api_product.dart';

Map<String, dynamic> _validJson({
  int id = 1,
  String title = 'Leather Running Shoes',
  double price = 89.99,
  String category = 'mens-shoes',
  double ratingRate = 4.2,
  int ratingCount = 150,
}) =>
    {
      'id': id,
      'title': title,
      'price': price,
      'description': 'Great running shoes',
      'category': category,
      'image': 'https://example.com/shoe.jpg',
      'rating': {'rate': ratingRate, 'count': ratingCount},
    };

void main() {
  group('ApiRating.fromJson', () {
    test('parses rate and count correctly', () {
      final rating = ApiRating.fromJson({'rate': 4.5, 'count': 200});

      expect(rating.rate, equals(4.5));
      expect(rating.count, equals(200));
    });

    test('defaults to 0 when fields are missing', () {
      final rating = ApiRating.fromJson({});

      expect(rating.rate, equals(0.0));
      expect(rating.count, equals(0));
    });

    test('handles integer rate as double', () {
      final rating = ApiRating.fromJson({'rate': 4, 'count': 10});
      expect(rating.rate, equals(4.0));
    });

    test('toJson serialises correctly', () {
      const rating = ApiRating(rate: 3.7, count: 99);
      final json = rating.toJson();

      expect(json['rate'], equals(3.7));
      expect(json['count'], equals(99));
    });
  });
  group('ApiProduct.fromJson', () {
    test('parses all fields from valid JSON', () {
      final product = ApiProduct.fromJson(_validJson());

      expect(product.id, equals(1));
      expect(product.title, equals('Leather Running Shoes'));
      expect(product.price, equals(89.99));
      expect(product.category, equals('mens-shoes'));
      expect(product.image, equals('https://example.com/shoe.jpg'));
      expect(product.rating.rate, equals(4.2));
      expect(product.rating.count, equals(150));
    });

    test('handles missing title gracefully (defaults to empty string)', () {
      final json = _validJson()..remove('title');
      final product = ApiProduct.fromJson(json);

      expect(product.title, equals(''));
    });

    test('handles missing price gracefully (defaults to 0.0)', () {
      final json = _validJson()..remove('price');
      final product = ApiProduct.fromJson(json);

      expect(product.price, equals(0.0));
    });

    test('handles integer price as double', () {
      final json = _validJson();
      json['price'] = 100;
      final product = ApiProduct.fromJson(json);

      expect(product.price, equals(100.0));
    });

    test('handles missing rating object gracefully', () {
      final json = _validJson()..remove('rating');
      final product = ApiProduct.fromJson(json);

      expect(product.rating.rate, equals(0.0));
      expect(product.rating.count, equals(0));
    });
  });
  group('ApiProduct.toJson', () {
    test('roundtrip fromJson → toJson preserves all fields', () {
      final original = ApiProduct.fromJson(_validJson());
      final json = original.toJson();
      final restored = ApiProduct.fromJson(json);

      expect(restored.id, equals(original.id));
      expect(restored.title, equals(original.title));
      expect(restored.price, equals(original.price));
      expect(restored.category, equals(original.category));
      expect(restored.image, equals(original.image));
      expect(restored.rating.rate, equals(original.rating.rate));
      expect(restored.rating.count, equals(original.rating.count));
    });
  });
  group('ApiProduct computed properties', () {
    test('formattedPrice formats correctly with two decimal places', () {
      final product = ApiProduct.fromJson(_validJson(price: 89.99));
      expect(product.formattedPrice, equals('\$89.99'));
    });

    test('formattedPrice adds trailing zero for round prices', () {
      final product = ApiProduct.fromJson(_validJson(price: 100.0));
      expect(product.formattedPrice, equals('\$100.00'));
    });

    test('displayCategory capitalises first letter', () {
      final product = ApiProduct.fromJson(_validJson(category: 'mens-shoes'));
      expect(product.displayCategory, equals('Mens-shoes'));
    });

    test('displayCategory returns "General" for empty category', () {
      final json = _validJson();
      json['category'] = '';
      final product = ApiProduct.fromJson(json);
      expect(product.displayCategory, equals('General'));
    });
  });
  group('NetworkResponse', () {
    test('success sets isSuccess = true and contains data', () {
      final response = NetworkResponse.success([1, 2, 3]);

      expect(response.isSuccess, isTrue);
      expect(response.data, equals([1, 2, 3]));
      expect(response.errorMessage, isNull);
    });

    test('error sets isSuccess = false and contains message', () {
      final response = NetworkResponse<List<int>>.error('Server error');

      expect(response.isSuccess, isFalse);
      expect(response.errorMessage, equals('Server error'));
      expect(response.data, isNull);
    });

    test('success works with single ApiProduct', () {
      final product = ApiProduct.fromJson(_validJson());
      final response = NetworkResponse.success(product);

      expect(response.isSuccess, isTrue);
      expect(response.data?.title, equals('Leather Running Shoes'));
    });

    test('error message is preserved exactly', () {
      const msg = 'Network error: Connection refused';
      final response = NetworkResponse<String>.error(msg);

      expect(response.errorMessage, equals(msg));
    });
  });
}
