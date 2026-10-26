// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merchant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Merchant _$MerchantFromJson(Map<String, dynamic> json) {
  return _Merchant.fromJson(json);
}

/// @nodoc
mixin _$Merchant {
  String get id => throw _privateConstructorUsedError;
  String get businessName => throw _privateConstructorUsedError;
  String? get abn => throw _privateConstructorUsedError;
  String get contactEmail => throw _privateConstructorUsedError;
  BusinessType get businessType => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  PaymentConfig? get paymentConfig => throw _privateConstructorUsedError;

  /// Serializes this Merchant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Merchant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MerchantCopyWith<Merchant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MerchantCopyWith<$Res> {
  factory $MerchantCopyWith(Merchant value, $Res Function(Merchant) then) =
      _$MerchantCopyWithImpl<$Res, Merchant>;
  @useResult
  $Res call(
      {String id,
      String businessName,
      String? abn,
      String contactEmail,
      BusinessType businessType,
      DateTime createdAt,
      bool isActive,
      PaymentConfig? paymentConfig});

  $PaymentConfigCopyWith<$Res>? get paymentConfig;
}

/// @nodoc
class _$MerchantCopyWithImpl<$Res, $Val extends Merchant>
    implements $MerchantCopyWith<$Res> {
  _$MerchantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Merchant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessName = null,
    Object? abn = freezed,
    Object? contactEmail = null,
    Object? businessType = null,
    Object? createdAt = null,
    Object? isActive = null,
    Object? paymentConfig = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      businessName: null == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String,
      abn: freezed == abn
          ? _value.abn
          : abn // ignore: cast_nullable_to_non_nullable
              as String?,
      contactEmail: null == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String,
      businessType: null == businessType
          ? _value.businessType
          : businessType // ignore: cast_nullable_to_non_nullable
              as BusinessType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      paymentConfig: freezed == paymentConfig
          ? _value.paymentConfig
          : paymentConfig // ignore: cast_nullable_to_non_nullable
              as PaymentConfig?,
    ) as $Val);
  }

  /// Create a copy of Merchant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaymentConfigCopyWith<$Res>? get paymentConfig {
    if (_value.paymentConfig == null) {
      return null;
    }

    return $PaymentConfigCopyWith<$Res>(_value.paymentConfig!, (value) {
      return _then(_value.copyWith(paymentConfig: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MerchantImplCopyWith<$Res>
    implements $MerchantCopyWith<$Res> {
  factory _$$MerchantImplCopyWith(
          _$MerchantImpl value, $Res Function(_$MerchantImpl) then) =
      __$$MerchantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String businessName,
      String? abn,
      String contactEmail,
      BusinessType businessType,
      DateTime createdAt,
      bool isActive,
      PaymentConfig? paymentConfig});

  @override
  $PaymentConfigCopyWith<$Res>? get paymentConfig;
}

/// @nodoc
class __$$MerchantImplCopyWithImpl<$Res>
    extends _$MerchantCopyWithImpl<$Res, _$MerchantImpl>
    implements _$$MerchantImplCopyWith<$Res> {
  __$$MerchantImplCopyWithImpl(
      _$MerchantImpl _value, $Res Function(_$MerchantImpl) _then)
      : super(_value, _then);

  /// Create a copy of Merchant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessName = null,
    Object? abn = freezed,
    Object? contactEmail = null,
    Object? businessType = null,
    Object? createdAt = null,
    Object? isActive = null,
    Object? paymentConfig = freezed,
  }) {
    return _then(_$MerchantImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      businessName: null == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String,
      abn: freezed == abn
          ? _value.abn
          : abn // ignore: cast_nullable_to_non_nullable
              as String?,
      contactEmail: null == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String,
      businessType: null == businessType
          ? _value.businessType
          : businessType // ignore: cast_nullable_to_non_nullable
              as BusinessType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      paymentConfig: freezed == paymentConfig
          ? _value.paymentConfig
          : paymentConfig // ignore: cast_nullable_to_non_nullable
              as PaymentConfig?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MerchantImpl implements _Merchant {
  const _$MerchantImpl(
      {required this.id,
      required this.businessName,
      this.abn,
      required this.contactEmail,
      required this.businessType,
      required this.createdAt,
      required this.isActive,
      this.paymentConfig});

  factory _$MerchantImpl.fromJson(Map<String, dynamic> json) =>
      _$$MerchantImplFromJson(json);

  @override
  final String id;
  @override
  final String businessName;
  @override
  final String? abn;
  @override
  final String contactEmail;
  @override
  final BusinessType businessType;
  @override
  final DateTime createdAt;
  @override
  final bool isActive;
  @override
  final PaymentConfig? paymentConfig;

  @override
  String toString() {
    return 'Merchant(id: $id, businessName: $businessName, abn: $abn, contactEmail: $contactEmail, businessType: $businessType, createdAt: $createdAt, isActive: $isActive, paymentConfig: $paymentConfig)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MerchantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.abn, abn) || other.abn == abn) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.businessType, businessType) ||
                other.businessType == businessType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.paymentConfig, paymentConfig) ||
                other.paymentConfig == paymentConfig));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, businessName, abn,
      contactEmail, businessType, createdAt, isActive, paymentConfig);

  /// Create a copy of Merchant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MerchantImplCopyWith<_$MerchantImpl> get copyWith =>
      __$$MerchantImplCopyWithImpl<_$MerchantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MerchantImplToJson(
      this,
    );
  }
}

abstract class _Merchant implements Merchant {
  const factory _Merchant(
      {required final String id,
      required final String businessName,
      final String? abn,
      required final String contactEmail,
      required final BusinessType businessType,
      required final DateTime createdAt,
      required final bool isActive,
      final PaymentConfig? paymentConfig}) = _$MerchantImpl;

  factory _Merchant.fromJson(Map<String, dynamic> json) =
      _$MerchantImpl.fromJson;

  @override
  String get id;
  @override
  String get businessName;
  @override
  String? get abn;
  @override
  String get contactEmail;
  @override
  BusinessType get businessType;
  @override
  DateTime get createdAt;
  @override
  bool get isActive;
  @override
  PaymentConfig? get paymentConfig;

  /// Create a copy of Merchant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MerchantImplCopyWith<_$MerchantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentConfig _$PaymentConfigFromJson(Map<String, dynamic> json) {
  return _PaymentConfig.fromJson(json);
}

/// @nodoc
mixin _$PaymentConfig {
  bool get payAtCounterEnabled => throw _privateConstructorUsedError;
  bool get qrPayEnabled => throw _privateConstructorUsedError;
  double get serviceFeePercent => throw _privateConstructorUsedError;
  double get serviceFeeFixed => throw _privateConstructorUsedError;

  /// Serializes this PaymentConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentConfigCopyWith<PaymentConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentConfigCopyWith<$Res> {
  factory $PaymentConfigCopyWith(
          PaymentConfig value, $Res Function(PaymentConfig) then) =
      _$PaymentConfigCopyWithImpl<$Res, PaymentConfig>;
  @useResult
  $Res call(
      {bool payAtCounterEnabled,
      bool qrPayEnabled,
      double serviceFeePercent,
      double serviceFeeFixed});
}

/// @nodoc
class _$PaymentConfigCopyWithImpl<$Res, $Val extends PaymentConfig>
    implements $PaymentConfigCopyWith<$Res> {
  _$PaymentConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? payAtCounterEnabled = null,
    Object? qrPayEnabled = null,
    Object? serviceFeePercent = null,
    Object? serviceFeeFixed = null,
  }) {
    return _then(_value.copyWith(
      payAtCounterEnabled: null == payAtCounterEnabled
          ? _value.payAtCounterEnabled
          : payAtCounterEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      qrPayEnabled: null == qrPayEnabled
          ? _value.qrPayEnabled
          : qrPayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      serviceFeePercent: null == serviceFeePercent
          ? _value.serviceFeePercent
          : serviceFeePercent // ignore: cast_nullable_to_non_nullable
              as double,
      serviceFeeFixed: null == serviceFeeFixed
          ? _value.serviceFeeFixed
          : serviceFeeFixed // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentConfigImplCopyWith<$Res>
    implements $PaymentConfigCopyWith<$Res> {
  factory _$$PaymentConfigImplCopyWith(
          _$PaymentConfigImpl value, $Res Function(_$PaymentConfigImpl) then) =
      __$$PaymentConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool payAtCounterEnabled,
      bool qrPayEnabled,
      double serviceFeePercent,
      double serviceFeeFixed});
}

/// @nodoc
class __$$PaymentConfigImplCopyWithImpl<$Res>
    extends _$PaymentConfigCopyWithImpl<$Res, _$PaymentConfigImpl>
    implements _$$PaymentConfigImplCopyWith<$Res> {
  __$$PaymentConfigImplCopyWithImpl(
      _$PaymentConfigImpl _value, $Res Function(_$PaymentConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? payAtCounterEnabled = null,
    Object? qrPayEnabled = null,
    Object? serviceFeePercent = null,
    Object? serviceFeeFixed = null,
  }) {
    return _then(_$PaymentConfigImpl(
      payAtCounterEnabled: null == payAtCounterEnabled
          ? _value.payAtCounterEnabled
          : payAtCounterEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      qrPayEnabled: null == qrPayEnabled
          ? _value.qrPayEnabled
          : qrPayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      serviceFeePercent: null == serviceFeePercent
          ? _value.serviceFeePercent
          : serviceFeePercent // ignore: cast_nullable_to_non_nullable
              as double,
      serviceFeeFixed: null == serviceFeeFixed
          ? _value.serviceFeeFixed
          : serviceFeeFixed // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentConfigImpl implements _PaymentConfig {
  const _$PaymentConfigImpl(
      {required this.payAtCounterEnabled,
      required this.qrPayEnabled,
      this.serviceFeePercent = 2.0,
      this.serviceFeeFixed = 0.0});

  factory _$PaymentConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentConfigImplFromJson(json);

  @override
  final bool payAtCounterEnabled;
  @override
  final bool qrPayEnabled;
  @override
  @JsonKey()
  final double serviceFeePercent;
  @override
  @JsonKey()
  final double serviceFeeFixed;

  @override
  String toString() {
    return 'PaymentConfig(payAtCounterEnabled: $payAtCounterEnabled, qrPayEnabled: $qrPayEnabled, serviceFeePercent: $serviceFeePercent, serviceFeeFixed: $serviceFeeFixed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentConfigImpl &&
            (identical(other.payAtCounterEnabled, payAtCounterEnabled) ||
                other.payAtCounterEnabled == payAtCounterEnabled) &&
            (identical(other.qrPayEnabled, qrPayEnabled) ||
                other.qrPayEnabled == qrPayEnabled) &&
            (identical(other.serviceFeePercent, serviceFeePercent) ||
                other.serviceFeePercent == serviceFeePercent) &&
            (identical(other.serviceFeeFixed, serviceFeeFixed) ||
                other.serviceFeeFixed == serviceFeeFixed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, payAtCounterEnabled,
      qrPayEnabled, serviceFeePercent, serviceFeeFixed);

  /// Create a copy of PaymentConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentConfigImplCopyWith<_$PaymentConfigImpl> get copyWith =>
      __$$PaymentConfigImplCopyWithImpl<_$PaymentConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentConfigImplToJson(
      this,
    );
  }
}

abstract class _PaymentConfig implements PaymentConfig {
  const factory _PaymentConfig(
      {required final bool payAtCounterEnabled,
      required final bool qrPayEnabled,
      final double serviceFeePercent,
      final double serviceFeeFixed}) = _$PaymentConfigImpl;

  factory _PaymentConfig.fromJson(Map<String, dynamic> json) =
      _$PaymentConfigImpl.fromJson;

  @override
  bool get payAtCounterEnabled;
  @override
  bool get qrPayEnabled;
  @override
  double get serviceFeePercent;
  @override
  double get serviceFeeFixed;

  /// Create a copy of PaymentConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentConfigImplCopyWith<_$PaymentConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
