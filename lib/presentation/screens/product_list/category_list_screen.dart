import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/presentation/providers/home/category_list_provider.dart';
import 'package:pharmacy_app/presentation/screens/product_list/product_list_screen.dart';
import 'package:pharmacy_app/presentation/widgets/app_grid.dart';
import 'package:pharmacy_app/presentation/widgets/category_card.dart';
import 'package:pharmacy_app/presentation/widgets/custom_app_bar.dart';
import 'package:pharmacy_app/presentation/widgets/error_display.dart';
import 'package:pharmacy_app/presentation/widgets/loading_spinner.dart';
import 'package:pharmacy_app/presentation/widgets/empty_state.dart';

class CategoryListScreen extends ConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Danh mục'),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const EmptyState(message: 'Không có danh mục');
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppGrid(
              minItemWidth: 170.0,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.2,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
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
                );
              },
            ),
          );
        },
        loading: () => const LoadingSpinner(),
        error: (error, stackTrace) => ErrorDisplay(
          message: 'Lỗi tải danh mục',
          onRetry: () => ref.refresh(categoryListProvider),
        ),
      ),
    );
  }
}
