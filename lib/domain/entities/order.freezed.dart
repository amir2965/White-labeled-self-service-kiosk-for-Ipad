// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Order _$OrderFromJson(Map<String, dynamic> json) {
  return _Order.fromJson(json);
}

/// @nodoc
mixin _$Order {
  String get id => throw _privateConstructorUsedError;
  String get merchantId => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;
  List<OrderItem> get items => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get serviceFee => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  OrderStatus get status => throw _privateConstructorUsedError;
  PaymentMethod get paymentMethod => throw _privateConstructorUsedError;
  String? get paymentSessionId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call(
      {String id,
      String merchantId,
      String? deviceId,
      List<OrderItem> items,
      double subtotal,
      double serviceFee,
      double total,
      OrderStatus status,
      PaymentMethod paymentMethod,
      String? paymentSessionId,
      String? notes,
      DateTime createdAt,
      DateTime? completedAt});
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? merchantId = null,
    Object? deviceId = freezed,
    Object? items = null,
    Object? subtotal = null,
    Object? serviceFee = null,
    Object? total = null,
    Object? status = null,
    Object? paymentMethod = null,
    Object? paymentSessionId = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      serviceFee: null == serviceFee
          ? _value.serviceFee
          : serviceFee // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      paymentSessionId: freezed == paymentSessionId
          ? _value.paymentSessionId
          : paymentSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
          _$OrderImpl value, $Res Function(_$OrderImpl) then) =
      __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String merchantId,
      String? deviceId,
      List<OrderItem> items,
      double subtotal,
      double serviceFee,
      double total,
      OrderStatus status,
      PaymentMethod paymentMethod,
      String? paymentSessionId,
      String? notes,
      DateTime createdAt,
      DateTime? completedAt});
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
      _$OrderImpl _value, $Res Function(_$OrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? merchantId = null,
    Object? deviceId = freezed,
    Object? items = null,
    Object? subtotal = null,
    Object? serviceFee = null,
    Object? total = null,
    Object? status = null,
    Object? paymentMethod = null,
    Object? paymentSessionId = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(_$OrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      serviceFee: null == serviceFee
          ? _value.serviceFee
          : serviceFee // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      paymentSessionId: freezed == paymentSessionId
          ? _value.paymentSessionId
          : paymentSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderImpl implements _Order {
  const _$OrderImpl(
      {required this.id,
      required this.merchantId,
      this.deviceId,
      required final List<OrderItem> items,
      required this.subtotal,
      required this.serviceFee,
      required this.total,
      required this.status,
      required this.paymentMethod,
      this.paymentSessionId,
      this.notes,
      required this.createdAt,
      this.completedAt})
      : _items = items;

  factory _$OrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderImplFromJson(json);

  @override
  final String id;
  @override
  final String merchantId;
  @override
  final String? deviceId;
  final List<OrderItem> _items;
  @override
  List<OrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final double subtotal;
  @override
  final double serviceFee;
  @override
  final double total;
  @override
  final OrderStatus status;
  @override
  final PaymentMethod paymentMethod;
  @override
  final String? paymentSessionId;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'Order(id: $id, merchantId: $merchantId, deviceId: $deviceId, items: $items, subtotal: $subtotal, serviceFee: $serviceFee, total: $total, status: $status, paymentMethod: $paymentMethod, paymentSessionId: $paymentSessionId, notes: $notes, createdAt: $createdAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.serviceFee, serviceFee) ||
                other.serviceFee == serviceFee) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentSessionId, paymentSessionId) ||
                other.paymentSessionId == paymentSessionId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      merchantId,
      deviceId,
      const DeepCollectionEquality().hash(_items),
      subtotal,
      serviceFee,
      total,
      status,
      paymentMethod,
      paymentSessionId,
      notes,
      createdAt,
      completedAt);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderImplToJson(
      this,
    );
  }
}

abstract class _Order implements Order {
  const factory _Order(
      {required final String id,
      required final String merchantId,
      final String? deviceId,
      required final List<OrderItem> items,
      required final double subtotal,
      required final double serviceFee,
      required final double total,
      required final OrderStatus status,
      required final PaymentMethod paymentMethod,
      final String? paymentSessionId,
      final String? notes,
      required final DateTime createdAt,
      final DateTime? completedAt}) = _$OrderImpl;

  factory _Order.fromJson(Map<String, dynamic> json) = _$OrderImpl.fromJson;

  @override
  String get id;
  @override
  String get merchantId;
  @override
  String? get deviceId;
  @override
  List<OrderItem> get items;
  @override
  double get subtotal;
  @override
  double get serviceFee;
  @override
  double get total;
  @override
  OrderStatus get status;
  @override
  PaymentMethod get paymentMethod;
  @override
  String? get paymentSessionId;
  @override
  String? get notes;
  @override
  DateTime get createdAt;
  @override
  DateTime? get completedAt;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return _OrderItem.fromJson(json);
}

/// @nodoc
mixin _$OrderItem {
  String get id => throw _privateConstructorUsedError;
  Product get product => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  List<SelectedModifier> get selectedModifiers =>
      throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemCopyWith<OrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemCopyWith<$Res> {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) then) =
      _$OrderItemCopyWithImpl<$Res, OrderItem>;
  @useResult
  $Res call(
      {String id,
      Product product,
      int quantity,
      double unitPrice,
      double totalPrice,
      List<SelectedModifier> selectedModifiers,
      String? notes});

  $ProductCopyWith<$Res> get product;
}

/// @nodoc
class _$OrderItemCopyWithImpl<$Res, $Val extends OrderItem>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? product = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? selectedModifiers = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Product,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      selectedModifiers: null == selectedModifiers
          ? _value.selectedModifiers
          : selectedModifiers // ignore: cast_nullable_to_non_nullable
              as List<SelectedModifier>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductCopyWith<$Res> get product {
    return $ProductCopyWith<$Res>(_value.product, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderItemImplCopyWith<$Res>
    implements $OrderItemCopyWith<$Res> {
  factory _$$OrderItemImplCopyWith(
          _$OrderItemImpl value, $Res Function(_$OrderItemImpl) then) =
      __$$OrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      Product product,
      int quantity,
      double unitPrice,
      double totalPrice,
      List<SelectedModifier> selectedModifiers,
      String? notes});

  @override
  $ProductCopyWith<$Res> get product;
}

/// @nodoc
class __$$OrderItemImplCopyWithImpl<$Res>
    extends _$OrderItemCopyWithImpl<$Res, _$OrderItemImpl>
    implements _$$OrderItemImplCopyWith<$Res> {
  __$$OrderItemImplCopyWithImpl(
      _$OrderItemImpl _value, $Res Function(_$OrderItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? product = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalPrice = null,
    Object? selectedModifiers = null,
    Object? notes = freezed,
  }) {
    return _then(_$OrderItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Product,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      selectedModifiers: null == selectedModifiers
          ? _value._selectedModifiers
          : selectedModifiers // ignore: cast_nullable_to_non_nullable
              as List<SelectedModifier>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemImpl implements _OrderItem {
  const _$OrderItemImpl(
      {required this.id,
      required this.product,
      required this.quantity,
      required this.unitPrice,
      required this.totalPrice,
      final List<SelectedModifier> selectedModifiers = const [],
      this.notes})
      : _selectedModifiers = selectedModifiers;

  factory _$OrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemImplFromJson(json);

  @override
  final String id;
  @override
  final Product product;
  @override
  final int quantity;
  @override
  final double unitPrice;
  @override
  final double totalPrice;
  final List<SelectedModifier> _selectedModifiers;
  @override
  @JsonKey()
  List<SelectedModifier> get selectedModifiers {
    if (_selectedModifiers is EqualUnmodifiableListView)
      return _selectedModifiers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedModifiers);
  }

  @override
  final String? notes;

  @override
  String toString() {
    return 'OrderItem(id: $id, product: $product, quantity: $quantity, unitPrice: $unitPrice, totalPrice: $totalPrice, selectedModifiers: $selectedModifiers, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            const DeepCollectionEquality()
                .equals(other._selectedModifiers, _selectedModifiers) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      product,
      quantity,
      unitPrice,
      totalPrice,
      const DeepCollectionEquality().hash(_selectedModifiers),
      notes);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      __$$OrderItemImplCopyWithImpl<_$OrderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemImplToJson(
      this,
    );
  }
}

abstract class _OrderItem implements OrderItem {
  const factory _OrderItem(
      {required final String id,
      required final Product product,
      required final int quantity,
      required final double unitPrice,
      required final double totalPrice,
      final List<SelectedModifier> selectedModifiers,
      final String? notes}) = _$OrderItemImpl;

  factory _OrderItem.fromJson(Map<String, dynamic> json) =
      _$OrderItemImpl.fromJson;

  @override
  String get id;
  @override
  Product get product;
  @override
  int get quantity;
  @override
  double get unitPrice;
  @override
  double get totalPrice;
  @override
  List<SelectedModifier> get selectedModifiers;
  @override
  String? get notes;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SelectedModifier _$SelectedModifierFromJson(Map<String, dynamic> json) {
  return _SelectedModifier.fromJson(json);
}

/// @nodoc
mixin _$SelectedModifier {
  String get modifierGroupId => throw _privateConstructorUsedError;
  String get modifierGroupName => throw _privateConstructorUsedError;
  Modifier get modifier => throw _privateConstructorUsedError;

  /// Serializes this SelectedModifier to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SelectedModifier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SelectedModifierCopyWith<SelectedModifier> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectedModifierCopyWith<$Res> {
  factory $SelectedModifierCopyWith(
          SelectedModifier value, $Res Function(SelectedModifier) then) =
      _$SelectedModifierCopyWithImpl<$Res, SelectedModifier>;
  @useResult
  $Res call(
      {String modifierGroupId, String modifierGroupName, Modifier modifier});

  $ModifierCopyWith<$Res> get modifier;
}

/// @nodoc
class _$SelectedModifierCopyWithImpl<$Res, $Val extends SelectedModifier>
    implements $SelectedModifierCopyWith<$Res> {
  _$SelectedModifierCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SelectedModifier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modifierGroupId = null,
    Object? modifierGroupName = null,
    Object? modifier = null,
  }) {
    return _then(_value.copyWith(
      modifierGroupId: null == modifierGroupId
          ? _value.modifierGroupId
          : modifierGroupId // ignore: cast_nullable_to_non_nullable
              as String,
      modifierGroupName: null == modifierGroupName
          ? _value.modifierGroupName
          : modifierGroupName // ignore: cast_nullable_to_non_nullable
              as String,
      modifier: null == modifier
          ? _value.modifier
          : modifier // ignore: cast_nullable_to_non_nullable
              as Modifier,
    ) as $Val);
  }

  /// Create a copy of SelectedModifier
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ModifierCopyWith<$Res> get modifier {
    return $ModifierCopyWith<$Res>(_value.modifier, (value) {
      return _then(_value.copyWith(modifier: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SelectedModifierImplCopyWith<$Res>
    implements $SelectedModifierCopyWith<$Res> {
  factory _$$SelectedModifierImplCopyWith(_$SelectedModifierImpl value,
          $Res Function(_$SelectedModifierImpl) then) =
      __$$SelectedModifierImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String modifierGroupId, String modifierGroupName, Modifier modifier});

  @override
  $ModifierCopyWith<$Res> get modifier;
}

/// @nodoc
class __$$SelectedModifierImplCopyWithImpl<$Res>
    extends _$SelectedModifierCopyWithImpl<$Res, _$SelectedModifierImpl>
    implements _$$SelectedModifierImplCopyWith<$Res> {
  __$$SelectedModifierImplCopyWithImpl(_$SelectedModifierImpl _value,
      $Res Function(_$SelectedModifierImpl) _then)
      : super(_value, _then);

  /// Create a copy of SelectedModifier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modifierGroupId = null,
    Object? modifierGroupName = null,
    Object? modifier = null,
  }) {
    return _then(_$SelectedModifierImpl(
      modifierGroupId: null == modifierGroupId
          ? _value.modifierGroupId
          : modifierGroupId // ignore: cast_nullable_to_non_nullable
              as String,
      modifierGroupName: null == modifierGroupName
          ? _value.modifierGroupName
          : modifierGroupName // ignore: cast_nullable_to_non_nullable
              as String,
      modifier: null == modifier
          ? _value.modifier
          : modifier // ignore: cast_nullable_to_non_nullable
              as Modifier,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SelectedModifierImpl implements _SelectedModifier {
  const _$SelectedModifierImpl(
      {required this.modifierGroupId,
      required this.modifierGroupName,
      required this.modifier});

  factory _$SelectedModifierImpl.fromJson(Map<String, dynamic> json) =>
      _$$SelectedModifierImplFromJson(json);

  @override
  final String modifierGroupId;
  @override
  final String modifierGroupName;
  @override
  final Modifier modifier;

  @override
  String toString() {
    return 'SelectedModifier(modifierGroupId: $modifierGroupId, modifierGroupName: $modifierGroupName, modifier: $modifier)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectedModifierImpl &&
            (identical(other.modifierGroupId, modifierGroupId) ||
                other.modifierGroupId == modifierGroupId) &&
            (identical(other.modifierGroupName, modifierGroupName) ||
                other.modifierGroupName == modifierGroupName) &&
            (identical(other.modifier, modifier) ||
                other.modifier == modifier));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, modifierGroupId, modifierGroupName, modifier);

  /// Create a copy of SelectedModifier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectedModifierImplCopyWith<_$SelectedModifierImpl> get copyWith =>
      __$$SelectedModifierImplCopyWithImpl<_$SelectedModifierImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SelectedModifierImplToJson(
      this,
    );
  }
}

abstract class _SelectedModifier implements SelectedModifier {
  const factory _SelectedModifier(
      {required final String modifierGroupId,
      required final String modifierGroupName,
      required final Modifier modifier}) = _$SelectedModifierImpl;

  factory _SelectedModifier.fromJson(Map<String, dynamic> json) =
      _$SelectedModifierImpl.fromJson;

  @override
  String get modifierGroupId;
  @override
  String get modifierGroupName;
  @override
  Modifier get modifier;

  /// Create a copy of SelectedModifier
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectedModifierImplCopyWith<_$SelectedModifierImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
