import 'package:drift/drift.dart';
import 'connection/connection.dart';

part 'sneaker_db.g.dart';

class DbWishlistItem extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sneakerId => integer()();
  TextColumn get name => text()();
  TextColumn get brand => text()();
  RealColumn get price => real()();
  TextColumn get emoji => text()();
  DateTimeColumn get savedAt => dateTime()();
}

class DbOrder extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get orderNumber => text()();
  RealColumn get totalAmount => real()();
  IntColumn get itemCount => integer()();
  DateTimeColumn get placedAt => dateTime()();
  TextColumn get status => text()();
}

class DbOrderItem extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer()();
  IntColumn get sneakerId => integer()();
  TextColumn get name => text()();
  TextColumn get brand => text()();
  RealColumn get price => real()();
  TextColumn get emoji => text()();
  TextColumn get size => text()();
  IntColumn get quantity => integer()();
}

@DriftDatabase(
  tables: [DbWishlistItem, DbOrder, DbOrderItem],
  daos: [WishlistDao, OrderDao],
)
class SneakerDatabase extends _$SneakerDatabase {
  SneakerDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() => openConnection();

@DriftAccessor(tables: [DbWishlistItem])
class WishlistDao extends DatabaseAccessor<SneakerDatabase>
    with _$WishlistDaoMixin {
  WishlistDao(super.db);

  Stream<List<DbWishlistItemData>> watchAll() => select(dbWishlistItem).watch();

  Future<List<DbWishlistItemData>> findAll() => select(dbWishlistItem).get();

  Future<bool> contains(int sneakerId) async {
    final rows = await (select(dbWishlistItem)
          ..where((t) => t.sneakerId.equals(sneakerId)))
        .get();
    return rows.isNotEmpty;
  }

  Future<int> insert(Insertable<DbWishlistItemData> item) =>
      into(dbWishlistItem).insert(item);

  Future<void> removeBySneakerId(int sneakerId) =>
      (delete(dbWishlistItem)..where((t) => t.sneakerId.equals(sneakerId)))
          .go();

  Future<void> clearAll() => delete(dbWishlistItem).go();
}

@DriftAccessor(tables: [DbOrder, DbOrderItem])
class OrderDao extends DatabaseAccessor<SneakerDatabase> with _$OrderDaoMixin {
  OrderDao(super.db);

  Stream<List<DbOrderData>> watchAll() =>
      (select(dbOrder)..orderBy([(t) => OrderingTerm.desc(t.placedAt)]))
          .watch();

  Future<int> insertOrder(Insertable<DbOrderData> order) =>
      into(dbOrder).insert(order);

  Future<void> insertItems(List<Insertable<DbOrderItemData>> items) async {
    await batch((b) => b.insertAll(dbOrderItem, items));
  }

  Future<List<DbOrderItemData>> itemsForOrder(int orderId) =>
      (select(dbOrderItem)..where((t) => t.orderId.equals(orderId))).get();

  Future<void> deleteOrder(int orderId) async {
    await (delete(dbOrderItem)..where((t) => t.orderId.equals(orderId))).go();
    await (delete(dbOrder)..where((t) => t.id.equals(orderId))).go();
  }
}
