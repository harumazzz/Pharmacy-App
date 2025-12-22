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
          ..where((o) => o.userId.equals(userId) & o.deletedAt.isNull())
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .get();
  }

  Future<List<Order>> getAllOrders() {
    return (select(orders)
          ..where((o) => o.deletedAt.isNull())
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .get();
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) {
    return (update(orders)..where((o) => o.id.equals(orderId))).write(
      OrdersCompanion(status: Value(newStatus)),
    );
  }

  Future<int> softDeleteOrder(int id) =>
      (update(orders)..where((o) => o.id.equals(id))).write(
        OrdersCompanion(deletedAt: Value(DateTime.now())),
      );

  Future<int> permanentlyDeleteOrder(int id) =>
      (delete(orders)..where((o) => o.id.equals(id))).go();

  Future<int> restoreOrder(int id) =>
      (update(orders)..where((o) => o.id.equals(id))).write(
        const OrdersCompanion(deletedAt: Value(null)),
      );

  Future<List<Order>> getDeletedOrders() =>
      (select(orders)..where((o) => o.deletedAt.isNotNull())).get();

  Stream<List<Order>> getUserOrdersStream(int userId) {
    return (select(orders)
          ..where((o) => o.userId.equals(userId) & o.deletedAt.isNull())
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .watch();
  }

  Stream<List<Order>> getAllOrdersStream() {
    return (select(orders)
          ..where((o) => o.deletedAt.isNull())
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .watch();
  }

  Stream<List<Order>> getDeletedOrdersStream() =>
      (select(orders)..where((o) => o.deletedAt.isNotNull())).watch();
}
