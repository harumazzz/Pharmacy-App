import 'package:drift/drift.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/data/local/table/order_items_table.dart';

part 'order_item_dao.g.dart';

@DriftAccessor(tables: [OrderItems])
class OrderItemDao extends DatabaseAccessor<AppDatabase> with _$OrderItemDaoMixin {
  final AppDatabase db;

  OrderItemDao(this.db) : super(db);
}
