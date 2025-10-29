import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/domain/repositories/order_repository.dart'
    as domain;
import 'package:pharmacy_app/data/models/order.dart' as model;
import 'package:pharmacy_app/data/models/order_item.dart' as model_item;

@LazySingleton(as: domain.OrderRepository)
class OrderRepositoryImpl implements domain.OrderRepository {
  final AppDatabase _db;

  const OrderRepositoryImpl(this._db);

  @override
  Stream<List<model.Order>> watchOrders(int userId) {
    return (_db.select(_db.orders)
          ..where((o) => o.userId.equals(userId))
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .watch()
        .map(
          (orders) => orders
              .map(
                (order) => model.Order(
                  id: order.id,
                  userId: order.userId,
                  totalPrice: order.totalPrice,
                  status: order.status,
                  shippingAddress: order.shippingAddress,
                  createdAt: order.createdAt,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<List<model.Order>> getOrdersForUser(int userId) async {
    final orders = await _db.orderDao.getUserOrders(userId);
    return orders
        .map(
          (order) => model.Order(
            id: order.id,
            userId: order.userId,
            totalPrice: order.totalPrice,
            status: order.status,
            shippingAddress: order.shippingAddress,
            createdAt: order.createdAt,
          ),
        )
        .toList();
  }

  @override
  Future<model.Order> getOrderDetail(int orderId) async {
    final order = await (_db.select(
      _db.orders,
    )..where((o) => o.id.equals(orderId))).getSingle();
    return model.Order(
      id: order.id,
      userId: order.userId,
      totalPrice: order.totalPrice,
      status: order.status,
      shippingAddress: order.shippingAddress,
      createdAt: order.createdAt,
    );
  }

  @override
  Future<void> createOrder(
    model.Order order,
    List<model_item.OrderItem> items,
  ) async {
    await _db.transaction(() async {
      final orderCompanion = OrdersCompanion.insert(
        userId: order.userId,
        totalPrice: order.totalPrice,
        status: order.status,
        shippingAddress: order.shippingAddress,
        createdAt: order.createdAt,
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
}
