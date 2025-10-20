import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart' hide Order;
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/data/models/order.dart';
import 'package:pharmacy_app/data/models/order_item.dart';

@lazySingleton
class OrderRepository {
  final AppDatabase _db;

  const OrderRepository(this._db);

  Future<void> createOrder(Order order, List<OrderItem> items) async {
    await _db.transaction(() async {
      final orderCompanion = OrdersCompanion.insert(
        userId: order.userId,
        totalPrice: order.totalPrice,
        status: order.status,
        shippingAddress: order.shippingAddress,
        createdAt: Value(order.createdAt),
      );
      final newOrder = await _db
          .into(_db.orders)
          .insertReturning(orderCompanion);
      for (final item in items) {
        final itemCompanion = OrderItemsCompanion.insert(
          orderId: newOrder.id,
          productId: item.productId,
          quantity: item.quantity,
          price: item.price,
        );
        await _db.into(_db.orderItems).insert(itemCompanion);
      }
    });
  }

  Future<List<Order>> getUserOrders(int userId) {
    return (_db.select(_db.orders)
          ..where((o) => o.userId.equals(userId))
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .get();
  }

  Future<List<OrderItem>> getOrderDetails(int orderId) {
    return (_db.select(
      _db.orderItems,
    )..where((oi) => oi.orderId.equals(orderId))).get();
  }

  Future<List<Order>> getAllOrders() {
    return (_db.select(
      _db.orders,
    )..orderBy([(o) => OrderingTerm.desc(o.createdAt)])).get();
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) {
    return (_db.update(_db.orders)..where((o) => o.id.equals(orderId))).write(
      OrdersCompanion(status: Value(newStatus)),
    );
  }
}
