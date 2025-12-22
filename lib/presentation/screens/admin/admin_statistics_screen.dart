import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pharmacy_app/presentation/providers/statistics_provider.dart';
import 'package:pharmacy_app/data/models/statistics_data.dart';
import 'package:pharmacy_app/utils/excel_export_service.dart';

class AdminStatisticsScreen extends ConsumerWidget {
  const AdminStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statisticsAsync = ref.watch(statisticsProvider);

    return Scaffold(
      body: statisticsAsync.when(
        data: (statistics) => _buildStatisticsContent(context, statistics),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Lỗi: $error', style: const TextStyle(color: Colors.red)),
        ),
      ),
      floatingActionButton: statisticsAsync.when(
        data: (statistics) => FloatingActionButton.extended(
          onPressed: () => _exportToExcel(context, statistics),
          icon: const Icon(Icons.file_download),
          label: const Text('Xuất Excel'),
          backgroundColor: Colors.green,
        ),
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }

  Widget _buildStatisticsContent(
    BuildContext context,
    StatisticsData statistics,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thống kê tổng quan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Cards thống kê tổng quan
          _buildOverviewCards(statistics),

          const SizedBox(height: 30),

          // Biểu đồ doanh thu theo tháng
          _buildRevenueChart(statistics),

          const SizedBox(height: 30),

          // Biểu đồ phân bố đơn hàng theo trạng thái
          _buildOrderStatusChart(statistics),

          const SizedBox(height: 30),

          // Biểu đồ sản phẩm bán chạy
          _buildTopProductsChart(statistics),

          const SizedBox(height: 30),

          // Biểu đồ người dùng đăng ký theo tháng
          _buildUserRegistrationChart(statistics),
        ],
      ),
    );
  }

  Widget _buildOverviewCards(StatisticsData statistics) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Tổng doanh thu',
                '${statistics.totalRevenue.toStringAsFixed(0)}đ',
                Icons.attach_money,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Tổng đơn hàng',
                statistics.totalOrders.toString(),
                Icons.shopping_cart,
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Tổng người dùng',
                statistics.totalUsers.toString(),
                Icons.people,
                Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Tổng sản phẩm',
                statistics.totalProducts.toString(),
                Icons.inventory,
                Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(StatisticsData statistics) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Doanh thu theo tháng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            'T1',
                            'T2',
                            'T3',
                            'T4',
                            'T5',
                            'T6',
                            'T7',
                            'T8',
                            'T9',
                            'T10',
                            'T11',
                            'T12',
                          ];
                          int index = value.toInt();
                          if (index >= 0 && index < months.length) {
                            return Text(months[index]);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${(value / 1000000).toStringAsFixed(0)}M',
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: statistics.monthlyRevenue
                          .asMap()
                          .entries
                          .map(
                            (entry) =>
                                FlSpot(entry.key.toDouble(), entry.value),
                          )
                          .toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusChart(StatisticsData statistics) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Phân bố trạng thái đơn hàng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.green,
                      value: statistics.completedOrders.toDouble(),
                      title: 'Hoàn thành\n${statistics.completedOrders}',
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.orange,
                      value: statistics.pendingOrders.toDouble(),
                      title: 'Chờ xử lý\n${statistics.pendingOrders}',
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.blue,
                      value: statistics.processingOrders.toDouble(),
                      title: 'Đang xử lý\n${statistics.processingOrders}',
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.red,
                      value: statistics.cancelledOrders.toDouble(),
                      title: 'Đã hủy\n${statistics.cancelledOrders}',
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProductsChart(StatisticsData statistics) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top 5 sản phẩm bán chạy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: statistics.topProducts.isNotEmpty
                      ? statistics.topProducts.first.soldQuantity.toDouble() +
                            10
                      : 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 &&
                              index < statistics.topProducts.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                statistics.topProducts[index].name,
                                style: const TextStyle(fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString());
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: statistics.topProducts
                      .asMap()
                      .entries
                      .map(
                        (entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.soldQuantity.toDouble(),
                              color: Colors.purple,
                              width: 20,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRegistrationChart(StatisticsData statistics) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Người dùng đăng ký theo tháng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: statistics.monthlyUserRegistrations.isNotEmpty
                      ? statistics.monthlyUserRegistrations
                                .reduce((a, b) => a > b ? a : b)
                                .toDouble() +
                            5
                      : 50,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            'T1',
                            'T2',
                            'T3',
                            'T4',
                            'T5',
                            'T6',
                            'T7',
                            'T8',
                            'T9',
                            'T10',
                            'T11',
                            'T12',
                          ];
                          int index = value.toInt();
                          if (index >= 0 && index < months.length) {
                            return Text(months[index]);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString());
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: statistics.monthlyUserRegistrations
                      .asMap()
                      .entries
                      .map(
                        (entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.toDouble(),
                              color: Colors.teal,
                              width: 20,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportToExcel(
    BuildContext context,
    StatisticsData statistics,
  ) async {
    // Hiển thị loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Đang xuất file Excel...'),
          ],
        ),
      ),
    );

    try {
      final filePath = await ExcelExportService.exportStatisticsToExcel(
        statistics,
      );

      // Đóng loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (filePath != null) {
        // Hiển thị thông báo thành công
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã xuất file thành công: $filePath'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {},
                textColor: Colors.white,
              ),
            ),
          );
        }
      } else {
        // Hiển thị lỗi
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không thể xuất file Excel. Vui lòng thử lại.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Đóng loading dialog nếu có lỗi
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
