import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart' hide Order;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pharmacy_app/data/local/dao/cart_item_dao.dart';
import 'package:pharmacy_app/data/local/dao/category_dao.dart';
import 'package:pharmacy_app/data/local/dao/order_dao.dart';
import 'package:pharmacy_app/data/local/dao/order_item_dao.dart';
import 'package:pharmacy_app/data/local/dao/product_dao.dart';
import 'package:pharmacy_app/data/local/dao/user_dao.dart';
import 'package:pharmacy_app/data/local/table/cart_items_table.dart';
import 'package:pharmacy_app/data/local/table/categories_table.dart';
import 'package:pharmacy_app/data/local/table/order_items_table.dart';
import 'package:pharmacy_app/data/local/table/orders_table.dart';
import 'package:pharmacy_app/data/local/table/products_table.dart';
import 'package:pharmacy_app/data/local/table/users_table.dart';

part 'app_database.g.dart';

@singleton
@DriftDatabase(
  tables: [Users, Categories, Products, CartItems, Orders, OrderItems],
  daos: [UserDao, CategoryDao, ProductDao, CartItemDao, OrderDao, OrderItemDao],
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
