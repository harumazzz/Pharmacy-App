import 'package:flutter/material.dart';
import 'package:pharmacy_app/presentation/screens/admin/admin_categories_screen.dart';
import 'package:pharmacy_app/presentation/screens/admin/admin_orders_screen.dart';
import 'package:pharmacy_app/presentation/screens/admin/admin_products_screen.dart';
import 'package:pharmacy_app/presentation/screens/admin/admin_users_screen.dart';
import 'package:pharmacy_app/presentation/screens/admin/admin_statistics_screen.dart';
import 'package:pharmacy_app/presentation/widgets/custom_app_bar.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _currentIndex = 0;

  final List<AdminTab> _tabs = [
    AdminTab(label: 'Thống kê', icon: Icons.analytics),
    AdminTab(label: 'Sản phẩm', icon: Icons.shopping_bag),
    AdminTab(label: 'Danh mục', icon: Icons.category),
    AdminTab(label: 'Đơn hàng', icon: Icons.receipt),
    AdminTab(label: 'Người dùng', icon: Icons.people),
  ];

  final List<Widget> _screens = [
    const AdminStatisticsScreen(),
    const AdminProductsScreen(),
    const AdminCategoriesScreen(),
    const AdminOrdersScreen(),
    const AdminUsersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Quản lý', showBackButton: false),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _tabs
            .map(
              (tab) => BottomNavigationBarItem(
                icon: Icon(tab.icon),
                label: tab.label,
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
            .toList(),
      ),
    );
  }
}

class AdminTab {
  final String label;
  final IconData icon;

  AdminTab({required this.label, required this.icon});
}
