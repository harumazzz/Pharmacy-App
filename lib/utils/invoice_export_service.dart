import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_app/data/models/order.dart';
import 'package:pharmacy_app/data/models/order_item.dart';
import 'package:pharmacy_app/data/models/product.dart';
import 'package:intl/intl.dart';

class InvoiceExportService {
  static Future<String?> exportOrderInvoiceToExcel(
    Order order,
    List<OrderItem> orderItems,
    List<Product> products,
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

      // Xóa sheet mặc định và tạo sheet hóa đơn
      excel.delete('Sheet1');
      Sheet invoiceSheet = excel['Hoa_Don'];

      // Tạo hóa đơn
      _createInvoiceSheet(invoiceSheet, order, orderItems, products);

      // Lưu file
      final directory = Platform.isAndroid
          ? Directory('/storage/emulated/0/Download')
          : await getApplicationDocumentsDirectory();

      final fileName =
          'Hoa_Don_${order.id}_${DateFormat('dd_MM_yyyy_HH_mm').format(DateTime.now())}.xlsx';
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
      debugPrint('Lỗi xuất hóa đơn: $e');
      return null;
    }
  }

  static void _createInvoiceSheet(
    Sheet sheet,
    Order order,
    List<OrderItem> orderItems,
    List<Product> products,
  ) {
    // Header - Tên cửa hàng
    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue('NHÓM 9');
    sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('D1'));
    var titleCell = sheet.cell(CellIndex.indexByString('A1'));
    titleCell.cellStyle = CellStyle(
      bold: true,
      fontSize: 18,
      horizontalAlign: HorizontalAlign.Center,
    );

    // Tiêu đề hóa đơn
    sheet.cell(CellIndex.indexByString('A2')).value = TextCellValue(
      'HÓA ĐƠN BÁN HÀNG',
    );
    sheet.merge(CellIndex.indexByString('A2'), CellIndex.indexByString('D2'));
    var invoiceHeaderCell = sheet.cell(CellIndex.indexByString('A2'));
    invoiceHeaderCell.cellStyle = CellStyle(
      bold: true,
      fontSize: 16,
      horizontalAlign: HorizontalAlign.Center,
    );

    // Thông tin đơn hàng
    sheet.cell(CellIndex.indexByString('A4')).value = TextCellValue(
      'Số hóa đơn:',
    );
    sheet.cell(CellIndex.indexByString('B4')).value = TextCellValue(
      '#${order.id}',
    );

    sheet.cell(CellIndex.indexByString('A5')).value = TextCellValue(
      'Ngày tạo:',
    );
    sheet.cell(CellIndex.indexByString('B5')).value = TextCellValue(
      DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt),
    );

    sheet.cell(CellIndex.indexByString('A6')).value = TextCellValue(
      'Trạng thái:',
    );
    sheet.cell(CellIndex.indexByString('B6')).value = TextCellValue(
      _getStatusLabel(order.status),
    );

    sheet.cell(CellIndex.indexByString('A7')).value = TextCellValue(
      'Địa chỉ giao hàng:',
    );
    sheet.cell(CellIndex.indexByString('B7')).value = TextCellValue(
      order.shippingAddress,
    );

    // Header bảng sản phẩm
    int startRow = 9;
    sheet.cell(CellIndex.indexByString('A$startRow')).value = TextCellValue(
      'STT',
    );
    sheet.cell(CellIndex.indexByString('B$startRow')).value = TextCellValue(
      'Tên sản phẩm',
    );
    sheet.cell(CellIndex.indexByString('C$startRow')).value = TextCellValue(
      'Số lượng',
    );
    sheet.cell(CellIndex.indexByString('D$startRow')).value = TextCellValue(
      'Đơn giá',
    );
    sheet.cell(CellIndex.indexByString('E$startRow')).value = TextCellValue(
      'Thành tiền',
    );

    // Style header bảng
    for (String col in ['A', 'B', 'C', 'D', 'E']) {
      var cell = sheet.cell(CellIndex.indexByString('$col$startRow'));
      cell.cellStyle = CellStyle(bold: true);
    }

    // Dữ liệu sản phẩm
    for (int i = 0; i < orderItems.length; i++) {
      final item = orderItems[i];
      final rowNum = startRow + 1 + i;
      final itemTotal = item.quantity * item.price;

      // Tìm tên sản phẩm
      final product = products.firstWhere(
        (p) => p.id == item.productId,
        orElse: () => const Product(
          id: -1,
          name: 'Sản phẩm không xác định',
          description: '',
          price: 0,
          stockQuantity: 0,
          categoryId: 0,
        ),
      );

      sheet.cell(CellIndex.indexByString('A$rowNum')).value = TextCellValue(
        '${i + 1}',
      );
      sheet.cell(CellIndex.indexByString('B$rowNum')).value = TextCellValue(
        product.name,
      );
      sheet.cell(CellIndex.indexByString('C$rowNum')).value = TextCellValue(
        '${item.quantity}',
      );
      sheet.cell(CellIndex.indexByString('D$rowNum')).value = TextCellValue(
        '${NumberFormat('#,###').format(item.price)}đ',
      );
      sheet.cell(CellIndex.indexByString('E$rowNum')).value = TextCellValue(
        '${NumberFormat('#,###').format(itemTotal)}đ',
      );
    }

    // Tổng cộng
    final totalRow = startRow + 1 + orderItems.length + 1;
    sheet.cell(CellIndex.indexByString('D$totalRow')).value = TextCellValue(
      'TỔNG CỘNG:',
    );
    sheet.cell(CellIndex.indexByString('E$totalRow')).value = TextCellValue(
      '${NumberFormat('#,###').format(order.totalPrice)}đ',
    );

    var totalCell = sheet.cell(CellIndex.indexByString('D$totalRow'));
    totalCell.cellStyle = CellStyle(bold: true);
    var totalValueCell = sheet.cell(CellIndex.indexByString('E$totalRow'));
    totalValueCell.cellStyle = CellStyle(bold: true);

    // Ghi chú
    final noteRow = totalRow + 2;
    sheet.cell(CellIndex.indexByString('A$noteRow')).value = TextCellValue(
      'Cảm ơn quý khách đã mua hàng!',
    );
    sheet.merge(
      CellIndex.indexByString('A$noteRow'),
      CellIndex.indexByString('E$noteRow'),
    );
    var noteCell = sheet.cell(CellIndex.indexByString('A$noteRow'));
    noteCell.cellStyle = CellStyle(
      italic: true,
      horizontalAlign: HorizontalAlign.Center,
    );

    // Thiết lập độ rộng cột
    sheet.setColumnWidth(0, 8); // STT
    sheet.setColumnWidth(1, 25); // Tên sản phẩm
    sheet.setColumnWidth(2, 12); // Số lượng
    sheet.setColumnWidth(3, 15); // Đơn giá
    sheet.setColumnWidth(4, 15); // Thành tiền
  }

  static String _getStatusLabel(String status) {
    const statusLabels = {
      'pending': 'Chờ xử lý',
      'processing': 'Đang xử lý',
      'shipped': 'Đang giao',
      'delivered': 'Đã giao',
    };
    return statusLabels[status] ?? status;
  }
}
