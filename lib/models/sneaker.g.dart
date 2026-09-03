// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sneaker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sneaker _$SneakerFromJson(Map<String, dynamic> json) => Sneaker(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      brand: json['brand'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      sizes: (json['sizes'] as List<dynamic>).map((e) => e as String).toList(),
      colors:
          (json['colors'] as List<dynamic>).map((e) => e as String).toList(),
      emoji: json['emoji'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviews: (json['reviews'] as num).toInt(),
    );

Map<String, dynamic> _$SneakerToJson(Sneaker instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'brand': instance.brand,
      'price': instance.price,
      'description': instance.description,
      'sizes': instance.sizes,
      'colors': instance.colors,
      'emoji': instance.emoji,
      'rating': instance.rating,
      'reviews': instance.reviews,
    };
