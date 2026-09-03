import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/favourite_item.dart';
import '../models/user_dao.dart';

class FavouriteDao {
  FavouriteDao(this.userDao, {FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final UserDao userDao;
  final FirebaseFirestore _firestore;

  CollectionReference? _collection() {
    final uid = userDao.userId();
    if (uid == null) return null;
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('favourites');
  }

  Stream<List<FavouriteItem>> getFavouritesStream() {
    final col = _collection();
    if (col == null) return const Stream.empty();

    return col.orderBy('savedAt', descending: true).snapshots().map((snap) =>
        snap.docs.map((doc) => FavouriteItem.fromSnapshot(doc)).toList());
  }

  Stream<bool> isFavouriteStream(int sneakerId) {
    final col = _collection();
    if (col == null) return Stream.value(false);

    return col.doc('$sneakerId').snapshots().map((snap) => snap.exists);
  }

  Future<void> addFavourite(FavouriteItem item) async {
    final col = _collection();
    if (col == null) throw Exception('Not logged in.');

    await col.doc('${item.sneakerId}').set(item.toJson());
  }

  Future<void> removeFavourite(int sneakerId) async {
    final col = _collection();
    if (col == null) throw Exception('Not logged in.');

    await col.doc('$sneakerId').delete();
  }

  Future<bool> toggleFavourite(FavouriteItem item) async {
    final col = _collection();
    if (col == null) throw Exception('Not logged in.');

    final doc = col.doc('${item.sneakerId}');
    final snap = await doc.get();

    if (snap.exists) {
      await doc.delete();
      return false;
    } else {
      await doc.set(item.toJson());
      return true;
    }
  }
}
