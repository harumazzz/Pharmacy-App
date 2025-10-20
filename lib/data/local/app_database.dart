import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart' hide Order;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pharmacy_app/data/local/table/cart_items_table.dart';
import 'package:pharmacy_app/data/local/table/category_table.dart';
import 'package:pharmacy_app/data/local/table/order_item_table.dart';
import 'package:pharmacy_app/data/local/table/order_table.dart';
import 'package:pharmacy_app/data/local/table/product_table.dart';
import 'package:pharmacy_app/data/local/table/user_table.dart';
import 'package:pharmacy_app/data/models/category.dart';
import 'package:pharmacy_app/data/models/order.dart';
import 'package:pharmacy_app/data/models/order_item.dart';
import 'package:pharmacy_app/data/models/product.dart';
import 'package:pharmacy_app/data/models/user.dart';

part 'app_database.g.dart';

@singleton
@DriftDatabase(
  tables: [Users, Categories, Products, CartItems, Orders, OrderItems],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
