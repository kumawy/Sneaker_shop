import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sneaker_store/models/admin_product_dao.dart';
import 'package:sneaker_store/models/sneaker.dart';

Sneaker _sneaker({int id = 101, double price = 199.99}) {
  return Sneaker(
    id: id,
    name: 'Admin Test Sneaker',
    brand: 'Nike',
    price: price,
    description: 'Sneaker added from admin panel during test.',
    sizes: const ['39', '40', '41', '42'],
    colors: const ['White', 'Black'],
    emoji: '👟',
    imageUrl: 'https://example.com/admin-test-sneaker.png',
    rating: 4.8,
    reviews: 25,
  );
}

void main() {
  group('AdminProductDao Firebase write tests', () {
    test('saveProduct() writes sneaker to products/{productId}', () async {
      final firestore = FakeFirebaseFirestore();
      final dao = AdminProductDao(firestore: firestore);
      final sneaker = _sneaker(id: 101, price: 199.99);

      await dao.saveProduct(sneaker);

      final doc = await firestore.collection('products').doc('101').get();

      expect(doc.exists, isTrue);
      expect(doc.data()?['id'], 101);
      expect(doc.data()?['name'], 'Admin Test Sneaker');
      expect(doc.data()?['brand'], 'Nike');
      expect(doc.data()?['price'], 199.99);
      expect(doc.data()?['description'], 'Sneaker added from admin panel during test.');
      expect(doc.data()?['sizes'], ['39', '40', '41', '42']);
      expect(doc.data()?['colors'], ['White', 'Black']);
      expect(doc.data()?['emoji'], '👟');
      expect(doc.data()?['imageUrl'], 'https://example.com/admin-test-sneaker.png');
      expect(doc.data()?['rating'], 4.8);
      expect(doc.data()?['reviews'], 25);
      expect(doc.data()?['active'], isTrue);
      expect(doc.data()?['updatedAt'], isNotNull);
    });

    test('saveProduct() can update sneaker price in Firebase', () async {
      final firestore = FakeFirebaseFirestore();
      final dao = AdminProductDao(firestore: firestore);

      await dao.saveProduct(_sneaker(id: 102, price: 199.99));
      await dao.saveProduct(_sneaker(id: 102, price: 149.99));

      final doc = await firestore.collection('products').doc('102').get();

      expect(doc.exists, isTrue);
      expect(doc.data()?['price'], 149.99);
      expect(doc.data()?['active'], isTrue);
    });

    test('deleteProduct() marks sneaker as inactive in Firebase', () async {
      final firestore = FakeFirebaseFirestore();
      final dao = AdminProductDao(firestore: firestore);

      await dao.saveProduct(_sneaker(id: 103));
      await dao.deleteProduct(103);

      final doc = await firestore.collection('products').doc('103').get();

      expect(doc.exists, isTrue);
      expect(doc.data()?['id'], 103);
      expect(doc.data()?['active'], isFalse);
      expect(doc.data()?['deletedAt'], isNotNull);
    });

    test('watchProducts() includes new sneaker from Firebase products collection',
        () async {
      final firestore = FakeFirebaseFirestore();
      final dao = AdminProductDao(firestore: firestore);

      await dao.saveProduct(_sneaker(id: 999, price: 299.99));

      final products = await dao.watchProducts().first;
      final addedSneaker = products.firstWhere((item) => item.id == 999);

      expect(addedSneaker.name, 'Admin Test Sneaker');
      expect(addedSneaker.brand, 'Nike');
      expect(addedSneaker.price, 299.99);
      expect(addedSneaker.imageUrl, 'https://example.com/admin-test-sneaker.png');
    });
  });
}
