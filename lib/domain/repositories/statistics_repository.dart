import 'package:pharmacy_app/data/models/statistics_data.dart';

abstract class StatisticsRepository {
  Future<StatisticsData> getStatistics();
  Future<List<double>> getMonthlyRevenue();
  Future<Map<String, int>> getOrderStatusCount();
  Future<List<TopProductData>> getTopSellingProducts();
  Future<List<int>> getMonthlyUserRegistrations();
  Future<double> getTotalRevenue();
  Future<int> getTotalOrders();
  Future<int> getTotalUsers();
  Future<int> getTotalProducts();
}
