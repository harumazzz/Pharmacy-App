import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/data/models/product.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';
import 'package:pharmacy_app/presentation/providers/product_list/product_list_provider.dart';
import 'package:pharmacy_app/presentation/widgets/custom_app_bar.dart';
import 'package:pharmacy_app/presentation/widgets/form_helpers.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _categoryIdController;
  late TextEditingController _imageUrlController;

  bool _isLoading = false;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    _priceController =
        TextEditingController(text: widget.product?.price.toString() ?? '');
    _stockController = TextEditingController(
        text: widget.product?.stockQuantity.toString() ?? '');
    _categoryIdController =
        TextEditingController(text: widget.product?.categoryId.toString() ?? '');
    _imageUrlController =
        TextEditingController(text: widget.product?.imageUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryIdController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    setState(() => _isLoading = true);
    try {
      final adminRepo = ref.read(adminRepositoryProvider);
      final price = double.tryParse(_priceController.text);
      final stock = int.tryParse(_stockController.text);
      final categoryId = int.tryParse(_categoryIdController.text);

      if (price == null || stock == null || categoryId == null) {
        throw 'Vui lòng nhập đúng định dạng giá, số lượng và danh mục';
      }

      final product = Product(
        id: widget.product?.id ?? 0,
        name: _nameController.text,
        description: _descriptionController.text,
        price: price,
        stockQuantity: stock,
        categoryId: categoryId,
        imageUrl: _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
      );

      if (widget.product == null) {
        await adminRepo.addProduct(product);
      } else {
        await adminRepo.updateProduct(product);
      }

      if (mounted) {
        ref.invalidate(productListProvider);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.product == null
                ? 'Thêm sản phẩm thành công'
                : 'Cập nhật sản phẩm thành công'),
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
        title: widget.product == null ? 'Thêm sản phẩm' : 'Chỉnh sửa sản phẩm',
      ),
      body: CrudForm(
        title: widget.product == null ? 'Sản phẩm mới' : 'Chỉnh sửa sản phẩm',
        fields: [
          CrudFormField(
            label: 'Tên sản phẩm',
            controller: _nameController,
            icon: Icons.shopping_bag,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Vui lòng nhập tên sản phẩm';
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
          CrudFormField(
            label: 'Giá',
            controller: _priceController,
            icon: Icons.attach_money,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Vui lòng nhập giá';
              if (double.tryParse(value!) == null) return 'Giá không hợp lệ';
              return null;
            },
          ),
          CrudFormField(
            label: 'Số lượng',
            controller: _stockController,
            icon: Icons.inventory,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Vui lòng nhập số lượng';
              if (int.tryParse(value!) == null) return 'Số lượng không hợp lệ';
              return null;
            },
          ),
          CrudFormField(
            label: 'ID Danh mục',
            controller: _categoryIdController,
            icon: Icons.category,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Vui lòng nhập danh mục';
              if (int.tryParse(value!) == null) return 'Danh mục không hợp lệ';
              return null;
            },
          ),
          CrudFormField(
            label: 'URL hình ảnh (tuỳ chọn)',
            controller: _imageUrlController,
            icon: Icons.image,
          ),
        ],
        onSave: _saveProduct,
        onCancel: () => Navigator.pop(context),
        saveButtonText: widget.product == null ? 'Thêm' : 'Cập nhật',
        isLoading: _isLoading,
        submitError: _submitError,
      ),
    );
  }
}
