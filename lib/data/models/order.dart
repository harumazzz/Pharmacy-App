import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
sealed class Order with _$Order {
  const factory Order({
    required int id,
    required int userId,
    required double totalPrice,
    required String status, // 'pending', 'processing', 'shipped', 'delivered'
    required String shippingAddress,
    required DateTime createdAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
