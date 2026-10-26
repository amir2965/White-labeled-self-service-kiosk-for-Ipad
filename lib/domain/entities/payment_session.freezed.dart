// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentSession _$PaymentSessionFromJson(Map<String, dynamic> json) {
  return _PaymentSession.fromJson(json);
}

/// @nodoc
mixin _$PaymentSession {
  String get id => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;
  String get merchantId => throw _privateConstructorUsedError;
  double get amountItems => throw _privateConstructorUsedError;
  double get feeAmount => throw _privateConstructorUsedError;
  double get amountTotal => throw _privateConstructorUsedError;
  PaymentSessionStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  DateTime? get paidAt => throw _privateConstructorUsedError;
  String? get paymentIntentId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this PaymentSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentSessionCopyWith<PaymentSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentSessionCopyWith<$Res> {
  factory $PaymentSessionCopyWith(
          PaymentSession value, $Res Function(PaymentSession) then) =
      _$PaymentSessionCopyWithImpl<$Res, PaymentSession>;
  @useResult
  $Res call(
      {String id,
      String orderId,
      String merchantId,
      double amountItems,
      double feeAmount,
      double amountTotal,
      PaymentSessionStatus status,
      DateTime createdAt,
      DateTime expiresAt,
      DateTime? paidAt,
      String? paymentIntentId,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$PaymentSessionCopyWithImpl<$Res, $Val extends PaymentSession>
    implements $PaymentSessionCopyWith<$Res> {
  _$PaymentSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? merchantId = null,
    Object? amountItems = null,
    Object? feeAmount = null,
    Object? amountTotal = null,
    Object? status = null,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? paidAt = freezed,
    Object? paymentIntentId = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      amountItems: null == amountItems
          ? _value.amountItems
          : amountItems // ignore: cast_nullable_to_non_nullable
              as double,
      feeAmount: null == feeAmount
          ? _value.feeAmount
          : feeAmount // ignore: cast_nullable_to_non_nullable
              as double,
      amountTotal: null == amountTotal
          ? _value.amountTotal
          : amountTotal // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentSessionStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paymentIntentId: freezed == paymentIntentId
          ? _value.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentSessionImplCopyWith<$Res>
    implements $PaymentSessionCopyWith<$Res> {
  factory _$$PaymentSessionImplCopyWith(_$PaymentSessionImpl value,
          $Res Function(_$PaymentSessionImpl) then) =
      __$$PaymentSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String orderId,
      String merchantId,
      double amountItems,
      double feeAmount,
      double amountTotal,
      PaymentSessionStatus status,
      DateTime createdAt,
      DateTime expiresAt,
      DateTime? paidAt,
      String? paymentIntentId,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$PaymentSessionImplCopyWithImpl<$Res>
    extends _$PaymentSessionCopyWithImpl<$Res, _$PaymentSessionImpl>
    implements _$$PaymentSessionImplCopyWith<$Res> {
  __$$PaymentSessionImplCopyWithImpl(
      _$PaymentSessionImpl _value, $Res Function(_$PaymentSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? merchantId = null,
    Object? amountItems = null,
    Object? feeAmount = null,
    Object? amountTotal = null,
    Object? status = null,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? paidAt = freezed,
    Object? paymentIntentId = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$PaymentSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      amountItems: null == amountItems
          ? _value.amountItems
          : amountItems // ignore: cast_nullable_to_non_nullable
              as double,
      feeAmount: null == feeAmount
          ? _value.feeAmount
          : feeAmount // ignore: cast_nullable_to_non_nullable
              as double,
      amountTotal: null == amountTotal
          ? _value.amountTotal
          : amountTotal // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentSessionStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paymentIntentId: freezed == paymentIntentId
          ? _value.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentSessionImpl implements _PaymentSession {
  const _$PaymentSessionImpl(
      {required this.id,
      required this.orderId,
      required this.merchantId,
      required this.amountItems,
      required this.feeAmount,
      required this.amountTotal,
      required this.status,
      required this.createdAt,
      required this.expiresAt,
      this.paidAt,
      this.paymentIntentId,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$PaymentSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String orderId;
  @override
  final String merchantId;
  @override
  final double amountItems;
  @override
  final double feeAmount;
  @override
  final double amountTotal;
  @override
  final PaymentSessionStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime expiresAt;
  @override
  final DateTime? paidAt;
  @override
  final String? paymentIntentId;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PaymentSession(id: $id, orderId: $orderId, merchantId: $merchantId, amountItems: $amountItems, feeAmount: $feeAmount, amountTotal: $amountTotal, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, paidAt: $paidAt, paymentIntentId: $paymentIntentId, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.amountItems, amountItems) ||
                other.amountItems == amountItems) &&
            (identical(other.feeAmount, feeAmount) ||
                other.feeAmount == feeAmount) &&
            (identical(other.amountTotal, amountTotal) ||
                other.amountTotal == amountTotal) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.paymentIntentId, paymentIntentId) ||
                other.paymentIntentId == paymentIntentId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderId,
      merchantId,
      amountItems,
      feeAmount,
      amountTotal,
      status,
      createdAt,
      expiresAt,
      paidAt,
      paymentIntentId,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of PaymentSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentSessionImplCopyWith<_$PaymentSessionImpl> get copyWith =>
      __$$PaymentSessionImplCopyWithImpl<_$PaymentSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentSessionImplToJson(
      this,
    );
  }
}

abstract class _PaymentSession implements PaymentSession {
  const factory _PaymentSession(
      {required final String id,
      required final String orderId,
      required final String merchantId,
      required final double amountItems,
      required final double feeAmount,
      required final double amountTotal,
      required final PaymentSessionStatus status,
      required final DateTime createdAt,
      required final DateTime expiresAt,
      final DateTime? paidAt,
      final String? paymentIntentId,
      final Map<String, dynamic>? metadata}) = _$PaymentSessionImpl;

  factory _PaymentSession.fromJson(Map<String, dynamic> json) =
      _$PaymentSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get orderId;
  @override
  String get merchantId;
  @override
  double get amountItems;
  @override
  double get feeAmount;
  @override
  double get amountTotal;
  @override
  PaymentSessionStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime get expiresAt;
  @override
  DateTime? get paidAt;
  @override
  String? get paymentIntentId;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of PaymentSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentSessionImplCopyWith<_$PaymentSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
