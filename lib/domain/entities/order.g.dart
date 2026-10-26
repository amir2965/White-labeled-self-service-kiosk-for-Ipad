// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
      id: json['id'] as String,
      merchantId: json['merchantId'] as String,
      deviceId: json['deviceId'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      serviceFee: (json['serviceFee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: $enumDecode(_$OrderStatusEnumMap, json['status']),
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      paymentSessionId: json['paymentSessionId'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'merchantId': instance.merchantId,
      'deviceId': instance.deviceId,
      'items': instance.items,
      'subtotal': instance.subtotal,
      'serviceFee': instance.serviceFee,
      'total': instance.total,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'paymentSessionId': instance.paymentSessionId,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$OrderStatusEnumMap = {
  OrderStatus.draft: 'draft',
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.payAtCounter: 'payAtCounter',
  PaymentMethod.qrCode: 'qrCode',
  PaymentMethod.cash: 'cash',
  PaymentMethod.card: 'card',
};

_$OrderItemImpl _$$OrderItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemImpl(
      id: json['id'] as String,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      selectedModifiers: (json['selectedModifiers'] as List<dynamic>?)
              ?.map((e) => SelectedModifier.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$OrderItemImplToJson(_$OrderItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product': instance.product,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'totalPrice': instance.totalPrice,
      'selectedModifiers': instance.selectedModifiers,
      'notes': instance.notes,
    };

_$SelectedModifierImpl _$$SelectedModifierImplFromJson(
        Map<String, dynamic> json) =>
    _$SelectedModifierImpl(
      modifierGroupId: json['modifierGroupId'] as String,
      modifierGroupName: json['modifierGroupName'] as String,
      modifier: Modifier.fromJson(json['modifier'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SelectedModifierImplToJson(
        _$SelectedModifierImpl instance) =>
    <String, dynamic>{
      'modifierGroupId': instance.modifierGroupId,
      'modifierGroupName': instance.modifierGroupName,
      'modifier': instance.modifier,
    };
