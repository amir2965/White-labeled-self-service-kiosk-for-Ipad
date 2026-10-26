import 'package:freezed_annotation/freezed_annotation.dart';
import 'product.dart';
import 'modifier.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required String merchantId,
    String? deviceId,
    required List<OrderItem> items,
    required double subtotal,
    required double serviceFee,
    required double total,
    required OrderStatus status,
    required PaymentMethod paymentMethod,
    String? paymentSessionId,
    String? notes,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required Product product,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    @Default([]) List<SelectedModifier> selectedModifiers,
    String? notes,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

@freezed
class SelectedModifier with _$SelectedModifier {
  const factory SelectedModifier({
    required String modifierGroupId,
    required String modifierGroupName,
    required Modifier modifier,
  }) = _SelectedModifier;

  factory SelectedModifier.fromJson(Map<String, dynamic> json) =>
      _$SelectedModifierFromJson(json);
}

enum OrderStatus { draft, pending, confirmed, completed, cancelled }

enum PaymentMethod { payAtCounter, qrCode, cash, card }
