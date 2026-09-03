// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sneaker_db.dart';

// ignore_for_file: type=lint
class $DbWishlistItemTable extends DbWishlistItem
    with TableInfo<$DbWishlistItemTable, DbWishlistItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbWishlistItemTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sneakerIdMeta =
      const VerificationMeta('sneakerId');
  @override
  late final GeneratedColumn<int> sneakerId = GeneratedColumn<int>(
      'sneaker_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _savedAtMeta =
      const VerificationMeta('savedAt');
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
      'saved_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, sneakerId, name, brand, price, emoji, savedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_wishlist_item';
  @override
  VerificationContext validateIntegrity(Insertable<DbWishlistItemData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sneaker_id')) {
      context.handle(_sneakerIdMeta,
          sneakerId.isAcceptableOrUnknown(data['sneaker_id']!, _sneakerIdMeta));
    } else if (isInserting) {
      context.missing(_sneakerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
          _emojiMeta, emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta));
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('saved_at')) {
      context.handle(_savedAtMeta,
          savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta));
    } else if (isInserting) {
      context.missing(_savedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbWishlistItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbWishlistItemData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sneakerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sneaker_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji'])!,
      savedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}saved_at'])!,
    );
  }

  @override
  $DbWishlistItemTable createAlias(String alias) {
    return $DbWishlistItemTable(attachedDatabase, alias);
  }
}

class DbWishlistItemData extends DataClass
    implements Insertable<DbWishlistItemData> {
  final int id;
  final int sneakerId;
  final String name;
  final String brand;
  final double price;
  final String emoji;
  final DateTime savedAt;
  const DbWishlistItemData(
      {required this.id,
      required this.sneakerId,
      required this.name,
      required this.brand,
      required this.price,
      required this.emoji,
      required this.savedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sneaker_id'] = Variable<int>(sneakerId);
    map['name'] = Variable<String>(name);
    map['brand'] = Variable<String>(brand);
    map['price'] = Variable<double>(price);
    map['emoji'] = Variable<String>(emoji);
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  DbWishlistItemCompanion toCompanion(bool nullToAbsent) {
    return DbWishlistItemCompanion(
      id: Value(id),
      sneakerId: Value(sneakerId),
      name: Value(name),
      brand: Value(brand),
      price: Value(price),
      emoji: Value(emoji),
      savedAt: Value(savedAt),
    );
  }

  factory DbWishlistItemData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbWishlistItemData(
      id: serializer.fromJson<int>(json['id']),
      sneakerId: serializer.fromJson<int>(json['sneakerId']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String>(json['brand']),
      price: serializer.fromJson<double>(json['price']),
      emoji: serializer.fromJson<String>(json['emoji']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sneakerId': serializer.toJson<int>(sneakerId),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String>(brand),
      'price': serializer.toJson<double>(price),
      'emoji': serializer.toJson<String>(emoji),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  DbWishlistItemData copyWith(
          {int? id,
          int? sneakerId,
          String? name,
          String? brand,
          double? price,
          String? emoji,
          DateTime? savedAt}) =>
      DbWishlistItemData(
        id: id ?? this.id,
        sneakerId: sneakerId ?? this.sneakerId,
        name: name ?? this.name,
        brand: brand ?? this.brand,
        price: price ?? this.price,
        emoji: emoji ?? this.emoji,
        savedAt: savedAt ?? this.savedAt,
      );
  DbWishlistItemData copyWithCompanion(DbWishlistItemCompanion data) {
    return DbWishlistItemData(
      id: data.id.present ? data.id.value : this.id,
      sneakerId: data.sneakerId.present ? data.sneakerId.value : this.sneakerId,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      price: data.price.present ? data.price.value : this.price,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbWishlistItemData(')
          ..write('id: $id, ')
          ..write('sneakerId: $sneakerId, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('price: $price, ')
          ..write('emoji: $emoji, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sneakerId, name, brand, price, emoji, savedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbWishlistItemData &&
          other.id == this.id &&
          other.sneakerId == this.sneakerId &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.price == this.price &&
          other.emoji == this.emoji &&
          other.savedAt == this.savedAt);
}

class DbWishlistItemCompanion extends UpdateCompanion<DbWishlistItemData> {
  final Value<int> id;
  final Value<int> sneakerId;
  final Value<String> name;
  final Value<String> brand;
  final Value<double> price;
  final Value<String> emoji;
  final Value<DateTime> savedAt;
  const DbWishlistItemCompanion({
    this.id = const Value.absent(),
    this.sneakerId = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.price = const Value.absent(),
    this.emoji = const Value.absent(),
    this.savedAt = const Value.absent(),
  });
  DbWishlistItemCompanion.insert({
    this.id = const Value.absent(),
    required int sneakerId,
    required String name,
    required String brand,
    required double price,
    required String emoji,
    required DateTime savedAt,
  })  : sneakerId = Value(sneakerId),
        name = Value(name),
        brand = Value(brand),
        price = Value(price),
        emoji = Value(emoji),
        savedAt = Value(savedAt);
  static Insertable<DbWishlistItemData> custom({
    Expression<int>? id,
    Expression<int>? sneakerId,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<double>? price,
    Expression<String>? emoji,
    Expression<DateTime>? savedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sneakerId != null) 'sneaker_id': sneakerId,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (price != null) 'price': price,
      if (emoji != null) 'emoji': emoji,
      if (savedAt != null) 'saved_at': savedAt,
    });
  }

  DbWishlistItemCompanion copyWith(
      {Value<int>? id,
      Value<int>? sneakerId,
      Value<String>? name,
      Value<String>? brand,
      Value<double>? price,
      Value<String>? emoji,
      Value<DateTime>? savedAt}) {
    return DbWishlistItemCompanion(
      id: id ?? this.id,
      sneakerId: sneakerId ?? this.sneakerId,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      emoji: emoji ?? this.emoji,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sneakerId.present) {
      map['sneaker_id'] = Variable<int>(sneakerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbWishlistItemCompanion(')
          ..write('id: $id, ')
          ..write('sneakerId: $sneakerId, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('price: $price, ')
          ..write('emoji: $emoji, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }
}

class $DbOrderTable extends DbOrder with TableInfo<$DbOrderTable, DbOrderData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbOrderTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderNumberMeta =
      const VerificationMeta('orderNumber');
  @override
  late final GeneratedColumn<String> orderNumber = GeneratedColumn<String>(
      'order_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _itemCountMeta =
      const VerificationMeta('itemCount');
  @override
  late final GeneratedColumn<int> itemCount = GeneratedColumn<int>(
      'item_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _placedAtMeta =
      const VerificationMeta('placedAt');
  @override
  late final GeneratedColumn<DateTime> placedAt = GeneratedColumn<DateTime>(
      'placed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, orderNumber, totalAmount, itemCount, placedAt, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_order';
  @override
  VerificationContext validateIntegrity(Insertable<DbOrderData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_number')) {
      context.handle(
          _orderNumberMeta,
          orderNumber.isAcceptableOrUnknown(
              data['order_number']!, _orderNumberMeta));
    } else if (isInserting) {
      context.missing(_orderNumberMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('item_count')) {
      context.handle(_itemCountMeta,
          itemCount.isAcceptableOrUnknown(data['item_count']!, _itemCountMeta));
    } else if (isInserting) {
      context.missing(_itemCountMeta);
    }
    if (data.containsKey('placed_at')) {
      context.handle(_placedAtMeta,
          placedAt.isAcceptableOrUnknown(data['placed_at']!, _placedAtMeta));
    } else if (isInserting) {
      context.missing(_placedAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbOrderData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbOrderData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_number'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      itemCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_count'])!,
      placedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}placed_at'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $DbOrderTable createAlias(String alias) {
    return $DbOrderTable(attachedDatabase, alias);
  }
}

class DbOrderData extends DataClass implements Insertable<DbOrderData> {
  final int id;
  final String orderNumber;
  final double totalAmount;
  final int itemCount;
  final DateTime placedAt;
  final String status;
  const DbOrderData(
      {required this.id,
      required this.orderNumber,
      required this.totalAmount,
      required this.itemCount,
      required this.placedAt,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_number'] = Variable<String>(orderNumber);
    map['total_amount'] = Variable<double>(totalAmount);
    map['item_count'] = Variable<int>(itemCount);
    map['placed_at'] = Variable<DateTime>(placedAt);
    map['status'] = Variable<String>(status);
    return map;
  }

  DbOrderCompanion toCompanion(bool nullToAbsent) {
    return DbOrderCompanion(
      id: Value(id),
      orderNumber: Value(orderNumber),
      totalAmount: Value(totalAmount),
      itemCount: Value(itemCount),
      placedAt: Value(placedAt),
      status: Value(status),
    );
  }

  factory DbOrderData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbOrderData(
      id: serializer.fromJson<int>(json['id']),
      orderNumber: serializer.fromJson<String>(json['orderNumber']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      itemCount: serializer.fromJson<int>(json['itemCount']),
      placedAt: serializer.fromJson<DateTime>(json['placedAt']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderNumber': serializer.toJson<String>(orderNumber),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'itemCount': serializer.toJson<int>(itemCount),
      'placedAt': serializer.toJson<DateTime>(placedAt),
      'status': serializer.toJson<String>(status),
    };
  }

  DbOrderData copyWith(
          {int? id,
          String? orderNumber,
          double? totalAmount,
          int? itemCount,
          DateTime? placedAt,
          String? status}) =>
      DbOrderData(
        id: id ?? this.id,
        orderNumber: orderNumber ?? this.orderNumber,
        totalAmount: totalAmount ?? this.totalAmount,
        itemCount: itemCount ?? this.itemCount,
        placedAt: placedAt ?? this.placedAt,
        status: status ?? this.status,
      );
  DbOrderData copyWithCompanion(DbOrderCompanion data) {
    return DbOrderData(
      id: data.id.present ? data.id.value : this.id,
      orderNumber:
          data.orderNumber.present ? data.orderNumber.value : this.orderNumber,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      itemCount: data.itemCount.present ? data.itemCount.value : this.itemCount,
      placedAt: data.placedAt.present ? data.placedAt.value : this.placedAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbOrderData(')
          ..write('id: $id, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('itemCount: $itemCount, ')
          ..write('placedAt: $placedAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, orderNumber, totalAmount, itemCount, placedAt, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbOrderData &&
          other.id == this.id &&
          other.orderNumber == this.orderNumber &&
          other.totalAmount == this.totalAmount &&
          other.itemCount == this.itemCount &&
          other.placedAt == this.placedAt &&
          other.status == this.status);
}

class DbOrderCompanion extends UpdateCompanion<DbOrderData> {
  final Value<int> id;
  final Value<String> orderNumber;
  final Value<double> totalAmount;
  final Value<int> itemCount;
  final Value<DateTime> placedAt;
  final Value<String> status;
  const DbOrderCompanion({
    this.id = const Value.absent(),
    this.orderNumber = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.itemCount = const Value.absent(),
    this.placedAt = const Value.absent(),
    this.status = const Value.absent(),
  });
  DbOrderCompanion.insert({
    this.id = const Value.absent(),
    required String orderNumber,
    required double totalAmount,
    required int itemCount,
    required DateTime placedAt,
    required String status,
  })  : orderNumber = Value(orderNumber),
        totalAmount = Value(totalAmount),
        itemCount = Value(itemCount),
        placedAt = Value(placedAt),
        status = Value(status);
  static Insertable<DbOrderData> custom({
    Expression<int>? id,
    Expression<String>? orderNumber,
    Expression<double>? totalAmount,
    Expression<int>? itemCount,
    Expression<DateTime>? placedAt,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderNumber != null) 'order_number': orderNumber,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (itemCount != null) 'item_count': itemCount,
      if (placedAt != null) 'placed_at': placedAt,
      if (status != null) 'status': status,
    });
  }

  DbOrderCompanion copyWith(
      {Value<int>? id,
      Value<String>? orderNumber,
      Value<double>? totalAmount,
      Value<int>? itemCount,
      Value<DateTime>? placedAt,
      Value<String>? status}) {
    return DbOrderCompanion(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      totalAmount: totalAmount ?? this.totalAmount,
      itemCount: itemCount ?? this.itemCount,
      placedAt: placedAt ?? this.placedAt,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderNumber.present) {
      map['order_number'] = Variable<String>(orderNumber.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (itemCount.present) {
      map['item_count'] = Variable<int>(itemCount.value);
    }
    if (placedAt.present) {
      map['placed_at'] = Variable<DateTime>(placedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbOrderCompanion(')
          ..write('id: $id, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('itemCount: $itemCount, ')
          ..write('placedAt: $placedAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $DbOrderItemTable extends DbOrderItem
    with TableInfo<$DbOrderItemTable, DbOrderItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbOrderItemTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
      'order_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sneakerIdMeta =
      const VerificationMeta('sneakerId');
  @override
  late final GeneratedColumn<int> sneakerId = GeneratedColumn<int>(
      'sneaker_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<String> size = GeneratedColumn<String>(
      'size', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, orderId, sneakerId, name, brand, price, emoji, size, quantity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_order_item';
  @override
  VerificationContext validateIntegrity(Insertable<DbOrderItemData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('sneaker_id')) {
      context.handle(_sneakerIdMeta,
          sneakerId.isAcceptableOrUnknown(data['sneaker_id']!, _sneakerIdMeta));
    } else if (isInserting) {
      context.missing(_sneakerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
          _emojiMeta, emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta));
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
          _sizeMeta, size.isAcceptableOrUnknown(data['size']!, _sizeMeta));
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbOrderItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbOrderItemData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_id'])!,
      sneakerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sneaker_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji'])!,
      size: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}size'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
    );
  }

  @override
  $DbOrderItemTable createAlias(String alias) {
    return $DbOrderItemTable(attachedDatabase, alias);
  }
}

class DbOrderItemData extends DataClass implements Insertable<DbOrderItemData> {
  final int id;
  final int orderId;
  final int sneakerId;
  final String name;
  final String brand;
  final double price;
  final String emoji;
  final String size;
  final int quantity;
  const DbOrderItemData(
      {required this.id,
      required this.orderId,
      required this.sneakerId,
      required this.name,
      required this.brand,
      required this.price,
      required this.emoji,
      required this.size,
      required this.quantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['sneaker_id'] = Variable<int>(sneakerId);
    map['name'] = Variable<String>(name);
    map['brand'] = Variable<String>(brand);
    map['price'] = Variable<double>(price);
    map['emoji'] = Variable<String>(emoji);
    map['size'] = Variable<String>(size);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  DbOrderItemCompanion toCompanion(bool nullToAbsent) {
    return DbOrderItemCompanion(
      id: Value(id),
      orderId: Value(orderId),
      sneakerId: Value(sneakerId),
      name: Value(name),
      brand: Value(brand),
      price: Value(price),
      emoji: Value(emoji),
      size: Value(size),
      quantity: Value(quantity),
    );
  }

  factory DbOrderItemData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbOrderItemData(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      sneakerId: serializer.fromJson<int>(json['sneakerId']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String>(json['brand']),
      price: serializer.fromJson<double>(json['price']),
      emoji: serializer.fromJson<String>(json['emoji']),
      size: serializer.fromJson<String>(json['size']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'sneakerId': serializer.toJson<int>(sneakerId),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String>(brand),
      'price': serializer.toJson<double>(price),
      'emoji': serializer.toJson<String>(emoji),
      'size': serializer.toJson<String>(size),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  DbOrderItemData copyWith(
          {int? id,
          int? orderId,
          int? sneakerId,
          String? name,
          String? brand,
          double? price,
          String? emoji,
          String? size,
          int? quantity}) =>
      DbOrderItemData(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        sneakerId: sneakerId ?? this.sneakerId,
        name: name ?? this.name,
        brand: brand ?? this.brand,
        price: price ?? this.price,
        emoji: emoji ?? this.emoji,
        size: size ?? this.size,
        quantity: quantity ?? this.quantity,
      );
  DbOrderItemData copyWithCompanion(DbOrderItemCompanion data) {
    return DbOrderItemData(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      sneakerId: data.sneakerId.present ? data.sneakerId.value : this.sneakerId,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      price: data.price.present ? data.price.value : this.price,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      size: data.size.present ? data.size.value : this.size,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbOrderItemData(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('sneakerId: $sneakerId, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('price: $price, ')
          ..write('emoji: $emoji, ')
          ..write('size: $size, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, orderId, sneakerId, name, brand, price, emoji, size, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbOrderItemData &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.sneakerId == this.sneakerId &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.price == this.price &&
          other.emoji == this.emoji &&
          other.size == this.size &&
          other.quantity == this.quantity);
}

class DbOrderItemCompanion extends UpdateCompanion<DbOrderItemData> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int> sneakerId;
  final Value<String> name;
  final Value<String> brand;
  final Value<double> price;
  final Value<String> emoji;
  final Value<String> size;
  final Value<int> quantity;
  const DbOrderItemCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.sneakerId = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.price = const Value.absent(),
    this.emoji = const Value.absent(),
    this.size = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  DbOrderItemCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required int sneakerId,
    required String name,
    required String brand,
    required double price,
    required String emoji,
    required String size,
    required int quantity,
  })  : orderId = Value(orderId),
        sneakerId = Value(sneakerId),
        name = Value(name),
        brand = Value(brand),
        price = Value(price),
        emoji = Value(emoji),
        size = Value(size),
        quantity = Value(quantity);
  static Insertable<DbOrderItemData> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? sneakerId,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<double>? price,
    Expression<String>? emoji,
    Expression<String>? size,
    Expression<int>? quantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (sneakerId != null) 'sneaker_id': sneakerId,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (price != null) 'price': price,
      if (emoji != null) 'emoji': emoji,
      if (size != null) 'size': size,
      if (quantity != null) 'quantity': quantity,
    });
  }

  DbOrderItemCompanion copyWith(
      {Value<int>? id,
      Value<int>? orderId,
      Value<int>? sneakerId,
      Value<String>? name,
      Value<String>? brand,
      Value<double>? price,
      Value<String>? emoji,
      Value<String>? size,
      Value<int>? quantity}) {
    return DbOrderItemCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      sneakerId: sneakerId ?? this.sneakerId,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      emoji: emoji ?? this.emoji,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (sneakerId.present) {
      map['sneaker_id'] = Variable<int>(sneakerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (size.present) {
      map['size'] = Variable<String>(size.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbOrderItemCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('sneakerId: $sneakerId, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('price: $price, ')
          ..write('emoji: $emoji, ')
          ..write('size: $size, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

abstract class _$SneakerDatabase extends GeneratedDatabase {
  _$SneakerDatabase(QueryExecutor e) : super(e);
  $SneakerDatabaseManager get managers => $SneakerDatabaseManager(this);
  late final $DbWishlistItemTable dbWishlistItem = $DbWishlistItemTable(this);
  late final $DbOrderTable dbOrder = $DbOrderTable(this);
  late final $DbOrderItemTable dbOrderItem = $DbOrderItemTable(this);
  late final WishlistDao wishlistDao = WishlistDao(this as SneakerDatabase);
  late final OrderDao orderDao = OrderDao(this as SneakerDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [dbWishlistItem, dbOrder, dbOrderItem];
}

typedef $$DbWishlistItemTableCreateCompanionBuilder = DbWishlistItemCompanion
    Function({
  Value<int> id,
  required int sneakerId,
  required String name,
  required String brand,
  required double price,
  required String emoji,
  required DateTime savedAt,
});
typedef $$DbWishlistItemTableUpdateCompanionBuilder = DbWishlistItemCompanion
    Function({
  Value<int> id,
  Value<int> sneakerId,
  Value<String> name,
  Value<String> brand,
  Value<double> price,
  Value<String> emoji,
  Value<DateTime> savedAt,
});

class $$DbWishlistItemTableFilterComposer
    extends Composer<_$SneakerDatabase, $DbWishlistItemTable> {
  $$DbWishlistItemTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sneakerId => $composableBuilder(
      column: $table.sneakerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
      column: $table.savedAt, builder: (column) => ColumnFilters(column));
}

class $$DbWishlistItemTableOrderingComposer
    extends Composer<_$SneakerDatabase, $DbWishlistItemTable> {
  $$DbWishlistItemTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sneakerId => $composableBuilder(
      column: $table.sneakerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
      column: $table.savedAt, builder: (column) => ColumnOrderings(column));
}

class $$DbWishlistItemTableAnnotationComposer
    extends Composer<_$SneakerDatabase, $DbWishlistItemTable> {
  $$DbWishlistItemTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sneakerId =>
      $composableBuilder(column: $table.sneakerId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);
}

class $$DbWishlistItemTableTableManager extends RootTableManager<
    _$SneakerDatabase,
    $DbWishlistItemTable,
    DbWishlistItemData,
    $$DbWishlistItemTableFilterComposer,
    $$DbWishlistItemTableOrderingComposer,
    $$DbWishlistItemTableAnnotationComposer,
    $$DbWishlistItemTableCreateCompanionBuilder,
    $$DbWishlistItemTableUpdateCompanionBuilder,
    (
      DbWishlistItemData,
      BaseReferences<_$SneakerDatabase, $DbWishlistItemTable,
          DbWishlistItemData>
    ),
    DbWishlistItemData,
    PrefetchHooks Function()> {
  $$DbWishlistItemTableTableManager(
      _$SneakerDatabase db, $DbWishlistItemTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbWishlistItemTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbWishlistItemTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbWishlistItemTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sneakerId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> brand = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<DateTime> savedAt = const Value.absent(),
          }) =>
              DbWishlistItemCompanion(
            id: id,
            sneakerId: sneakerId,
            name: name,
            brand: brand,
            price: price,
            emoji: emoji,
            savedAt: savedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sneakerId,
            required String name,
            required String brand,
            required double price,
            required String emoji,
            required DateTime savedAt,
          }) =>
              DbWishlistItemCompanion.insert(
            id: id,
            sneakerId: sneakerId,
            name: name,
            brand: brand,
            price: price,
            emoji: emoji,
            savedAt: savedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DbWishlistItemTableProcessedTableManager = ProcessedTableManager<
    _$SneakerDatabase,
    $DbWishlistItemTable,
    DbWishlistItemData,
    $$DbWishlistItemTableFilterComposer,
    $$DbWishlistItemTableOrderingComposer,
    $$DbWishlistItemTableAnnotationComposer,
    $$DbWishlistItemTableCreateCompanionBuilder,
    $$DbWishlistItemTableUpdateCompanionBuilder,
    (
      DbWishlistItemData,
      BaseReferences<_$SneakerDatabase, $DbWishlistItemTable,
          DbWishlistItemData>
    ),
    DbWishlistItemData,
    PrefetchHooks Function()>;
typedef $$DbOrderTableCreateCompanionBuilder = DbOrderCompanion Function({
  Value<int> id,
  required String orderNumber,
  required double totalAmount,
  required int itemCount,
  required DateTime placedAt,
  required String status,
});
typedef $$DbOrderTableUpdateCompanionBuilder = DbOrderCompanion Function({
  Value<int> id,
  Value<String> orderNumber,
  Value<double> totalAmount,
  Value<int> itemCount,
  Value<DateTime> placedAt,
  Value<String> status,
});

class $$DbOrderTableFilterComposer
    extends Composer<_$SneakerDatabase, $DbOrderTable> {
  $$DbOrderTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderNumber => $composableBuilder(
      column: $table.orderNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get itemCount => $composableBuilder(
      column: $table.itemCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get placedAt => $composableBuilder(
      column: $table.placedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$DbOrderTableOrderingComposer
    extends Composer<_$SneakerDatabase, $DbOrderTable> {
  $$DbOrderTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderNumber => $composableBuilder(
      column: $table.orderNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get itemCount => $composableBuilder(
      column: $table.itemCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get placedAt => $composableBuilder(
      column: $table.placedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$DbOrderTableAnnotationComposer
    extends Composer<_$SneakerDatabase, $DbOrderTable> {
  $$DbOrderTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderNumber => $composableBuilder(
      column: $table.orderNumber, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<int> get itemCount =>
      $composableBuilder(column: $table.itemCount, builder: (column) => column);

  GeneratedColumn<DateTime> get placedAt =>
      $composableBuilder(column: $table.placedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$DbOrderTableTableManager extends RootTableManager<
    _$SneakerDatabase,
    $DbOrderTable,
    DbOrderData,
    $$DbOrderTableFilterComposer,
    $$DbOrderTableOrderingComposer,
    $$DbOrderTableAnnotationComposer,
    $$DbOrderTableCreateCompanionBuilder,
    $$DbOrderTableUpdateCompanionBuilder,
    (
      DbOrderData,
      BaseReferences<_$SneakerDatabase, $DbOrderTable, DbOrderData>
    ),
    DbOrderData,
    PrefetchHooks Function()> {
  $$DbOrderTableTableManager(_$SneakerDatabase db, $DbOrderTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbOrderTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbOrderTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbOrderTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> orderNumber = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<int> itemCount = const Value.absent(),
            Value<DateTime> placedAt = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              DbOrderCompanion(
            id: id,
            orderNumber: orderNumber,
            totalAmount: totalAmount,
            itemCount: itemCount,
            placedAt: placedAt,
            status: status,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String orderNumber,
            required double totalAmount,
            required int itemCount,
            required DateTime placedAt,
            required String status,
          }) =>
              DbOrderCompanion.insert(
            id: id,
            orderNumber: orderNumber,
            totalAmount: totalAmount,
            itemCount: itemCount,
            placedAt: placedAt,
            status: status,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DbOrderTableProcessedTableManager = ProcessedTableManager<
    _$SneakerDatabase,
    $DbOrderTable,
    DbOrderData,
    $$DbOrderTableFilterComposer,
    $$DbOrderTableOrderingComposer,
    $$DbOrderTableAnnotationComposer,
    $$DbOrderTableCreateCompanionBuilder,
    $$DbOrderTableUpdateCompanionBuilder,
    (
      DbOrderData,
      BaseReferences<_$SneakerDatabase, $DbOrderTable, DbOrderData>
    ),
    DbOrderData,
    PrefetchHooks Function()>;
typedef $$DbOrderItemTableCreateCompanionBuilder = DbOrderItemCompanion
    Function({
  Value<int> id,
  required int orderId,
  required int sneakerId,
  required String name,
  required String brand,
  required double price,
  required String emoji,
  required String size,
  required int quantity,
});
typedef $$DbOrderItemTableUpdateCompanionBuilder = DbOrderItemCompanion
    Function({
  Value<int> id,
  Value<int> orderId,
  Value<int> sneakerId,
  Value<String> name,
  Value<String> brand,
  Value<double> price,
  Value<String> emoji,
  Value<String> size,
  Value<int> quantity,
});

class $$DbOrderItemTableFilterComposer
    extends Composer<_$SneakerDatabase, $DbOrderItemTable> {
  $$DbOrderItemTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sneakerId => $composableBuilder(
      column: $table.sneakerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get size => $composableBuilder(
      column: $table.size, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));
}

class $$DbOrderItemTableOrderingComposer
    extends Composer<_$SneakerDatabase, $DbOrderItemTable> {
  $$DbOrderItemTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sneakerId => $composableBuilder(
      column: $table.sneakerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get size => $composableBuilder(
      column: $table.size, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));
}

class $$DbOrderItemTableAnnotationComposer
    extends Composer<_$SneakerDatabase, $DbOrderItemTable> {
  $$DbOrderItemTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<int> get sneakerId =>
      $composableBuilder(column: $table.sneakerId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);
}

class $$DbOrderItemTableTableManager extends RootTableManager<
    _$SneakerDatabase,
    $DbOrderItemTable,
    DbOrderItemData,
    $$DbOrderItemTableFilterComposer,
    $$DbOrderItemTableOrderingComposer,
    $$DbOrderItemTableAnnotationComposer,
    $$DbOrderItemTableCreateCompanionBuilder,
    $$DbOrderItemTableUpdateCompanionBuilder,
    (
      DbOrderItemData,
      BaseReferences<_$SneakerDatabase, $DbOrderItemTable, DbOrderItemData>
    ),
    DbOrderItemData,
    PrefetchHooks Function()> {
  $$DbOrderItemTableTableManager(_$SneakerDatabase db, $DbOrderItemTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbOrderItemTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbOrderItemTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbOrderItemTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> orderId = const Value.absent(),
            Value<int> sneakerId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> brand = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<String> size = const Value.absent(),
            Value<int> quantity = const Value.absent(),
          }) =>
              DbOrderItemCompanion(
            id: id,
            orderId: orderId,
            sneakerId: sneakerId,
            name: name,
            brand: brand,
            price: price,
            emoji: emoji,
            size: size,
            quantity: quantity,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int orderId,
            required int sneakerId,
            required String name,
            required String brand,
            required double price,
            required String emoji,
            required String size,
            required int quantity,
          }) =>
              DbOrderItemCompanion.insert(
            id: id,
            orderId: orderId,
            sneakerId: sneakerId,
            name: name,
            brand: brand,
            price: price,
            emoji: emoji,
            size: size,
            quantity: quantity,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DbOrderItemTableProcessedTableManager = ProcessedTableManager<
    _$SneakerDatabase,
    $DbOrderItemTable,
    DbOrderItemData,
    $$DbOrderItemTableFilterComposer,
    $$DbOrderItemTableOrderingComposer,
    $$DbOrderItemTableAnnotationComposer,
    $$DbOrderItemTableCreateCompanionBuilder,
    $$DbOrderItemTableUpdateCompanionBuilder,
    (
      DbOrderItemData,
      BaseReferences<_$SneakerDatabase, $DbOrderItemTable, DbOrderItemData>
    ),
    DbOrderItemData,
    PrefetchHooks Function()>;

class $SneakerDatabaseManager {
  final _$SneakerDatabase _db;
  $SneakerDatabaseManager(this._db);
  $$DbWishlistItemTableTableManager get dbWishlistItem =>
      $$DbWishlistItemTableTableManager(_db, _db.dbWishlistItem);
  $$DbOrderTableTableManager get dbOrder =>
      $$DbOrderTableTableManager(_db, _db.dbOrder);
  $$DbOrderItemTableTableManager get dbOrderItem =>
      $$DbOrderItemTableTableManager(_db, _db.dbOrderItem);
}

mixin _$WishlistDaoMixin on DatabaseAccessor<SneakerDatabase> {
  $DbWishlistItemTable get dbWishlistItem => attachedDatabase.dbWishlistItem;
  WishlistDaoManager get managers => WishlistDaoManager(this);
}

class WishlistDaoManager {
  final _$WishlistDaoMixin _db;
  WishlistDaoManager(this._db);
  $$DbWishlistItemTableTableManager get dbWishlistItem =>
      $$DbWishlistItemTableTableManager(
          _db.attachedDatabase, _db.dbWishlistItem);
}

mixin _$OrderDaoMixin on DatabaseAccessor<SneakerDatabase> {
  $DbOrderTable get dbOrder => attachedDatabase.dbOrder;
  $DbOrderItemTable get dbOrderItem => attachedDatabase.dbOrderItem;
  OrderDaoManager get managers => OrderDaoManager(this);
}

class OrderDaoManager {
  final _$OrderDaoMixin _db;
  OrderDaoManager(this._db);
  $$DbOrderTableTableManager get dbOrder =>
      $$DbOrderTableTableManager(_db.attachedDatabase, _db.dbOrder);
  $$DbOrderItemTableTableManager get dbOrderItem =>
      $$DbOrderItemTableTableManager(_db.attachedDatabase, _db.dbOrderItem);
}
