// Favourites are stored per-user in Firestore:
//   users/{userId}/favourites/{sneakerId}

import 'package:cloud_firestore/cloud_firestore.dart';

class FavouriteItem {
  FavouriteItem({
    required this.sneakerId,
    required this.name,
    required this.brand,
    required this.price,
    required this.emoji,
    required this.savedAt,
    this.imageUrl,
    this.reference,
  });

  final int sneakerId;
  final String name;
  final String brand;
  final double price;
  final String emoji;
  final DateTime savedAt;
  final String? imageUrl;
  final DocumentReference? reference;

  factory FavouriteItem.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    final rawDate = data['savedAt'];
    DateTime parsedDate;
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else {
      parsedDate = DateTime.now();
    }

    return FavouriteItem(
      sneakerId: (data['sneakerId'] as num).toInt(),
      name: data['name'] as String? ?? '',
      brand: data['brand'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      emoji: data['emoji'] as String? ?? '👟',
      savedAt: parsedDate,
      imageUrl: data['imageUrl'] as String?,
      reference: snapshot.reference,
    );
  }

  Map<String, dynamic> toJson() => {
        'sneakerId': sneakerId,
        'name': name,
        'brand': brand,
        'price': price,
        'emoji': emoji,
        'imageUrl': imageUrl,
        'savedAt': Timestamp.fromDate(savedAt),
      };
}
