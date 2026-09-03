class ApiProduct {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final ApiRating rating;

  const ApiProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory ApiProduct.fromJson(Map<String, dynamic> json) {
    return ApiProduct(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
      rating: ApiRating.fromJson(json['rating'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'image': image,
        'rating': rating.toJson(),
      };

  String get displayCategory =>
      category.isEmpty ? 'General' : _capitalize(category);

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
}

class ApiRating {
  final double rate;
  final int count;

  const ApiRating({required this.rate, required this.count});

  factory ApiRating.fromJson(Map<String, dynamic> json) => ApiRating(
        rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
        count: (json['count'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {'rate': rate, 'count': count};
}

class NetworkResponse<T> {
  final T? data;
  final String? errorMessage;
  final bool isSuccess;

  const NetworkResponse._({
    this.data,
    this.errorMessage,
    required this.isSuccess,
  });

  factory NetworkResponse.success(T data) =>
      NetworkResponse._(data: data, isSuccess: true);

  factory NetworkResponse.error(String message) =>
      NetworkResponse._(errorMessage: message, isSuccess: false);
}
