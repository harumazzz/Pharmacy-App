import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/data/models/statistics_data.dart';
import 'package:pharmacy_app/domain/repositories/statistics_repository.dart';
import 'package:pharmacy_app/di/injection.dart';

final statisticsRepositoryProvider = Provider<StatisticsRepository>(
  (ref) => getIt<StatisticsRepository>(),
);

final statisticsProvider = FutureProvider<StatisticsData>((ref) async {
  final repository = ref.read(statisticsRepositoryProvider);
  return repository.getStatistics();
});

final monthlyRevenueProvider = FutureProvider<List<double>>((ref) async {
  final repository = ref.read(statisticsRepositoryProvider);
  return repository.getMonthlyRevenue();
});

final orderStatusProvider = FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.read(statisticsRepositoryProvider);
  return repository.getOrderStatusCount();
});

final topProductsProvider = FutureProvider<List<TopProductData>>((ref) async {
  final repository = ref.read(statisticsRepositoryProvider);
  return repository.getTopSellingProducts();
});
