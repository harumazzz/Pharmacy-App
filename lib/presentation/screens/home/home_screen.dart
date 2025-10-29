import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/presentation/providers/home/category_list_provider.dart';
import 'package:pharmacy_app/presentation/providers/home/search_query_provider.dart';
import 'package:pharmacy_app/presentation/providers/home/searched_products_provider.dart';
import 'package:pharmacy_app/presentation/providers/product_list/product_list_provider.dart';
import 'package:pharmacy_app/presentation/screens/product_list/product_list_screen.dart';
import 'package:pharmacy_app/presentation/widgets/app_grid.dart';
import 'package:pharmacy_app/presentation/widgets/category_card.dart';
import 'package:pharmacy_app/presentation/widgets/error_display.dart';
import 'package:pharmacy_app/presentation/widgets/loading_spinner.dart';
import 'package:pharmacy_app/presentation/widgets/empty_state.dart';
import 'package:pharmacy_app/presentation/widgets/product_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final searchController = TextEditingController(text: searchQuery);

    return Scaffold(
      appBar: AppBar(title: const Text('Trang chủ'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _SearchBar(controller: searchController),
            ),
            // Categories section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Danh mục',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 140, child: _CategoriesSection()),
            const SizedBox(height: 24.0),
            // Products section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                searchQuery.isEmpty ? 'Sản phẩm' : 'Kết quả tìm kiếm',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            _ProductsSection(searchQuery: searchQuery),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends ConsumerWidget {
  final TextEditingController controller;

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Tìm kiếm sản phẩm',
        hintText: 'Nhập tên sản phẩm...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        prefixIcon: const Icon(Icons.search),
      ),
      onChanged: (value) {
        ref.read(searchQueryProvider.notifier).setQuery(value);
      },
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
                          categoryName: category.name,
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
      padding: const EdgeInsets.all(16.0),
      child: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return EmptyState(
              message: searchQuery.isEmpty
                  ? 'Không có sản phẩm'
                  : 'Không tìm thấy sản phẩm cho "$searchQuery"',
            );
          }
          return AppGrid(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: 0.7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onAddToCart: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${product.name} đã được thêm vào giỏ hàng',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  // TODO: Call addProductToCart from CartRepository
                },
              );
            },
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
