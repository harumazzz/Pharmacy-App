import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';
import 'package:pharmacy_app/presentation/screens/admin/category_form_screen.dart';
import 'package:pharmacy_app/presentation/widgets/error_display.dart';
import 'package:pharmacy_app/presentation/widgets/form_helpers.dart';
import 'package:pharmacy_app/presentation/widgets/loading_spinner.dart';

class AdminCategoriesScreen extends ConsumerWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CategoryFormScreen()),
        ),
        label: const Text('Thêm danh mục'),
        icon: const Icon(Icons.add),
      ),
      body: categoriesAsync.when(
        data: (categories) => categories.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Chưa có danh mục',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CrudListTile(
                    leading: Icon(
                      Icons.category,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: category.name,
                    subtitle: category.description,
                    onEdit: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryFormScreen(category: category),
                      ),
                    ),
                    onDelete: () => _deleteCategory(
                      context,
                      ref,
                      category.id,
                      category.name,
                    ),
                  );
                },
              ),
        loading: () => const Center(child: LoadingSpinner()),
        error: (error, stack) => Center(
          child: ErrorDisplay(
            message: 'Lỗi tải danh sách danh mục',
            onRetry: () => ref.refresh(categoryListProvider),
          ),
        ),
      ),
    );
  }

  void _deleteCategory(
    BuildContext context,
    WidgetRef ref,
    int categoryId,
    String categoryName,
  ) async {
    final confirmed = await showDeleteConfirmation(
      context,
      title: 'Xoá danh mục',
      message: 'Bạn chắc chắn muốn xoá "$categoryName"?',
    );

    if (confirmed && context.mounted) {
      try {
        final adminRepo = ref.read(adminRepositoryProvider);
        await adminRepo.softDeleteCategory(categoryId);
        if (context.mounted) {
          final _ = ref.refresh(categoryListProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Xoá danh mục thành công')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
        }
      }
    }
  }
}
