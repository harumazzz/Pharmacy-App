import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/data/models/category.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';
import 'package:pharmacy_app/presentation/widgets/custom_app_bar.dart';
import 'package:pharmacy_app/presentation/widgets/form_helpers.dart';

class CategoryFormScreen extends ConsumerStatefulWidget {
  final Category? category;

  const CategoryFormScreen({super.key, this.category});

  @override
  ConsumerState<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends ConsumerState<CategoryFormScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  bool _isLoading = false;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.category?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    setState(() => _isLoading = true);
    try {
      final adminRepo = ref.read(adminRepositoryProvider);

      if (widget.category == null) {
        await adminRepo.addCategory(
          _nameController.text,
          _descriptionController.text,
        );
      } else {
        await adminRepo.updateCategory(
          widget.category!.id,
          _nameController.text,
          _descriptionController.text,
        );
      }

      if (mounted) {
        final _ = ref.refresh(categoryListProvider);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.category == null
                  ? 'Thêm danh mục thành công'
                  : 'Cập nhật danh mục thành công',
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _submitError = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.category == null ? 'Thêm danh mục' : 'Chỉnh sửa danh mục',
      ),
      body: CrudForm(
        title: widget.category == null ? 'Danh mục mới' : 'Chỉnh sửa danh mục',
        fields: [
          CrudFormField(
            label: 'Tên danh mục',
            controller: _nameController,
            icon: Icons.category,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Vui lòng nhập tên danh mục';
              return null;
            },
          ),
          CrudFormField(
            label: 'Mô tả',
            controller: _descriptionController,
            icon: Icons.description,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Vui lòng nhập mô tả';
              return null;
            },
          ),
        ],
        onSave: _saveCategory,
        onCancel: () => Navigator.pop(context),
        saveButtonText: widget.category == null ? 'Thêm' : 'Cập nhật',
        isLoading: _isLoading,
        submitError: _submitError,
      ),
    );
  }
}
