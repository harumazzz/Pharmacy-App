import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/presentation/providers/auth/auth_provider.dart';
import 'package:pharmacy_app/presentation/providers/auth/auth_state.dart';
import 'package:pharmacy_app/presentation/providers/home/category_list_provider.dart';
import 'package:pharmacy_app/presentation/providers/home/search_query_provider.dart';
import 'package:pharmacy_app/presentation/providers/home/searched_products_provider.dart';
import 'package:pharmacy_app/presentation/providers/product_list/product_list_provider.dart';
import 'package:pharmacy_app/presentation/screens/cart/cart_screen.dart';
import 'package:pharmacy_app/presentation/screens/product_detail/product_detail_screen.dart';
import 'package:pharmacy_app/presentation/screens/order/order_history_screen.dart';
import 'package:pharmacy_app/presentation/screens/product_list/category_list_screen.dart';
import 'package:pharmacy_app/presentation/screens/product_list/product_list_screen.dart';
import 'package:pharmacy_app/presentation/widgets/app_grid.dart';
import 'package:pharmacy_app/presentation/widgets/category_card.dart';
import 'package:pharmacy_app/presentation/widgets/custom_app_bar.dart';
import 'package:pharmacy_app/presentation/widgets/error_display.dart';
import 'package:pharmacy_app/presentation/widgets/loading_spinner.dart';
import 'package:pharmacy_app/presentation/widgets/empty_state.dart';
import 'package:pharmacy_app/presentation/widgets/product_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Trang chủ',
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      CartScreen(userId: ref.read(authProvider).userId ?? 0),
                ),
              );
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Đăng xuất'),
                onTap: () {
                  ref.read(authProvider.notifier).logout();
                },
              ),
            ],
          ),
        ],
      ),
      body: _currentIndex == 0
          ? const _HomeContent()
          : const OrderHistoryScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Đơn hàng'),
        ],
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final searchController = TextEditingController(text: searchQuery);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section with Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
            child: Column(
              children: [
                _SearchBar(controller: searchController),
                const SizedBox(height: 8.0),
                Text(
                  'Tìm kiếm thuốc và dụng cụ y tế',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Categories section
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Danh mục',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CategoryListScreen(),
                      ),
                    );
                  },
                  child: const Text('Xem tất cả'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 140, child: _CategoriesSection()),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  searchQuery.isEmpty ? 'Sản phẩm nổi bật' : 'Kết quả tìm kiếm',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (searchQuery.isEmpty)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const ProductListScreen(title: 'Tất cả sản phẩm'),
                        ),
                      );
                    },
                    child: const Text('Xem tất cả'),
                  ),
              ],
            ),
          ),
          _ProductsSection(searchQuery: searchQuery),
          const SizedBox(height: 32.0), // Bottom padding
        ],
      ),
    );
  }
}

class _SearchBar extends ConsumerWidget {
  final TextEditingController controller;

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Tìm kiếm sản phẩm',
          hintText: 'Nhập tên thuốc hoặc dụng cụ y tế...',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
        ),
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).setQuery(value);
        },
      ),
    );
  }
}

class _CategoriesSection extends ConsumerWidget {
  const _CategoriesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const Center(child: EmptyState(message: 'Không có danh mục'));
        }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return SizedBox(
              width: 120,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: CategoryCard(
                  category: category,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductListScreen(
                          categoryId: category.id,
                          title: category.name,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: LoadingSpinner()),
      error: (error, stackTrace) => Center(
        child: ErrorDisplay(
          message: 'Lỗi tải danh mục',
          onRetry: () => ref.refresh(categoryListProvider),
        ),
      ),
    );
  }
}

class _ProductsSection extends ConsumerWidget {
  final String searchQuery;

  const _ProductsSection({required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = searchQuery.isEmpty
        ? ref.watch(productListProvider(categoryId: null))
        : ref.watch(searchedProductsProvider(searchQuery));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return EmptyState(
              message: searchQuery.isEmpty
                  ? 'Không có sản phẩm'
                  : 'Không tìm thấy sản phẩm cho "$searchQuery"',
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppGrid(
              minItemWidth: 170.0,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length > 6 ? 6 : products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(productId: product.id),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: LoadingSpinner()),
        error: (error, stackTrace) => Center(
          child: ErrorDisplay(
            message: 'Lỗi tải sản phẩm',
            onRetry: () {
              if (searchQuery.isEmpty) {
                final _ = ref.refresh(productListProvider(categoryId: null));
              } else {
                final _ = ref.refresh(searchedProductsProvider(searchQuery));
              }
            },
          ),
        ),
      ),
    );
  }
}
