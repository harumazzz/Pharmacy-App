import '../../data/models/order.dart';
import '../../data/models/order_item.dart';

abstract class OrderRepository {
  Stream<List<Order>> watchOrders(int userId);
  Future<List<Order>> getOrdersForUser(int userId);
  Future<Order> getOrderDetail(int orderId);
  Future<void> createOrder(Order order, List<OrderItem> items);
}
