import 'package:drift/drift.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/data/local/table/orders_table.dart';

part 'order_dao.g.dart';

@DriftAccessor(tables: [Orders])
class OrderDao extends DatabaseAccessor<AppDatabase> with _$OrderDaoMixin {
  final AppDatabase db;

  OrderDao(this.db) : super(db);

  Future<Order> createOrder(OrdersCompanion order) =>
      into(orders).insertReturning(order);

  Future<List<Order>> getUserOrders(int userId) {
    return (select(orders)
          ..where((o) => o.userId.equals(userId))
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .get();
  }

  Future<List<Order>> getAllOrders() {
    return (select(orders)..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .get();
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) {
    return (update(orders)..where((o) => o.id.equals(orderId))).write(
      OrdersCompanion(status: Value(newStatus)),
    );
  }
}
