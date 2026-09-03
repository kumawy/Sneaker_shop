import 'package:json_annotation/json_annotation.dart';

part 'sneaker.g.dart';

@JsonSerializable()
class Sneaker {
  final int id;
  final String name;
  final String brand;
  final double price;
  final String description;
  final List<String> sizes;
  final List<String> colors;
  final String emoji;
  // Real photo URL (800×600 px recommended, 4:3 ratio).
  // Falls back to emoji display if null or empty.
  final String? imageUrl;
  final double rating;
  final int reviews;

  const Sneaker({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.description,
    required this.sizes,
    required this.colors,
    required this.emoji,
    this.imageUrl,
    required this.rating,
    required this.reviews,
  });

  Sneaker copyWith({
    int? id,
    String? name,
    String? brand,
    double? price,
    String? description,
    List<String>? sizes,
    List<String>? colors,
    String? emoji,
    String? imageUrl,
    double? rating,
    int? reviews,
  }) {
    return Sneaker(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      description: description ?? this.description,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      emoji: emoji ?? this.emoji,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
    );
  }

  factory Sneaker.fromJson(Map<String, dynamic> json) =>
      _$SneakerFromJson(json);

  Map<String, dynamic> toJson() => _$SneakerToJson(this);
}
