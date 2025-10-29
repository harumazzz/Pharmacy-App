import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/presentation/providers/cart/checkout_provider.dart';
import 'package:pharmacy_app/presentation/widgets/custom_text_field.dart';
import 'package:pharmacy_app/presentation/widgets/primary_button.dart';
import 'package:pharmacy_app/presentation/widgets/secondary_button.dart';

class CheckoutForm extends ConsumerStatefulWidget {
  final int userId;

  const CheckoutForm({super.key, required this.userId});

  @override
  ConsumerState<CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends ConsumerState<CheckoutForm> {
  late TextEditingController shippingAddressController;
  late TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    shippingAddressController = TextEditingController();
    notesController = TextEditingController();
  }

  @override
  void dispose() {
    shippingAddressController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutState = ref.watch(checkoutProvider);

    ref.listen(checkoutProvider, (previous, next) {
      next.when(
        initial: () {},
        loading: () {},
        success: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Đặt hàng thành công!')));
          Future.delayed(const Duration(seconds: 1), () {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          });
        },
        error: (message) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        },
      );
    });

    final isLoading = checkoutState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin giao hàng',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16.0),
          CustomTextField(
            labelText: 'Địa chỉ giao hàng',
            controller: shippingAddressController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập địa chỉ giao hàng';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          CustomTextField(
            labelText: 'Ghi chú đơn hàng (tùy chọn)',
            controller: notesController,
          ),
          const SizedBox(height: 24.0),
          PrimaryButton(text: 'Đặt hàng', onPressed: _handlePlaceOrder),
          const SizedBox(height: 12.0),
          SecondaryButton(
            text: 'Quay lại',
            onPressed: isLoading ? null : _handleBack,
          ),
        ],
      ),
    );
  }

  void _handlePlaceOrder() {
    if (shippingAddressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập địa chỉ giao hàng')),
      );
      return;
    }

    ref
        .read(checkoutProvider.notifier)
        .placeOrder(
          userId: widget.userId,
          shippingAddress: shippingAddressController.text,
        );
  }

  void _handleBack() {
    Navigator.of(context).pop();
  }
}
