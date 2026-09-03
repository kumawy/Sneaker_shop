import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../data/sneaker_data.dart';
import 'sneaker.dart';

const adminEmails = <String>{
  'admin@test.com',
  'aslanmuratov09@gmail.com',
};

bool isAdminEmail(String? email) {
  if (email == null) return false;
  return adminEmails.contains(email.trim().toLowerCase());
}

class AdminProductDao {
  AdminProductDao({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  Stream<List<Sneaker>> watchProducts() {
    try {
      return _products.snapshots().map(_mergeProducts).handleError((error) {
        debugPrint('Products stream error: $error');
      });
    } catch (error) {
      debugPrint('Products fallback: $error');
      return Stream.value(sneakerData);
    }
  }

  List<Sneaker> _mergeProducts(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final byId = <int, Sneaker>{for (final s in sneakerData) s.id: s};
    final deleted = <int>{};

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final id = int.tryParse(doc.id) ?? (data['id'] as num?)?.toInt();
      if (id == null) continue;

      final active = data['active'] as bool? ?? true;
      if (!active) {
        deleted.add(id);
        byId.remove(id);
        continue;
      }

      final base = byId[id] ??
          Sneaker(
            id: id,
            name: 'New Sneaker $id',
            brand: 'Custom',
            price: 99,
            description: 'Custom sneaker added from admin panel.',
            sizes: const ['39', '40', '41', '42', '43'],
            colors: const ['White', 'Black'],
            emoji: '👟',
            imageUrl: null,
            rating: 0,
            reviews: 0,
          );

      byId[id] = base.copyWith(
        name: (data['name'] as String?)?.trim().isNotEmpty == true
            ? data['name'] as String
            : base.name,
        brand: (data['brand'] as String?)?.trim().isNotEmpty == true
            ? data['brand'] as String
            : base.brand,
        price: (data['price'] as num?)?.toDouble() ?? base.price,
        description:
            (data['description'] as String?)?.trim().isNotEmpty == true
                ? data['description'] as String
                : base.description,
        sizes: _stringList(data['sizes'], base.sizes),
        colors: _stringList(data['colors'], base.colors),
        emoji: (data['emoji'] as String?)?.trim().isNotEmpty == true
            ? data['emoji'] as String
            : base.emoji,
        imageUrl: (data['imageUrl'] as String?)?.trim().isNotEmpty == true
            ? data['imageUrl'] as String
            : base.imageUrl,
        rating: (data['rating'] as num?)?.toDouble() ?? base.rating,
        reviews: (data['reviews'] as num?)?.toInt() ?? base.reviews,
      );
    }

    for (final id in deleted) {
      byId.remove(id);
    }

    final result = byId.values.toList()..sort((a, b) => a.id.compareTo(b.id));
    return result;
  }

  List<String> _stringList(Object? value, List<String> fallback) {
    if (value is List) {
      final items = value
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
      if (items.isNotEmpty) return items;
    }
    return fallback;
  }

  Future<void> saveProduct(Sneaker sneaker) {
    return _products.doc('${sneaker.id}').set({
      'id': sneaker.id,
      'name': sneaker.name,
      'brand': sneaker.brand,
      'price': sneaker.price,
      'description': sneaker.description,
      'sizes': sneaker.sizes,
      'colors': sneaker.colors,
      'emoji': sneaker.emoji,
      'imageUrl': sneaker.imageUrl,
      'rating': sneaker.rating,
      'reviews': sneaker.reviews,
      'active': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteProduct(int id) {
    return _products.doc('$id').set({
      'id': id,
      'active': false,
      'deletedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  int nextId(List<Sneaker> sneakers) {
    if (sneakers.isEmpty) return 1;
    return sneakers.map((s) => s.id).reduce((a, b) => a > b ? a : b) + 1;
  }
}
