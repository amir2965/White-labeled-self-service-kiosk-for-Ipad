// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fee_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FeeSummary _$FeeSummaryFromJson(Map<String, dynamic> json) {
  return _FeeSummary.fromJson(json);
}

/// @nodoc
mixin _$FeeSummary {
  /// Total service fees deducted
  double get totalServiceFees => throw _privateConstructorUsedError;

  /// Average fee percentage across all transactions
  double get averageFeePercent => throw _privateConstructorUsedError;

  /// Effective fee rate (total fees / total sales)
  double get effectiveFeeRate => throw _privateConstructorUsedError;

  /// Total gross sales in the period
  double get grossSales => throw _privateConstructorUsedError;

  /// Net amount before GST (gross - fees)
  double get netBeforeGst => throw _privateConstructorUsedError;

  /// Serializes this FeeSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeeSummaryCopyWith<FeeSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeeSummaryCopyWith<$Res> {
  factory $FeeSummaryCopyWith(
          FeeSummary value, $Res Function(FeeSummary) then) =
      _$FeeSummaryCopyWithImpl<$Res, FeeSummary>;
  @useResult
  $Res call(
      {double totalServiceFees,
      double averageFeePercent,
      double effectiveFeeRate,
      double grossSales,
      double netBeforeGst});
}

/// @nodoc
class _$FeeSummaryCopyWithImpl<$Res, $Val extends FeeSummary>
    implements $FeeSummaryCopyWith<$Res> {
  _$FeeSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalServiceFees = null,
    Object? averageFeePercent = null,
    Object? effectiveFeeRate = null,
    Object? grossSales = null,
    Object? netBeforeGst = null,
  }) {
    return _then(_value.copyWith(
      totalServiceFees: null == totalServiceFees
          ? _value.totalServiceFees
          : totalServiceFees // ignore: cast_nullable_to_non_nullable
              as double,
      averageFeePercent: null == averageFeePercent
          ? _value.averageFeePercent
          : averageFeePercent // ignore: cast_nullable_to_non_nullable
              as double,
      effectiveFeeRate: null == effectiveFeeRate
          ? _value.effectiveFeeRate
          : effectiveFeeRate // ignore: cast_nullable_to_non_nullable
              as double,
      grossSales: null == grossSales
          ? _value.grossSales
          : grossSales // ignore: cast_nullable_to_non_nullable
              as double,
      netBeforeGst: null == netBeforeGst
          ? _value.netBeforeGst
          : netBeforeGst // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeeSummaryImplCopyWith<$Res>
    implements $FeeSummaryCopyWith<$Res> {
  factory _$$FeeSummaryImplCopyWith(
          _$FeeSummaryImpl value, $Res Function(_$FeeSummaryImpl) then) =
      __$$FeeSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double totalServiceFees,
      double averageFeePercent,
      double effectiveFeeRate,
      double grossSales,
      double netBeforeGst});
}

/// @nodoc
class __$$FeeSummaryImplCopyWithImpl<$Res>
    extends _$FeeSummaryCopyWithImpl<$Res, _$FeeSummaryImpl>
    implements _$$FeeSummaryImplCopyWith<$Res> {
  __$$FeeSummaryImplCopyWithImpl(
      _$FeeSummaryImpl _value, $Res Function(_$FeeSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalServiceFees = null,
    Object? averageFeePercent = null,
    Object? effectiveFeeRate = null,
    Object? grossSales = null,
    Object? netBeforeGst = null,
  }) {
    return _then(_$FeeSummaryImpl(
      totalServiceFees: null == totalServiceFees
          ? _value.totalServiceFees
          : totalServiceFees // ignore: cast_nullable_to_non_nullable
              as double,
      averageFeePercent: null == averageFeePercent
          ? _value.averageFeePercent
          : averageFeePercent // ignore: cast_nullable_to_non_nullable
              as double,
      effectiveFeeRate: null == effectiveFeeRate
          ? _value.effectiveFeeRate
          : effectiveFeeRate // ignore: cast_nullable_to_non_nullable
              as double,
      grossSales: null == grossSales
          ? _value.grossSales
          : grossSales // ignore: cast_nullable_to_non_nullable
              as double,
      netBeforeGst: null == netBeforeGst
          ? _value.netBeforeGst
          : netBeforeGst // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeeSummaryImpl implements _FeeSummary {
  const _$FeeSummaryImpl(
      {required this.totalServiceFees,
      required this.averageFeePercent,
      required this.effectiveFeeRate,
      required this.grossSales,
      required this.netBeforeGst});

  factory _$FeeSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeeSummaryImplFromJson(json);

  /// Total service fees deducted
  @override
  final double totalServiceFees;

  /// Average fee percentage across all transactions
  @override
  final double averageFeePercent;

  /// Effective fee rate (total fees / total sales)
  @override
  final double effectiveFeeRate;

  /// Total gross sales in the period
  @override
  final double grossSales;

  /// Net amount before GST (gross - fees)
  @override
  final double netBeforeGst;

  @override
  String toString() {
    return 'FeeSummary(totalServiceFees: $totalServiceFees, averageFeePercent: $averageFeePercent, effectiveFeeRate: $effectiveFeeRate, grossSales: $grossSales, netBeforeGst: $netBeforeGst)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeeSummaryImpl &&
            (identical(other.totalServiceFees, totalServiceFees) ||
                other.totalServiceFees == totalServiceFees) &&
            (identical(other.averageFeePercent, averageFeePercent) ||
                other.averageFeePercent == averageFeePercent) &&
            (identical(other.effectiveFeeRate, effectiveFeeRate) ||
                other.effectiveFeeRate == effectiveFeeRate) &&
            (identical(other.grossSales, grossSales) ||
                other.grossSales == grossSales) &&
            (identical(other.netBeforeGst, netBeforeGst) ||
                other.netBeforeGst == netBeforeGst));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalServiceFees,
      averageFeePercent, effectiveFeeRate, grossSales, netBeforeGst);

  /// Create a copy of FeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeeSummaryImplCopyWith<_$FeeSummaryImpl> get copyWith =>
      __$$FeeSummaryImplCopyWithImpl<_$FeeSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeeSummaryImplToJson(
      this,
    );
  }
}

abstract class _FeeSummary implements FeeSummary {
  const factory _FeeSummary(
      {required final double totalServiceFees,
      required final double averageFeePercent,
      required final double effectiveFeeRate,
      required final double grossSales,
      required final double netBeforeGst}) = _$FeeSummaryImpl;

  factory _FeeSummary.fromJson(Map<String, dynamic> json) =
      _$FeeSummaryImpl.fromJson;

  /// Total service fees deducted
  @override
  double get totalServiceFees;

  /// Average fee percentage across all transactions
  @override
  double get averageFeePercent;

  /// Effective fee rate (total fees / total sales)
  @override
  double get effectiveFeeRate;

  /// Total gross sales in the period
  @override
  double get grossSales;

  /// Net amount before GST (gross - fees)
  @override
  double get netBeforeGst;

  /// Create a copy of FeeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeeSummaryImplCopyWith<_$FeeSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeeBreakdown _$FeeBreakdownFromJson(Map<String, dynamic> json) {
  return _FeeBreakdown.fromJson(json);
}

/// @nodoc
mixin _$FeeBreakdown {
  /// Gross sales amount
  double get grossSales => throw _privateConstructorUsedError;

  /// Platform fee amount (negative value for display)
  double get platformFee => throw _privateConstructorUsedError;

  /// Platform fee percentage
  double get feePercent => throw _privateConstructorUsedError;

  /// Net amount before GST (gross - fees)
  double get netBeforeGst => throw _privateConstructorUsedError;

  /// Serializes this FeeBreakdown to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeeBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeeBreakdownCopyWith<FeeBreakdown> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeeBreakdownCopyWith<$Res> {
  factory $FeeBreakdownCopyWith(
          FeeBreakdown value, $Res Function(FeeBreakdown) then) =
      _$FeeBreakdownCopyWithImpl<$Res, FeeBreakdown>;
  @useResult
  $Res call(
      {double grossSales,
      double platformFee,
      double feePercent,
      double netBeforeGst});
}

/// @nodoc
class _$FeeBreakdownCopyWithImpl<$Res, $Val extends FeeBreakdown>
    implements $FeeBreakdownCopyWith<$Res> {
  _$FeeBreakdownCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeeBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grossSales = null,
    Object? platformFee = null,
    Object? feePercent = null,
    Object? netBeforeGst = null,
  }) {
    return _then(_value.copyWith(
      grossSales: null == grossSales
          ? _value.grossSales
          : grossSales // ignore: cast_nullable_to_non_nullable
              as double,
      platformFee: null == platformFee
          ? _value.platformFee
          : platformFee // ignore: cast_nullable_to_non_nullable
              as double,
      feePercent: null == feePercent
          ? _value.feePercent
          : feePercent // ignore: cast_nullable_to_non_nullable
              as double,
      netBeforeGst: null == netBeforeGst
          ? _value.netBeforeGst
          : netBeforeGst // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeeBreakdownImplCopyWith<$Res>
    implements $FeeBreakdownCopyWith<$Res> {
  factory _$$FeeBreakdownImplCopyWith(
          _$FeeBreakdownImpl value, $Res Function(_$FeeBreakdownImpl) then) =
      __$$FeeBreakdownImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double grossSales,
      double platformFee,
      double feePercent,
      double netBeforeGst});
}

/// @nodoc
class __$$FeeBreakdownImplCopyWithImpl<$Res>
    extends _$FeeBreakdownCopyWithImpl<$Res, _$FeeBreakdownImpl>
    implements _$$FeeBreakdownImplCopyWith<$Res> {
  __$$FeeBreakdownImplCopyWithImpl(
      _$FeeBreakdownImpl _value, $Res Function(_$FeeBreakdownImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeeBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grossSales = null,
    Object? platformFee = null,
    Object? feePercent = null,
    Object? netBeforeGst = null,
  }) {
    return _then(_$FeeBreakdownImpl(
      grossSales: null == grossSales
          ? _value.grossSales
          : grossSales // ignore: cast_nullable_to_non_nullable
              as double,
      platformFee: null == platformFee
          ? _value.platformFee
          : platformFee // ignore: cast_nullable_to_non_nullable
              as double,
      feePercent: null == feePercent
          ? _value.feePercent
          : feePercent // ignore: cast_nullable_to_non_nullable
              as double,
      netBeforeGst: null == netBeforeGst
          ? _value.netBeforeGst
          : netBeforeGst // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeeBreakdownImpl implements _FeeBreakdown {
  const _$FeeBreakdownImpl(
      {required this.grossSales,
      required this.platformFee,
      required this.feePercent,
      required this.netBeforeGst});

  factory _$FeeBreakdownImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeeBreakdownImplFromJson(json);

  /// Gross sales amount
  @override
  final double grossSales;

  /// Platform fee amount (negative value for display)
  @override
  final double platformFee;

  /// Platform fee percentage
  @override
  final double feePercent;

  /// Net amount before GST (gross - fees)
  @override
  final double netBeforeGst;

  @override
  String toString() {
    return 'FeeBreakdown(grossSales: $grossSales, platformFee: $platformFee, feePercent: $feePercent, netBeforeGst: $netBeforeGst)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeeBreakdownImpl &&
            (identical(other.grossSales, grossSales) ||
                other.grossSales == grossSales) &&
            (identical(other.platformFee, platformFee) ||
                other.platformFee == platformFee) &&
            (identical(other.feePercent, feePercent) ||
                other.feePercent == feePercent) &&
            (identical(other.netBeforeGst, netBeforeGst) ||
                other.netBeforeGst == netBeforeGst));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, grossSales, platformFee, feePercent, netBeforeGst);

  /// Create a copy of FeeBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeeBreakdownImplCopyWith<_$FeeBreakdownImpl> get copyWith =>
      __$$FeeBreakdownImplCopyWithImpl<_$FeeBreakdownImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeeBreakdownImplToJson(
      this,
    );
  }
}

abstract class _FeeBreakdown implements FeeBreakdown {
  const factory _FeeBreakdown(
      {required final double grossSales,
      required final double platformFee,
      required final double feePercent,
      required final double netBeforeGst}) = _$FeeBreakdownImpl;

  factory _FeeBreakdown.fromJson(Map<String, dynamic> json) =
      _$FeeBreakdownImpl.fromJson;

  /// Gross sales amount
  @override
  double get grossSales;

  /// Platform fee amount (negative value for display)
  @override
  double get platformFee;

  /// Platform fee percentage
  @override
  double get feePercent;

  /// Net amount before GST (gross - fees)
  @override
  double get netBeforeGst;

  /// Create a copy of FeeBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeeBreakdownImplCopyWith<_$FeeBreakdownImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeeTransaction _$FeeTransactionFromJson(Map<String, dynamic> json) {
  return _FeeTransaction.fromJson(json);
}

/// @nodoc
mixin _$FeeTransaction {
  /// Transaction date
  DateTime get date => throw _privateConstructorUsedError;

  /// Order ID or transaction reference
  String get orderId => throw _privateConstructorUsedError;

  /// Gross transaction amount
  double get grossAmount => throw _privateConstructorUsedError;

  /// Service fee deducted
  double get serviceFee => throw _privateConstructorUsedError;

  /// Fee percentage for this transaction
  double get feePercent => throw _privateConstructorUsedError;

  /// Serializes this FeeTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeeTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeeTransactionCopyWith<FeeTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeeTransactionCopyWith<$Res> {
  factory $FeeTransactionCopyWith(
          FeeTransaction value, $Res Function(FeeTransaction) then) =
      _$FeeTransactionCopyWithImpl<$Res, FeeTransaction>;
  @useResult
  $Res call(
      {DateTime date,
      String orderId,
      double grossAmount,
      double serviceFee,
      double feePercent});
}

/// @nodoc
class _$FeeTransactionCopyWithImpl<$Res, $Val extends FeeTransaction>
    implements $FeeTransactionCopyWith<$Res> {
  _$FeeTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeeTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? orderId = null,
    Object? grossAmount = null,
    Object? serviceFee = null,
    Object? feePercent = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      grossAmount: null == grossAmount
          ? _value.grossAmount
          : grossAmount // ignore: cast_nullable_to_non_nullable
              as double,
      serviceFee: null == serviceFee
          ? _value.serviceFee
          : serviceFee // ignore: cast_nullable_to_non_nullable
              as double,
      feePercent: null == feePercent
          ? _value.feePercent
          : feePercent // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeeTransactionImplCopyWith<$Res>
    implements $FeeTransactionCopyWith<$Res> {
  factory _$$FeeTransactionImplCopyWith(_$FeeTransactionImpl value,
          $Res Function(_$FeeTransactionImpl) then) =
      __$$FeeTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      String orderId,
      double grossAmount,
      double serviceFee,
      double feePercent});
}

/// @nodoc
class __$$FeeTransactionImplCopyWithImpl<$Res>
    extends _$FeeTransactionCopyWithImpl<$Res, _$FeeTransactionImpl>
    implements _$$FeeTransactionImplCopyWith<$Res> {
  __$$FeeTransactionImplCopyWithImpl(
      _$FeeTransactionImpl _value, $Res Function(_$FeeTransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeeTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? orderId = null,
    Object? grossAmount = null,
    Object? serviceFee = null,
    Object? feePercent = null,
  }) {
    return _then(_$FeeTransactionImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      grossAmount: null == grossAmount
          ? _value.grossAmount
          : grossAmount // ignore: cast_nullable_to_non_nullable
              as double,
      serviceFee: null == serviceFee
          ? _value.serviceFee
          : serviceFee // ignore: cast_nullable_to_non_nullable
              as double,
      feePercent: null == feePercent
          ? _value.feePercent
          : feePercent // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeeTransactionImpl implements _FeeTransaction {
  const _$FeeTransactionImpl(
      {required this.date,
      required this.orderId,
      required this.grossAmount,
      required this.serviceFee,
      required this.feePercent});

  factory _$FeeTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeeTransactionImplFromJson(json);

  /// Transaction date
  @override
  final DateTime date;

  /// Order ID or transaction reference
  @override
  final String orderId;

  /// Gross transaction amount
  @override
  final double grossAmount;

  /// Service fee deducted
  @override
  final double serviceFee;

  /// Fee percentage for this transaction
  @override
  final double feePercent;

  @override
  String toString() {
    return 'FeeTransaction(date: $date, orderId: $orderId, grossAmount: $grossAmount, serviceFee: $serviceFee, feePercent: $feePercent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeeTransactionImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.grossAmount, grossAmount) ||
                other.grossAmount == grossAmount) &&
            (identical(other.serviceFee, serviceFee) ||
                other.serviceFee == serviceFee) &&
            (identical(other.feePercent, feePercent) ||
                other.feePercent == feePercent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, orderId, grossAmount, serviceFee, feePercent);

  /// Create a copy of FeeTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeeTransactionImplCopyWith<_$FeeTransactionImpl> get copyWith =>
      __$$FeeTransactionImplCopyWithImpl<_$FeeTransactionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeeTransactionImplToJson(
      this,
    );
  }
}

abstract class _FeeTransaction implements FeeTransaction {
  const factory _FeeTransaction(
      {required final DateTime date,
      required final String orderId,
      required final double grossAmount,
      required final double serviceFee,
      required final double feePercent}) = _$FeeTransactionImpl;

  factory _FeeTransaction.fromJson(Map<String, dynamic> json) =
      _$FeeTransactionImpl.fromJson;

  /// Transaction date
  @override
  DateTime get date;

  /// Order ID or transaction reference
  @override
  String get orderId;

  /// Gross transaction amount
  @override
  double get grossAmount;

  /// Service fee deducted
  @override
  double get serviceFee;

  /// Fee percentage for this transaction
  @override
  double get feePercent;

  /// Create a copy of FeeTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeeTransactionImplCopyWith<_$FeeTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ServiceFeesData _$ServiceFeesDataFromJson(Map<String, dynamic> json) {
  return _ServiceFeesData.fromJson(json);
}

/// @nodoc
mixin _$ServiceFeesData {
  FeeSummary get summary => throw _privateConstructorUsedError;
  FeeBreakdown get breakdown => throw _privateConstructorUsedError;
  List<FeeTransaction> get transactions => throw _privateConstructorUsedError;

  /// Serializes this ServiceFeesData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceFeesData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceFeesDataCopyWith<ServiceFeesData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceFeesDataCopyWith<$Res> {
  factory $ServiceFeesDataCopyWith(
          ServiceFeesData value, $Res Function(ServiceFeesData) then) =
      _$ServiceFeesDataCopyWithImpl<$Res, ServiceFeesData>;
  @useResult
  $Res call(
      {FeeSummary summary,
      FeeBreakdown breakdown,
      List<FeeTransaction> transactions});

  $FeeSummaryCopyWith<$Res> get summary;
  $FeeBreakdownCopyWith<$Res> get breakdown;
}

/// @nodoc
class _$ServiceFeesDataCopyWithImpl<$Res, $Val extends ServiceFeesData>
    implements $ServiceFeesDataCopyWith<$Res> {
  _$ServiceFeesDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceFeesData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? breakdown = null,
    Object? transactions = null,
  }) {
    return _then(_value.copyWith(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as FeeSummary,
      breakdown: null == breakdown
          ? _value.breakdown
          : breakdown // ignore: cast_nullable_to_non_nullable
              as FeeBreakdown,
      transactions: null == transactions
          ? _value.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<FeeTransaction>,
    ) as $Val);
  }

  /// Create a copy of ServiceFeesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FeeSummaryCopyWith<$Res> get summary {
    return $FeeSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }

  /// Create a copy of ServiceFeesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FeeBreakdownCopyWith<$Res> get breakdown {
    return $FeeBreakdownCopyWith<$Res>(_value.breakdown, (value) {
      return _then(_value.copyWith(breakdown: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ServiceFeesDataImplCopyWith<$Res>
    implements $ServiceFeesDataCopyWith<$Res> {
  factory _$$ServiceFeesDataImplCopyWith(_$ServiceFeesDataImpl value,
          $Res Function(_$ServiceFeesDataImpl) then) =
      __$$ServiceFeesDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {FeeSummary summary,
      FeeBreakdown breakdown,
      List<FeeTransaction> transactions});

  @override
  $FeeSummaryCopyWith<$Res> get summary;
  @override
  $FeeBreakdownCopyWith<$Res> get breakdown;
}

/// @nodoc
class __$$ServiceFeesDataImplCopyWithImpl<$Res>
    extends _$ServiceFeesDataCopyWithImpl<$Res, _$ServiceFeesDataImpl>
    implements _$$ServiceFeesDataImplCopyWith<$Res> {
  __$$ServiceFeesDataImplCopyWithImpl(
      _$ServiceFeesDataImpl _value, $Res Function(_$ServiceFeesDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceFeesData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? breakdown = null,
    Object? transactions = null,
  }) {
    return _then(_$ServiceFeesDataImpl(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as FeeSummary,
      breakdown: null == breakdown
          ? _value.breakdown
          : breakdown // ignore: cast_nullable_to_non_nullable
              as FeeBreakdown,
      transactions: null == transactions
          ? _value._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<FeeTransaction>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceFeesDataImpl implements _ServiceFeesData {
  const _$ServiceFeesDataImpl(
      {required this.summary,
      required this.breakdown,
      required final List<FeeTransaction> transactions})
      : _transactions = transactions;

  factory _$ServiceFeesDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceFeesDataImplFromJson(json);

  @override
  final FeeSummary summary;
  @override
  final FeeBreakdown breakdown;
  final List<FeeTransaction> _transactions;
  @override
  List<FeeTransaction> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  @override
  String toString() {
    return 'ServiceFeesData(summary: $summary, breakdown: $breakdown, transactions: $transactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceFeesDataImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.breakdown, breakdown) ||
                other.breakdown == breakdown) &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, summary, breakdown,
      const DeepCollectionEquality().hash(_transactions));

  /// Create a copy of ServiceFeesData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceFeesDataImplCopyWith<_$ServiceFeesDataImpl> get copyWith =>
      __$$ServiceFeesDataImplCopyWithImpl<_$ServiceFeesDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceFeesDataImplToJson(
      this,
    );
  }
}

abstract class _ServiceFeesData implements ServiceFeesData {
  const factory _ServiceFeesData(
          {required final FeeSummary summary,
          required final FeeBreakdown breakdown,
          required final List<FeeTransaction> transactions}) =
      _$ServiceFeesDataImpl;

  factory _ServiceFeesData.fromJson(Map<String, dynamic> json) =
      _$ServiceFeesDataImpl.fromJson;

  @override
  FeeSummary get summary;
  @override
  FeeBreakdown get breakdown;
  @override
  List<FeeTransaction> get transactions;

  /// Create a copy of ServiceFeesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceFeesDataImplCopyWith<_$ServiceFeesDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
