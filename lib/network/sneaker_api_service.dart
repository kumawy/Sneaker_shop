import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'api_product.dart';

const String apiBaseUrl = 'https://dummyjson.com';

class SneakerApiService {
  static const List<String> shoeCategories = [
    'mens-shoes',
    'womens-shoes',
  ];

  Map<String, dynamic> _mapDummyProductToApiProduct(
    Map<String, dynamic> item,
  ) {
    return {
      'id': item['id'],
      'title': item['title'],
      'price': item['price'],
      'description': item['description'],
      'category': item['category'],
      'image': item['thumbnail'],
      'rating': {
        'rate': item['rating'],
        'count': item['stock'] ?? 0,
      },
    };
  }

  Future<NetworkResponse<List<ApiProduct>>> fetchProducts({
    int limit = 20,
  }) async {
    try {
      final allProducts = <ApiProduct>[];

      for (final category in shoeCategories) {
        final uri = Uri.parse('$apiBaseUrl/products/category/$category');

        log('GET $uri');

        final response = await http.get(
          uri,
          headers: {'Content-Type': 'application/json'},
        ).timeout(const Duration(seconds: 20));

        log('Response status: ${response.statusCode}');

        if (response.statusCode == 200) {
          final Map<String, dynamic> body =
              json.decode(response.body) as Map<String, dynamic>;

          final List<dynamic> jsonList = body['products'] as List<dynamic>;

          final products = jsonList
              .map(
                (e) => ApiProduct.fromJson(
                  _mapDummyProductToApiProduct(e as Map<String, dynamic>),
                ),
              )
              .toList();

          allProducts.addAll(products);
        } else {
          return NetworkResponse.error(
            'Server returned status ${response.statusCode}',
          );
        }
      }

      return NetworkResponse.success(
        allProducts.take(limit).toList(),
      );
    } catch (e) {
      log('Network error: $e');
      return NetworkResponse.error('Network error: $e');
    }
  }

  Future<NetworkResponse<ApiProduct>> fetchProductById(int id) async {
    final uri = Uri.parse('$apiBaseUrl/products/$id');

    log('GET $uri');

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        final category = json['category']?.toString();

        if (!shoeCategories.contains(category)) {
          return NetworkResponse.error(
            'This product is not a shoe product.',
          );
        }

        return NetworkResponse.success(
          ApiProduct.fromJson(
            _mapDummyProductToApiProduct(json),
          ),
        );
      } else {
        return NetworkResponse.error('Status ${response.statusCode}');
      }
    } catch (e) {
      return NetworkResponse.error('Network error: $e');
    }
  }

  Future<NetworkResponse<List<ApiProduct>>> fetchByCategory(
    String category,
  ) async {
    if (!shoeCategories.contains(category)) {
      return NetworkResponse.error(
        'Only shoe categories are allowed.',
      );
    }

    final uri = Uri.parse(
      '$apiBaseUrl/products/category/${Uri.encodeComponent(category)}',
    );

    log('GET $uri');

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body =
            json.decode(response.body) as Map<String, dynamic>;

        final List<dynamic> jsonList = body['products'] as List<dynamic>;

        final products = jsonList
            .map(
              (e) => ApiProduct.fromJson(
                _mapDummyProductToApiProduct(e as Map<String, dynamic>),
              ),
            )
            .toList();

        return NetworkResponse.success(products);
      } else {
        return NetworkResponse.error('Status ${response.statusCode}');
      }
    } catch (e) {
      return NetworkResponse.error('Network error: $e');
    }
  }

  Future<NetworkResponse<List<String>>> fetchCategories() async {
    return NetworkResponse.success(shoeCategories);
  }
}

class NetworkResponse<T> {
  final T? data;
  final String? errorMessage;
  final bool isSuccess;

  const NetworkResponse._({
    required this.isSuccess,
    this.data,
    this.errorMessage,
  });

  factory NetworkResponse.success(T data) =>
      NetworkResponse._(isSuccess: true, data: data);

  factory NetworkResponse.error(String message) =>
      NetworkResponse._(isSuccess: false, errorMessage: message);
}
