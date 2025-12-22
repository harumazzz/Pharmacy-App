import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/data/models/statistics_data.dart';
import 'package:intl/intl.dart';

class ExcelExportService {
  static Future<String?> exportStatisticsToExcel(
    StatisticsData statistics,
  ) async {
    try {
      // Kiểm tra permission
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
          if (!status.isGranted) {
            return null;
          }
        }
      }

      // Tạo Excel workbook
      var excel = Excel.createExcel();

      // Xóa sheet mặc định
      excel.delete('Sheet1');

      // Tạo sheet tổng quan
      Sheet overviewSheet = excel['Tong_Quan'];
      _createOverviewSheet(overviewSheet, statistics);

      // Tạo sheet doanh thu theo tháng
      Sheet revenueSheet = excel['Doanh_Thu_Thang'];
      _createRevenueSheet(revenueSheet, statistics);

      // Tạo sheet trạng thái đơn hàng
      Sheet orderStatusSheet = excel['Trang_Thai_Don_Hang'];
      _createOrderStatusSheet(orderStatusSheet, statistics);

      // Tạo sheet sản phẩm bán chạy
      Sheet topProductsSheet = excel['San_Pham_Ban_Chay'];
      _createTopProductsSheet(topProductsSheet, statistics);

      // Tạo sheet đăng ký người dùng
      Sheet userRegistrationSheet = excel['Dang_Ky_Nguoi_Dung'];
      _createUserRegistrationSheet(userRegistrationSheet, statistics);

      // Lưu file
      final directory = Platform.isAndroid
          ? Directory('/storage/emulated/0/Download')
          : await getApplicationDocumentsDirectory();

      final fileName =
          'Thong_Ke_Pharmacy_${DateFormat('dd_MM_yyyy_HH_mm').format(DateTime.now())}.xlsx';
      final filePath = '${directory.path}/$fileName';

      final fileBytes = excel.save();
      if (fileBytes != null) {
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);

        return filePath;
      }

      return null;
    } catch (e) {
      debugPrint('Lỗi xuất Excel: $e');
      return null;
    }
  }

  static void _createOverviewSheet(Sheet sheet, StatisticsData statistics) {
    // Header
    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue(
      'TỔNG QUAN THỐNG KÊ',
    );
    sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('B1'));

    // Styling header
    var headerCell = sheet.cell(CellIndex.indexByString('A1'));
    headerCell.cellStyle = CellStyle(
      bold: true,
      fontSize: 16,
      horizontalAlign: HorizontalAlign.Center,
    );

    // Data
    sheet.cell(CellIndex.indexByString('A3')).value = TextCellValue(
      'Tổng doanh thu',
    );
    sheet.cell(CellIndex.indexByString('B3')).value = TextCellValue(
      '${NumberFormat('#,###').format(statistics.totalRevenue)}đ',
    );

    sheet.cell(CellIndex.indexByString('A4')).value = TextCellValue(
      'Tổng đơn hàng',
    );
    sheet.cell(CellIndex.indexByString('B4')).value = IntCellValue(
      statistics.totalOrders,
    );

    sheet.cell(CellIndex.indexByString('A5')).value = TextCellValue(
      'Tổng người dùng',
    );
    sheet.cell(CellIndex.indexByString('B5')).value = IntCellValue(
      statistics.totalUsers,
    );

    sheet.cell(CellIndex.indexByString('A6')).value = TextCellValue(
      'Tổng sản phẩm',
    );
    sheet.cell(CellIndex.indexByString('B6')).value = IntCellValue(
      statistics.totalProducts,
    );

    sheet.cell(CellIndex.indexByString('A7')).value = TextCellValue(
      'Đơn hàng hoàn thành',
    );
    sheet.cell(CellIndex.indexByString('B7')).value = IntCellValue(
      statistics.completedOrders,
    );

    sheet.cell(CellIndex.indexByString('A8')).value = TextCellValue(
      'Đơn hàng chờ xử lý',
    );
    sheet.cell(CellIndex.indexByString('B8')).value = IntCellValue(
      statistics.pendingOrders,
    );

    sheet.cell(CellIndex.indexByString('A9')).value = TextCellValue(
      'Đơn hàng đang xử lý',
    );
    sheet.cell(CellIndex.indexByString('B9')).value = IntCellValue(
      statistics.processingOrders,
    );

    sheet.cell(CellIndex.indexByString('A10')).value = TextCellValue(
      'Đơn hàng đã hủy',
    );
    sheet.cell(CellIndex.indexByString('B10')).value = IntCellValue(
      statistics.cancelledOrders,
    );

    // Style data cells
    for (int i = 3; i <= 10; i++) {
      sheet.cell(CellIndex.indexByString('A$i')).cellStyle = CellStyle(
        bold: true,
      );
    }
  }

  static void _createRevenueSheet(Sheet sheet, StatisticsData statistics) {
    // Header
    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue(
      'DOANH THU THEO THÁNG',
    );
    sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('B1'));

    var headerCell = sheet.cell(CellIndex.indexByString('A1'));
    headerCell.cellStyle = CellStyle(
      bold: true,
      fontSize: 16,
      horizontalAlign: HorizontalAlign.Center,
    );

    // Column headers
    sheet.cell(CellIndex.indexByString('A3')).value = TextCellValue('Tháng');
    sheet.cell(CellIndex.indexByString('B3')).value = TextCellValue(
      'Doanh thu (đ)',
    );

    // Style column headers
    sheet.cell(CellIndex.indexByString('A3')).cellStyle = CellStyle(bold: true);
    sheet.cell(CellIndex.indexByString('B3')).cellStyle = CellStyle(bold: true);

    // Data
    const months = [
      'Tháng 1',
      'Tháng 2',
      'Tháng 3',
      'Tháng 4',
      'Tháng 5',
      'Tháng 6',
      'Tháng 7',
      'Tháng 8',
      'Tháng 9',
      'Tháng 10',
      'Tháng 11',
      'Tháng 12',
    ];

    for (int i = 0; i < statistics.monthlyRevenue.length && i < 12; i++) {
      final row = i + 4;
      sheet.cell(CellIndex.indexByString('A$row')).value = TextCellValue(
        months[i],
      );
      sheet.cell(CellIndex.indexByString('B$row')).value = TextCellValue(
        NumberFormat('#,###').format(statistics.monthlyRevenue[i]),
      );
    }
  }

  static void _createOrderStatusSheet(Sheet sheet, StatisticsData statistics) {
    // Header
    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue(
      'TRẠNG THÁI ĐƠN HÀNG',
    );
    sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('B1'));

    var headerCell = sheet.cell(CellIndex.indexByString('A1'));
    headerCell.cellStyle = CellStyle(
      bold: true,
      fontSize: 16,
      horizontalAlign: HorizontalAlign.Center,
    );

    // Column headers
    sheet.cell(CellIndex.indexByString('A3')).value = TextCellValue(
      'Trạng thái',
    );
    sheet.cell(CellIndex.indexByString('B3')).value = TextCellValue('Số lượng');

    // Style column headers
    sheet.cell(CellIndex.indexByString('A3')).cellStyle = CellStyle(bold: true);
    sheet.cell(CellIndex.indexByString('B3')).cellStyle = CellStyle(bold: true);

    // Data
    sheet.cell(CellIndex.indexByString('A4')).value = TextCellValue(
      'Hoàn thành',
    );
    sheet.cell(CellIndex.indexByString('B4')).value = IntCellValue(
      statistics.completedOrders,
    );

    sheet.cell(CellIndex.indexByString('A5')).value = TextCellValue(
      'Chờ xử lý',
    );
    sheet.cell(CellIndex.indexByString('B5')).value = IntCellValue(
      statistics.pendingOrders,
    );

    sheet.cell(CellIndex.indexByString('A6')).value = TextCellValue(
      'Đang xử lý',
    );
    sheet.cell(CellIndex.indexByString('B6')).value = IntCellValue(
      statistics.processingOrders,
    );

    sheet.cell(CellIndex.indexByString('A7')).value = TextCellValue('Đã hủy');
    sheet.cell(CellIndex.indexByString('B7')).value = IntCellValue(
      statistics.cancelledOrders,
    );
  }

  static void _createTopProductsSheet(Sheet sheet, StatisticsData statistics) {
    // Header
    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue(
      'TOP SẢN PHẨM BÁN CHẠY',
    );
    sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('C1'));

    var headerCell = sheet.cell(CellIndex.indexByString('A1'));
    headerCell.cellStyle = CellStyle(
      bold: true,
      fontSize: 16,
      horizontalAlign: HorizontalAlign.Center,
    );

    // Column headers
    sheet.cell(CellIndex.indexByString('A3')).value = TextCellValue(
      'Tên sản phẩm',
    );
    sheet.cell(CellIndex.indexByString('B3')).value = TextCellValue(
      'Số lượng bán',
    );
    sheet.cell(CellIndex.indexByString('C3')).value = TextCellValue(
      'Doanh thu (đ)',
    );

    // Style column headers
    sheet.cell(CellIndex.indexByString('A3')).cellStyle = CellStyle(bold: true);
    sheet.cell(CellIndex.indexByString('B3')).cellStyle = CellStyle(bold: true);
    sheet.cell(CellIndex.indexByString('C3')).cellStyle = CellStyle(bold: true);

    // Data
    for (int i = 0; i < statistics.topProducts.length; i++) {
      final row = i + 4;
      final product = statistics.topProducts[i];

      sheet.cell(CellIndex.indexByString('A$row')).value = TextCellValue(
        product.name,
      );
      sheet.cell(CellIndex.indexByString('B$row')).value = IntCellValue(
        product.soldQuantity,
      );
      sheet.cell(CellIndex.indexByString('C$row')).value = TextCellValue(
        NumberFormat('#,###').format(product.revenue),
      );
    }
  }

  static void _createUserRegistrationSheet(
    Sheet sheet,
    StatisticsData statistics,
  ) {
    // Header
    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue(
      'ĐĂNG KÝ NGƯỜI DÙNG THEO THÁNG',
    );
    sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('B1'));

    var headerCell = sheet.cell(CellIndex.indexByString('A1'));
    headerCell.cellStyle = CellStyle(
      bold: true,
      fontSize: 16,
      horizontalAlign: HorizontalAlign.Center,
    );

    // Column headers
    sheet.cell(CellIndex.indexByString('A3')).value = TextCellValue('Tháng');
    sheet.cell(CellIndex.indexByString('B3')).value = TextCellValue(
      'Số lượng đăng ký',
    );

    // Style column headers
    sheet.cell(CellIndex.indexByString('A3')).cellStyle = CellStyle(bold: true);
    sheet.cell(CellIndex.indexByString('B3')).cellStyle = CellStyle(bold: true);

    // Data
    const months = [
      'Tháng 1',
      'Tháng 2',
      'Tháng 3',
      'Tháng 4',
      'Tháng 5',
      'Tháng 6',
      'Tháng 7',
      'Tháng 8',
      'Tháng 9',
      'Tháng 10',
      'Tháng 11',
      'Tháng 12',
    ];

    for (
      int i = 0;
      i < statistics.monthlyUserRegistrations.length && i < 12;
      i++
    ) {
      final row = i + 4;
      sheet.cell(CellIndex.indexByString('A$row')).value = TextCellValue(
        months[i],
      );
      sheet.cell(CellIndex.indexByString('B$row')).value = IntCellValue(
        statistics.monthlyUserRegistrations[i],
      );
    }
  }
}
