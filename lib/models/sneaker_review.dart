// Reviews are stored in Firestore collection: reviews/{sneakerId}/items

import 'package:cloud_firestore/cloud_firestore.dart';

class SneakerReview {
  SneakerReview({
    required this.sneakerId,
    required this.email,
    required this.text,
    required this.rating,
    required this.date,
    required this.userId,
    this.reference,
  });

  final int sneakerId;
  final String email;
  final String text;
  final double rating; // 1–5
  final DateTime date;
  final String userId;
  final DocumentReference? reference;

  factory SneakerReview.fromJson(Map<String, dynamic> json) {
    final rawDate = json['date'] ?? json['createdAt'];
    final rawText = json['text'] ?? json['comment'] ?? '';
    final rawEmail = json['email'] ?? json['userEmail'] ?? 'anonymous';

    DateTime parsedDate;
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is DateTime) {
      parsedDate = rawDate;
    } else {
      parsedDate = DateTime.now();
    }

    return SneakerReview(
      sneakerId: (json['sneakerId'] as num).toInt(),
      email: rawEmail as String,
      text: rawText as String,
      rating: (json['rating'] as num).toDouble(),
      date: parsedDate,
      userId: (json['userId'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'sneakerId': sneakerId,
        'email': email,
        'text': text,
        'rating': rating,
        'date': Timestamp.fromDate(date),
        'userId': userId,
      };

  factory SneakerReview.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    final review = SneakerReview.fromJson(data);

    return SneakerReview(
      sneakerId: review.sneakerId,
      email: review.email,
      text: review.text,
      rating: review.rating,
      date: review.date,
      userId: review.userId,
      reference: snapshot.reference,
    );
  }
}
