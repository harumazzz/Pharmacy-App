import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmacy_app/data/local/app_database.dart';

@injectable
class MockDataService {
  final AppDatabase _db;

  MockDataService(this._db);

  Future<void> insertMockData() async {
    try {
      // Kiểm tra xem đã có dữ liệu chưa
      final existingCategories = await _db.categoryDao.getAllCategories();
      if (existingCategories.isNotEmpty) {
        debugPrint('Mock data already exists');
        return;
      }

      await _insertMockCategories();
      await _insertMockUsers();
      await _insertMockProducts();

      debugPrint('Mock data inserted successfully');
    } catch (e) {
      debugPrint('Error inserting mock data: $e');
    }
  }

  Future<void> _insertMockCategories() async {
    final categories = [
      CategoriesCompanion.insert(
        name: 'Thuốc giảm đau',
        description: 'Các loại thuốc giảm đau, hạ sốt',
      ),
      CategoriesCompanion.insert(
        name: 'Thuốc kháng sinh',
        description: 'Thuốc kháng sinh điều trị nhiễm khuẩn',
      ),
      CategoriesCompanion.insert(
        name: 'Vitamin & Thực phẩm chức năng',
        description: 'Vitamin và các thực phẩm bổ sung dinh dưỡng',
      ),
      CategoriesCompanion.insert(
        name: 'Thuốc tiêu hóa',
        description: 'Thuốc hỗ trợ hệ tiêu hóa',
      ),
      CategoriesCompanion.insert(
        name: 'Dụng cụ y tế',
        description: 'Các dụng cụ y tế gia đình',
      ),
    ];

    for (final category in categories) {
      await _db.categoryDao.addCategory(category);
    }
  }

  Future<void> _insertMockUsers() async {
    final users = [
      UsersCompanion.insert(
        username: 'admin@gmail.com',
        password: 'admin123', // Trong thực tế nên hash password
        fullName: const Value('Quản trị viên'),
        role: 'admin',
      ),
      UsersCompanion.insert(
        username: 'user1@gmail.com',
        password: 'user123',
        fullName: const Value('Nguyễn Văn A'),
        role: 'customer',
      ),
      UsersCompanion.insert(
        username: 'user2@gmail.com',
        password: 'user123',
        fullName: const Value('Trần Thị B'),
        role: 'customer',
      ),
    ];

    for (final user in users) {
      await _db.userDao.insertUser(user);
    }
  }

  Future<void> _insertMockProducts() async {
    final products = [
      // Thuốc giảm đau (category 1)
      ProductsCompanion.insert(
        name: 'Paracetamol 500mg',
        description:
            'Thuốc giảm đau, hạ sốt hiệu quả, an toàn cho trẻ em và người lớn',
        price: 25000,
        stockQuantity: 100,
        categoryId: 1,
        imageUrl:
            'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Ibuprofen 400mg',
        description: 'Thuốc chống viêm, giảm đau nhanh chóng, hiệu quả cao',
        price: 35000,
        stockQuantity: 50,
        categoryId: 1,
        imageUrl:
            'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Aspirin 100mg',
        description: 'Thuốc giảm đau, chống viêm và phòng ngừa đột quỵ',
        price: 18000,
        stockQuantity: 80,
        categoryId: 1,
        imageUrl:
            'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Diclofenac 25mg',
        description: 'Thuốc giảm đau, chống viêm khớp hiệu quả',
        price: 42000,
        stockQuantity: 35,
        categoryId: 1,
        imageUrl:
            'https://images.unsplash.com/photo-1550572017-5cb3b7c3bbe7?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Ketoprofen 50mg',
        description: 'Thuốc giảm đau và chống viêm mạnh',
        price: 55000,
        stockQuantity: 25,
        categoryId: 1,
        imageUrl:
            'https://images.unsplash.com/photo-1628771065518-0d82f1938462?w=300&h=300&fit=crop',
      ),

      // Thuốc kháng sinh (category 2)
      ProductsCompanion.insert(
        name: 'Amoxicillin 250mg',
        description: 'Kháng sinh điều trị nhiễm khuẩn đường hô hấp, tiết niệu',
        price: 45000,
        stockQuantity: 30,
        categoryId: 2,
        imageUrl:
            'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Cephalexin 500mg',
        description: 'Kháng sinh nhóm Cephalosporin điều trị nhiễm khuẩn',
        price: 65000,
        stockQuantity: 25,
        categoryId: 2,
        imageUrl:
            'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Azithromycin 250mg',
        description: 'Kháng sinh điều trị nhiễm khuẩn đường hô hấp',
        price: 85000,
        stockQuantity: 20,
        categoryId: 2,
        imageUrl:
            'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Ciprofloxacin 500mg',
        description: 'Kháng sinh điều trị nhiễm khuẩn đường tiết niệu',
        price: 78000,
        stockQuantity: 15,
        categoryId: 2,
        imageUrl:
            'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Erythromycin 250mg',
        description: 'Kháng sinh thay thế Penicillin cho người dị ứng',
        price: 52000,
        stockQuantity: 18,
        categoryId: 2,
        imageUrl:
            'https://images.unsplash.com/photo-1550572017-5cb3b7c3bbe7?w=300&h=300&fit=crop',
      ),

      // Vitamin & TPCN (category 3)
      ProductsCompanion.insert(
        name: 'Vitamin C 1000mg',
        description: 'Bổ sung vitamin C tăng cường miễn dịch, chống oxy hóa',
        price: 120000,
        stockQuantity: 80,
        categoryId: 3,
        imageUrl:
            'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Multivitamin A-Z',
        description: 'Vitamin tổng hợp đầy đủ cho cả gia đình',
        price: 250000,
        stockQuantity: 40,
        categoryId: 3,
        imageUrl:
            'https://images.unsplash.com/photo-1559181567-c3190ca9959b?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Vitamin D3 1000IU',
        description: 'Bổ sung vitamin D3 tăng cường hấp thu canxi',
        price: 180000,
        stockQuantity: 60,
        categoryId: 3,
        imageUrl:
            'https://images.unsplash.com/photo-1550572017-5cb3b7c3bbe7?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Omega-3 Fish Oil',
        description: 'Dầu cá Omega-3 tốt cho tim mạch và não bộ',
        price: 320000,
        stockQuantity: 35,
        categoryId: 3,
        imageUrl:
            'https://images.unsplash.com/photo-1628771065658-2ee2b8581ca4?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Calcium + Magnesium',
        description: 'Bổ sung canxi và magie cho xương khớp chắc khỏe',
        price: 200000,
        stockQuantity: 45,
        categoryId: 3,
        imageUrl:
            'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Iron Plus B12',
        description: 'Bổ sung sắt và vitamin B12 chống thiếu máu',
        price: 165000,
        stockQuantity: 30,
        categoryId: 3,
        imageUrl:
            'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=300&h=300&fit=crop',
      ),

      // Thuốc tiêu hóa (category 4)
      ProductsCompanion.insert(
        name: 'Omeprazole 20mg',
        description: 'Thuốc điều trị loét dạ dày, trào ngược dạ dày',
        price: 85000,
        stockQuantity: 60,
        categoryId: 4,
        imageUrl:
            'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Smecta',
        description: 'Thuốc chống tiêu chảy, bảo vệ niêm mạc ruột',
        price: 55000,
        stockQuantity: 70,
        categoryId: 4,
        imageUrl:
            'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Domperidone 10mg',
        description: 'Thuốc chống nôn và tăng nhu động dạ dày',
        price: 38000,
        stockQuantity: 45,
        categoryId: 4,
        imageUrl:
            'https://images.unsplash.com/photo-1550572017-5cb3b7c3bbe7?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Loperamide 2mg',
        description: 'Thuốc điều trị tiêu chảy cấp tính hiệu quả',
        price: 32000,
        stockQuantity: 50,
        categoryId: 4,
        imageUrl:
            'https://images.unsplash.com/photo-1628771065518-0d82f1938462?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Simethicone 40mg',
        description: 'Thuốc giảm đầy hơi, khó tiêu',
        price: 28000,
        stockQuantity: 55,
        categoryId: 4,
        imageUrl:
            'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Bisacodyl 5mg',
        description: 'Thuốc nhuận tràng điều trị táo bón',
        price: 25000,
        stockQuantity: 40,
        categoryId: 4,
        imageUrl:
            'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=300&h=300&fit=crop',
      ),

      // Dụng cụ y tế (category 5)
      ProductsCompanion.insert(
        name: 'Nhiệt kế điện tử',
        description: 'Nhiệt kế đo thân nhiệt chính xác, nhanh chóng',
        price: 150000,
        stockQuantity: 20,
        categoryId: 5,
        imageUrl:
            'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Máy đo huyết áp',
        description: 'Máy đo huyết áp tự động tại nhà, độ chính xác cao',
        price: 850000,
        stockQuantity: 10,
        categoryId: 5,
        imageUrl:
            'https://images.unsplash.com/photo-1628771065658-2ee2b8581ca4?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Máy đo đường huyết',
        description: 'Máy đo đường huyết cho người tiểu đường',
        price: 450000,
        stockQuantity: 15,
        categoryId: 5,
        imageUrl:
            'https://images.unsplash.com/photo-1550572017-5cb3b7c3bbe7?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Băng gạc y tế',
        description: 'Băng gạc vô trùng để băng bó vết thương',
        price: 35000,
        stockQuantity: 100,
        categoryId: 5,
        imageUrl:
            'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Khẩu trang y tế',
        description: 'Khẩu trang y tế 3 lớp kháng khuẩn (hộp 50 chiếc)',
        price: 65000,
        stockQuantity: 80,
        categoryId: 5,
        imageUrl:
            'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Cồn y tế 70%',
        description: 'Cồn y tế 70% sát trùng vết thương (chai 100ml)',
        price: 22000,
        stockQuantity: 120,
        categoryId: 5,
        imageUrl:
            'https://images.unsplash.com/photo-1628771065518-0d82f1938462?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Bông y tế',
        description: 'Bông y tế vô trùng để làm sạch vết thương',
        price: 18000,
        stockQuantity: 90,
        categoryId: 5,
        imageUrl:
            'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=300&h=300&fit=crop',
      ),
      ProductsCompanion.insert(
        name: 'Kim tiêm và ống tiêm',
        description: 'Bộ kim tiêm và ống tiêm vô trùng dùng một lần',
        price: 8000,
        stockQuantity: 200,
        categoryId: 5,
        imageUrl:
            'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=300&h=300&fit=crop',
      ),
    ];

    for (final product in products) {
      await _db.productDao.addProduct(product);
    }
  }

  Future<void> clearAllData() async {
    await _db.delete(_db.orderItems).go();
    await _db.delete(_db.orders).go();
    await _db.delete(_db.cartItems).go();
    await _db.delete(_db.products).go();
    await _db.delete(_db.categories).go();
    await _db.delete(_db.users).go();
    debugPrint('All data cleared');
  }
}
