import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistics_data.freezed.dart';
part 'statistics_data.g.dart';

@freezed
sealed class StatisticsData with _$StatisticsData {
  const factory StatisticsData({
    @Default(0.0) double totalRevenue,
    @Default(0) int totalOrders,
    @Default(0) int totalUsers,
    @Default(0) int totalProducts,
    @Default(0) int completedOrders,
    @Default(0) int pendingOrders,
    @Default(0) int processingOrders,
    @Default(0) int cancelledOrders,
    @Default([]) List<double> monthlyRevenue,
    @Default([]) List<int> monthlyUserRegistrations,
    @Default([]) List<TopProductData> topProducts,
  }) = _StatisticsData;

  factory StatisticsData.fromJson(Map<String, dynamic> json) =>
      _$StatisticsDataFromJson(json);
}

@freezed
sealed class TopProductData with _$TopProductData {
  const factory TopProductData({
    required String name,
    required int soldQuantity,
    @Default(0.0) double revenue,
  }) = _TopProductData;

  factory TopProductData.fromJson(Map<String, dynamic> json) =>
      _$TopProductDataFromJson(json);
}
