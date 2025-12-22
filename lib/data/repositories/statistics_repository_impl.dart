import 'package:injectable/injectable.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/data/models/statistics_data.dart';
import 'package:pharmacy_app/domain/repositories/statistics_repository.dart';
import 'package:drift/drift.dart';

@LazySingleton(as: StatisticsRepository)
class StatisticsRepositoryImpl implements StatisticsRepository {
  final AppDatabase _database;

  StatisticsRepositoryImpl(this._database);

  @override
  Future<StatisticsData> getStatistics() async {
    final totalRevenue = await getTotalRevenue();
    final totalOrders = await getTotalOrders();
    final totalUsers = await getTotalUsers();
    final totalProducts = await getTotalProducts();
    final monthlyRevenue = await getMonthlyRevenue();
    final monthlyUserRegistrations = await getMonthlyUserRegistrations();
    final topProducts = await getTopSellingProducts();
    final orderStatusCount = await getOrderStatusCount();

    return StatisticsData(
      totalRevenue: totalRevenue,
      totalOrders: totalOrders,
      totalUsers: totalUsers,
      totalProducts: totalProducts,
      monthlyRevenue: monthlyRevenue,
      monthlyUserRegistrations: monthlyUserRegistrations,
      topProducts: topProducts,
      completedOrders: orderStatusCount['completed'] ?? 0,
      pendingOrders: orderStatusCount['pending'] ?? 0,
      processingOrders: orderStatusCount['processing'] ?? 0,
      cancelledOrders: orderStatusCount['cancelled'] ?? 0,
    );
  }

  @override
  Future<double> getTotalRevenue() async {
    final query = _database.select(_database.orders)
      ..where((order) => order.status.equals('completed'));

    final orders = await query.get();
    double total = 0.0;

    for (final order in orders) {
      total += order.totalPrice;
    }

    return total;
  }

  @override
  Future<int> getTotalOrders() async {
    final result = await (_database.selectOnly(
      _database.orders,
    )..addColumns([_database.orders.id.count()])).getSingle();
    return result.read(_database.orders.id.count()) ?? 0;
  }

  @override
  Future<int> getTotalUsers() async {
    final result = await (_database.selectOnly(
      _database.users,
    )..addColumns([_database.users.id.count()])).getSingle();
    return result.read(_database.users.id.count()) ?? 0;
  }

  @override
  Future<int> getTotalProducts() async {
    final result = await (_database.selectOnly(
      _database.products,
    )..addColumns([_database.products.id.count()])).getSingle();
    return result.read(_database.products.id.count()) ?? 0;
  }

  @override
  Future<List<double>> getMonthlyRevenue() async {
    final now = DateTime.now();
    final List<double> monthlyRevenue = List.filled(12, 0.0);

    for (int month = 1; month <= 12; month++) {
      final startDate = DateTime(now.year, month, 1);
      final endDate = DateTime(
        now.year,
        month + 1,
        1,
      ).subtract(const Duration(days: 1));

      final query = _database.select(_database.orders)
        ..where(
          (order) =>
              order.status.equals('completed') &
              order.createdAt.isBiggerOrEqualValue(startDate) &
              order.createdAt.isSmallerOrEqualValue(endDate),
        );

      final orders = await query.get();
      double monthTotal = 0.0;

      for (final order in orders) {
        monthTotal += order.totalPrice;
      }

      monthlyRevenue[month - 1] = monthTotal;
    }

    return monthlyRevenue;
  }

  @override
  Future<Map<String, int>> getOrderStatusCount() async {
    final pendingQuery = _database.select(_database.orders)
      ..where((order) => order.status.equals('pending'));
    final pendingCount = (await pendingQuery.get()).length;

    final processingQuery = _database.select(_database.orders)
      ..where((order) => order.status.equals('processing'));
    final processingCount = (await processingQuery.get()).length;

    final completedQuery = _database.select(_database.orders)
      ..where((order) => order.status.equals('completed'));
    final completedCount = (await completedQuery.get()).length;

    final cancelledQuery = _database.select(_database.orders)
      ..where((order) => order.status.equals('cancelled'));
    final cancelledCount = (await cancelledQuery.get()).length;

    return {
      'pending': pendingCount,
      'processing': processingCount,
      'completed': completedCount,
      'cancelled': cancelledCount,
    };
  }

  @override
  Future<List<TopProductData>> getTopSellingProducts() async {
    // Lấy tất cả order items từ các đơn hàng đã hoàn thành
    final query = _database.select(_database.orderItems).join([
      leftOuterJoin(
        _database.orders,
        _database.orders.id.equalsExp(_database.orderItems.orderId),
      ),
      leftOuterJoin(
        _database.products,
        _database.products.id.equalsExp(_database.orderItems.productId),
      ),
    ])..where(_database.orders.status.equals('completed'));

    final results = await query.get();

    // Tính tổng số lượng bán cho mỗi sản phẩm
    final Map<String, TopProductData> productSales = {};

    for (final result in results) {
      final orderItem = result.readTable(_database.orderItems);
      final product = result.readTable(_database.products);

      final productName = product.name;
      final quantity = orderItem.quantity;
      final price = orderItem.price;

      if (productSales.containsKey(productName)) {
        final existing = productSales[productName]!;
        productSales[productName] = existing.copyWith(
          soldQuantity: existing.soldQuantity + quantity,
          revenue: existing.revenue + (price * quantity),
        );
      } else {
        productSales[productName] = TopProductData(
          name: productName,
          soldQuantity: quantity,
          revenue: price * quantity,
        );
      }
    }

    // Sắp xếp theo số lượng bán và lấy top 5
    final sortedProducts = productSales.values.toList()
      ..sort((a, b) => b.soldQuantity.compareTo(a.soldQuantity));

    return sortedProducts.take(5).toList();
  }

  @override
  Future<List<int>> getMonthlyUserRegistrations() async {
    final now = DateTime.now();
    final List<int> monthlyRegistrations = List.filled(12, 0);

    for (int month = 1; month <= 12; month++) {
      final startDate = DateTime(now.year, month, 1);
      final endDate = DateTime(
        now.year,
        month + 1,
        1,
      ).subtract(const Duration(days: 1));

      final query = _database.select(_database.users)
        ..where(
          (user) =>
              user.createdAt.isBiggerOrEqualValue(startDate) &
              user.createdAt.isSmallerOrEqualValue(endDate),
        );

      final users = await query.get();
      monthlyRegistrations[month - 1] = users.length;
    }

    return monthlyRegistrations;
  }
}
