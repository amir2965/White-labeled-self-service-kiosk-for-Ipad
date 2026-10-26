// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chart_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SalesEvent _$SalesEventFromJson(Map<String, dynamic> json) {
  return _SalesEvent.fromJson(json);
}

/// @nodoc
mixin _$SalesEvent {
  String get id => throw _privateConstructorUsedError;
  DateTime get timestampUTC => throw _privateConstructorUsedError;
  double get amountGross => throw _privateConstructorUsedError;
  double get amountNet => throw _privateConstructorUsedError;
  double get tax => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  SalesEventStatus get status => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;
  String? get venueId => throw _privateConstructorUsedError;
  String? get orderId => throw _privateConstructorUsedError;

  /// Serializes this SalesEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalesEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalesEventCopyWith<SalesEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesEventCopyWith<$Res> {
  factory $SalesEventCopyWith(
          SalesEvent value, $Res Function(SalesEvent) then) =
      _$SalesEventCopyWithImpl<$Res, SalesEvent>;
  @useResult
  $Res call(
      {String id,
      DateTime timestampUTC,
      double amountGross,
      double amountNet,
      double tax,
      String paymentMethod,
      SalesEventStatus status,
      String? deviceId,
      String? venueId,
      String? orderId});
}

/// @nodoc
class _$SalesEventCopyWithImpl<$Res, $Val extends SalesEvent>
    implements $SalesEventCopyWith<$Res> {
  _$SalesEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalesEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestampUTC = null,
    Object? amountGross = null,
    Object? amountNet = null,
    Object? tax = null,
    Object? paymentMethod = null,
    Object? status = null,
    Object? deviceId = freezed,
    Object? venueId = freezed,
    Object? orderId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestampUTC: null == timestampUTC
          ? _value.timestampUTC
          : timestampUTC // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amountGross: null == amountGross
          ? _value.amountGross
          : amountGross // ignore: cast_nullable_to_non_nullable
              as double,
      amountNet: null == amountNet
          ? _value.amountNet
          : amountNet // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SalesEventStatus,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      venueId: freezed == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalesEventImplCopyWith<$Res>
    implements $SalesEventCopyWith<$Res> {
  factory _$$SalesEventImplCopyWith(
          _$SalesEventImpl value, $Res Function(_$SalesEventImpl) then) =
      __$$SalesEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime timestampUTC,
      double amountGross,
      double amountNet,
      double tax,
      String paymentMethod,
      SalesEventStatus status,
      String? deviceId,
      String? venueId,
      String? orderId});
}

/// @nodoc
class __$$SalesEventImplCopyWithImpl<$Res>
    extends _$SalesEventCopyWithImpl<$Res, _$SalesEventImpl>
    implements _$$SalesEventImplCopyWith<$Res> {
  __$$SalesEventImplCopyWithImpl(
      _$SalesEventImpl _value, $Res Function(_$SalesEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of SalesEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestampUTC = null,
    Object? amountGross = null,
    Object? amountNet = null,
    Object? tax = null,
    Object? paymentMethod = null,
    Object? status = null,
    Object? deviceId = freezed,
    Object? venueId = freezed,
    Object? orderId = freezed,
  }) {
    return _then(_$SalesEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestampUTC: null == timestampUTC
          ? _value.timestampUTC
          : timestampUTC // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amountGross: null == amountGross
          ? _value.amountGross
          : amountGross // ignore: cast_nullable_to_non_nullable
              as double,
      amountNet: null == amountNet
          ? _value.amountNet
          : amountNet // ignore: cast_nullable_to_non_nullable
              as double,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SalesEventStatus,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      venueId: freezed == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalesEventImpl implements _SalesEvent {
  const _$SalesEventImpl(
      {required this.id,
      required this.timestampUTC,
      required this.amountGross,
      required this.amountNet,
      required this.tax,
      required this.paymentMethod,
      required this.status,
      this.deviceId,
      this.venueId,
      this.orderId});

  factory _$SalesEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalesEventImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime timestampUTC;
  @override
  final double amountGross;
  @override
  final double amountNet;
  @override
  final double tax;
  @override
  final String paymentMethod;
  @override
  final SalesEventStatus status;
  @override
  final String? deviceId;
  @override
  final String? venueId;
  @override
  final String? orderId;

  @override
  String toString() {
    return 'SalesEvent(id: $id, timestampUTC: $timestampUTC, amountGross: $amountGross, amountNet: $amountNet, tax: $tax, paymentMethod: $paymentMethod, status: $status, deviceId: $deviceId, venueId: $venueId, orderId: $orderId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.timestampUTC, timestampUTC) ||
                other.timestampUTC == timestampUTC) &&
            (identical(other.amountGross, amountGross) ||
                other.amountGross == amountGross) &&
            (identical(other.amountNet, amountNet) ||
                other.amountNet == amountNet) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.orderId, orderId) || other.orderId == orderId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, timestampUTC, amountGross,
      amountNet, tax, paymentMethod, status, deviceId, venueId, orderId);

  /// Create a copy of SalesEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesEventImplCopyWith<_$SalesEventImpl> get copyWith =>
      __$$SalesEventImplCopyWithImpl<_$SalesEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalesEventImplToJson(
      this,
    );
  }
}

abstract class _SalesEvent implements SalesEvent {
  const factory _SalesEvent(
      {required final String id,
      required final DateTime timestampUTC,
      required final double amountGross,
      required final double amountNet,
      required final double tax,
      required final String paymentMethod,
      required final SalesEventStatus status,
      final String? deviceId,
      final String? venueId,
      final String? orderId}) = _$SalesEventImpl;

  factory _SalesEvent.fromJson(Map<String, dynamic> json) =
      _$SalesEventImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get timestampUTC;
  @override
  double get amountGross;
  @override
  double get amountNet;
  @override
  double get tax;
  @override
  String get paymentMethod;
  @override
  SalesEventStatus get status;
  @override
  String? get deviceId;
  @override
  String? get venueId;
  @override
  String? get orderId;

  /// Create a copy of SalesEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalesEventImplCopyWith<_$SalesEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChartPoint _$ChartPointFromJson(Map<String, dynamic> json) {
  return _ChartPoint.fromJson(json);
}

/// @nodoc
mixin _$ChartPoint {
  DateTime get x => throw _privateConstructorUsedError;
  double get grossSales => throw _privateConstructorUsedError;
  int get paymentsCount => throw _privateConstructorUsedError;
  double? get netSales => throw _privateConstructorUsedError;
  double? get tax => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;

  /// Serializes this ChartPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChartPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChartPointCopyWith<ChartPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChartPointCopyWith<$Res> {
  factory $ChartPointCopyWith(
          ChartPoint value, $Res Function(ChartPoint) then) =
      _$ChartPointCopyWithImpl<$Res, ChartPoint>;
  @useResult
  $Res call(
      {DateTime x,
      double grossSales,
      int paymentsCount,
      double? netSales,
      double? tax,
      String? label});
}

/// @nodoc
class _$ChartPointCopyWithImpl<$Res, $Val extends ChartPoint>
    implements $ChartPointCopyWith<$Res> {
  _$ChartPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChartPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? grossSales = null,
    Object? paymentsCount = null,
    Object? netSales = freezed,
    Object? tax = freezed,
    Object? label = freezed,
  }) {
    return _then(_value.copyWith(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as DateTime,
      grossSales: null == grossSales
          ? _value.grossSales
          : grossSales // ignore: cast_nullable_to_non_nullable
              as double,
      paymentsCount: null == paymentsCount
          ? _value.paymentsCount
          : paymentsCount // ignore: cast_nullable_to_non_nullable
              as int,
      netSales: freezed == netSales
          ? _value.netSales
          : netSales // ignore: cast_nullable_to_non_nullable
              as double?,
      tax: freezed == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double?,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChartPointImplCopyWith<$Res>
    implements $ChartPointCopyWith<$Res> {
  factory _$$ChartPointImplCopyWith(
          _$ChartPointImpl value, $Res Function(_$ChartPointImpl) then) =
      __$$ChartPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime x,
      double grossSales,
      int paymentsCount,
      double? netSales,
      double? tax,
      String? label});
}

/// @nodoc
class __$$ChartPointImplCopyWithImpl<$Res>
    extends _$ChartPointCopyWithImpl<$Res, _$ChartPointImpl>
    implements _$$ChartPointImplCopyWith<$Res> {
  __$$ChartPointImplCopyWithImpl(
      _$ChartPointImpl _value, $Res Function(_$ChartPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChartPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? grossSales = null,
    Object? paymentsCount = null,
    Object? netSales = freezed,
    Object? tax = freezed,
    Object? label = freezed,
  }) {
    return _then(_$ChartPointImpl(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as DateTime,
      grossSales: null == grossSales
          ? _value.grossSales
          : grossSales // ignore: cast_nullable_to_non_nullable
              as double,
      paymentsCount: null == paymentsCount
          ? _value.paymentsCount
          : paymentsCount // ignore: cast_nullable_to_non_nullable
              as int,
      netSales: freezed == netSales
          ? _value.netSales
          : netSales // ignore: cast_nullable_to_non_nullable
              as double?,
      tax: freezed == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as double?,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChartPointImpl implements _ChartPoint {
  const _$ChartPointImpl(
      {required this.x,
      required this.grossSales,
      required this.paymentsCount,
      this.netSales,
      this.tax,
      this.label});

  factory _$ChartPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChartPointImplFromJson(json);

  @override
  final DateTime x;
  @override
  final double grossSales;
  @override
  final int paymentsCount;
  @override
  final double? netSales;
  @override
  final double? tax;
  @override
  final String? label;

  @override
  String toString() {
    return 'ChartPoint(x: $x, grossSales: $grossSales, paymentsCount: $paymentsCount, netSales: $netSales, tax: $tax, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChartPointImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.grossSales, grossSales) ||
                other.grossSales == grossSales) &&
            (identical(other.paymentsCount, paymentsCount) ||
                other.paymentsCount == paymentsCount) &&
            (identical(other.netSales, netSales) ||
                other.netSales == netSales) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, x, grossSales, paymentsCount, netSales, tax, label);

  /// Create a copy of ChartPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChartPointImplCopyWith<_$ChartPointImpl> get copyWith =>
      __$$ChartPointImplCopyWithImpl<_$ChartPointImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChartPointImplToJson(
      this,
    );
  }
}

abstract class _ChartPoint implements ChartPoint {
  const factory _ChartPoint(
      {required final DateTime x,
      required final double grossSales,
      required final int paymentsCount,
      final double? netSales,
      final double? tax,
      final String? label}) = _$ChartPointImpl;

  factory _ChartPoint.fromJson(Map<String, dynamic> json) =
      _$ChartPointImpl.fromJson;

  @override
  DateTime get x;
  @override
  double get grossSales;
  @override
  int get paymentsCount;
  @override
  double? get netSales;
  @override
  double? get tax;
  @override
  String? get label;

  /// Create a copy of ChartPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChartPointImplCopyWith<_$ChartPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SalesSummaryChartsData _$SalesSummaryChartsDataFromJson(
    Map<String, dynamic> json) {
  return _SalesSummaryChartsData.fromJson(json);
}

/// @nodoc
mixin _$SalesSummaryChartsData {
// Time of Day chart (hourly 0-23)
  List<ChartPoint> get timeOfDaySelectedSeries =>
      throw _privateConstructorUsedError;
  List<ChartPoint> get timeOfDayCompareSeries =>
      throw _privateConstructorUsedError; // Period Trend chart (daily points across range)
  List<ChartPoint> get periodTrendSeries => throw _privateConstructorUsedError;
  List<ChartPoint>? get periodTrendCompareSeries =>
      throw _privateConstructorUsedError; // Day of Week chart (7 bars: Sun-Sat)
  Map<int, double> get dayOfWeekTotals =>
      throw _privateConstructorUsedError; // weekday (1=Mon, 7=Sun) -> amount
  Map<int, int> get dayOfWeekPayments =>
      throw _privateConstructorUsedError; // Metadata
  DateTime get lastUpdatedAt => throw _privateConstructorUsedError;
  DateTime get selectedStartDate => throw _privateConstructorUsedError;
  DateTime get selectedEndDate => throw _privateConstructorUsedError;
  DateTime? get compareStartDate => throw _privateConstructorUsedError;
  DateTime? get compareEndDate =>
      throw _privateConstructorUsedError; // Summary stats
  double get totalGrossSales => throw _privateConstructorUsedError;
  int get totalPayments => throw _privateConstructorUsedError;
  double? get compareTotalGrossSales => throw _privateConstructorUsedError;
  int? get compareTotalPayments => throw _privateConstructorUsedError;

  /// Serializes this SalesSummaryChartsData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalesSummaryChartsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalesSummaryChartsDataCopyWith<SalesSummaryChartsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesSummaryChartsDataCopyWith<$Res> {
  factory $SalesSummaryChartsDataCopyWith(SalesSummaryChartsData value,
          $Res Function(SalesSummaryChartsData) then) =
      _$SalesSummaryChartsDataCopyWithImpl<$Res, SalesSummaryChartsData>;
  @useResult
  $Res call(
      {List<ChartPoint> timeOfDaySelectedSeries,
      List<ChartPoint> timeOfDayCompareSeries,
      List<ChartPoint> periodTrendSeries,
      List<ChartPoint>? periodTrendCompareSeries,
      Map<int, double> dayOfWeekTotals,
      Map<int, int> dayOfWeekPayments,
      DateTime lastUpdatedAt,
      DateTime selectedStartDate,
      DateTime selectedEndDate,
      DateTime? compareStartDate,
      DateTime? compareEndDate,
      double totalGrossSales,
      int totalPayments,
      double? compareTotalGrossSales,
      int? compareTotalPayments});
}

/// @nodoc
class _$SalesSummaryChartsDataCopyWithImpl<$Res,
        $Val extends SalesSummaryChartsData>
    implements $SalesSummaryChartsDataCopyWith<$Res> {
  _$SalesSummaryChartsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalesSummaryChartsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeOfDaySelectedSeries = null,
    Object? timeOfDayCompareSeries = null,
    Object? periodTrendSeries = null,
    Object? periodTrendCompareSeries = freezed,
    Object? dayOfWeekTotals = null,
    Object? dayOfWeekPayments = null,
    Object? lastUpdatedAt = null,
    Object? selectedStartDate = null,
    Object? selectedEndDate = null,
    Object? compareStartDate = freezed,
    Object? compareEndDate = freezed,
    Object? totalGrossSales = null,
    Object? totalPayments = null,
    Object? compareTotalGrossSales = freezed,
    Object? compareTotalPayments = freezed,
  }) {
    return _then(_value.copyWith(
      timeOfDaySelectedSeries: null == timeOfDaySelectedSeries
          ? _value.timeOfDaySelectedSeries
          : timeOfDaySelectedSeries // ignore: cast_nullable_to_non_nullable
              as List<ChartPoint>,
      timeOfDayCompareSeries: null == timeOfDayCompareSeries
          ? _value.timeOfDayCompareSeries
          : timeOfDayCompareSeries // ignore: cast_nullable_to_non_nullable
              as List<ChartPoint>,
      periodTrendSeries: null == periodTrendSeries
          ? _value.periodTrendSeries
          : periodTrendSeries // ignore: cast_nullable_to_non_nullable
              as List<ChartPoint>,
      periodTrendCompareSeries: freezed == periodTrendCompareSeries
          ? _value.periodTrendCompareSeries
          : periodTrendCompareSeries // ignore: cast_nullable_to_non_nullable
              as List<ChartPoint>?,
      dayOfWeekTotals: null == dayOfWeekTotals
          ? _value.dayOfWeekTotals
          : dayOfWeekTotals // ignore: cast_nullable_to_non_nullable
              as Map<int, double>,
      dayOfWeekPayments: null == dayOfWeekPayments
          ? _value.dayOfWeekPayments
          : dayOfWeekPayments // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
      lastUpdatedAt: null == lastUpdatedAt
          ? _value.lastUpdatedAt
          : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedStartDate: null == selectedStartDate
          ? _value.selectedStartDate
          : selectedStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedEndDate: null == selectedEndDate
          ? _value.selectedEndDate
          : selectedEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      compareStartDate: freezed == compareStartDate
          ? _value.compareStartDate
          : compareStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      compareEndDate: freezed == compareEndDate
          ? _value.compareEndDate
          : compareEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalGrossSales: null == totalGrossSales
          ? _value.totalGrossSales
          : totalGrossSales // ignore: cast_nullable_to_non_nullable
              as double,
      totalPayments: null == totalPayments
          ? _value.totalPayments
          : totalPayments // ignore: cast_nullable_to_non_nullable
              as int,
      compareTotalGrossSales: freezed == compareTotalGrossSales
          ? _value.compareTotalGrossSales
          : compareTotalGrossSales // ignore: cast_nullable_to_non_nullable
              as double?,
      compareTotalPayments: freezed == compareTotalPayments
          ? _value.compareTotalPayments
          : compareTotalPayments // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalesSummaryChartsDataImplCopyWith<$Res>
    implements $SalesSummaryChartsDataCopyWith<$Res> {
  factory _$$SalesSummaryChartsDataImplCopyWith(
          _$SalesSummaryChartsDataImpl value,
          $Res Function(_$SalesSummaryChartsDataImpl) then) =
      __$$SalesSummaryChartsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ChartPoint> timeOfDaySelectedSeries,
      List<ChartPoint> timeOfDayCompareSeries,
      List<ChartPoint> periodTrendSeries,
      List<ChartPoint>? periodTrendCompareSeries,
      Map<int, double> dayOfWeekTotals,
      Map<int, int> dayOfWeekPayments,
      DateTime lastUpdatedAt,
      DateTime selectedStartDate,
      DateTime selectedEndDate,
      DateTime? compareStartDate,
      DateTime? compareEndDate,
      double totalGrossSales,
      int totalPayments,
      double? compareTotalGrossSales,
      int? compareTotalPayments});
}

/// @nodoc
class __$$SalesSummaryChartsDataImplCopyWithImpl<$Res>
    extends _$SalesSummaryChartsDataCopyWithImpl<$Res,
        _$SalesSummaryChartsDataImpl>
    implements _$$SalesSummaryChartsDataImplCopyWith<$Res> {
  __$$SalesSummaryChartsDataImplCopyWithImpl(
      _$SalesSummaryChartsDataImpl _value,
      $Res Function(_$SalesSummaryChartsDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of SalesSummaryChartsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeOfDaySelectedSeries = null,
    Object? timeOfDayCompareSeries = null,
    Object? periodTrendSeries = null,
    Object? periodTrendCompareSeries = freezed,
    Object? dayOfWeekTotals = null,
    Object? dayOfWeekPayments = null,
    Object? lastUpdatedAt = null,
    Object? selectedStartDate = null,
    Object? selectedEndDate = null,
    Object? compareStartDate = freezed,
    Object? compareEndDate = freezed,
    Object? totalGrossSales = null,
    Object? totalPayments = null,
    Object? compareTotalGrossSales = freezed,
    Object? compareTotalPayments = freezed,
  }) {
    return _then(_$SalesSummaryChartsDataImpl(
      timeOfDaySelectedSeries: null == timeOfDaySelectedSeries
          ? _value._timeOfDaySelectedSeries
          : timeOfDaySelectedSeries // ignore: cast_nullable_to_non_nullable
              as List<ChartPoint>,
      timeOfDayCompareSeries: null == timeOfDayCompareSeries
          ? _value._timeOfDayCompareSeries
          : timeOfDayCompareSeries // ignore: cast_nullable_to_non_nullable
              as List<ChartPoint>,
      periodTrendSeries: null == periodTrendSeries
          ? _value._periodTrendSeries
          : periodTrendSeries // ignore: cast_nullable_to_non_nullable
              as List<ChartPoint>,
      periodTrendCompareSeries: freezed == periodTrendCompareSeries
          ? _value._periodTrendCompareSeries
          : periodTrendCompareSeries // ignore: cast_nullable_to_non_nullable
              as List<ChartPoint>?,
      dayOfWeekTotals: null == dayOfWeekTotals
          ? _value._dayOfWeekTotals
          : dayOfWeekTotals // ignore: cast_nullable_to_non_nullable
              as Map<int, double>,
      dayOfWeekPayments: null == dayOfWeekPayments
          ? _value._dayOfWeekPayments
          : dayOfWeekPayments // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
      lastUpdatedAt: null == lastUpdatedAt
          ? _value.lastUpdatedAt
          : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedStartDate: null == selectedStartDate
          ? _value.selectedStartDate
          : selectedStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedEndDate: null == selectedEndDate
          ? _value.selectedEndDate
          : selectedEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      compareStartDate: freezed == compareStartDate
          ? _value.compareStartDate
          : compareStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      compareEndDate: freezed == compareEndDate
          ? _value.compareEndDate
          : compareEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalGrossSales: null == totalGrossSales
          ? _value.totalGrossSales
          : totalGrossSales // ignore: cast_nullable_to_non_nullable
              as double,
      totalPayments: null == totalPayments
          ? _value.totalPayments
          : totalPayments // ignore: cast_nullable_to_non_nullable
              as int,
      compareTotalGrossSales: freezed == compareTotalGrossSales
          ? _value.compareTotalGrossSales
          : compareTotalGrossSales // ignore: cast_nullable_to_non_nullable
              as double?,
      compareTotalPayments: freezed == compareTotalPayments
          ? _value.compareTotalPayments
          : compareTotalPayments // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalesSummaryChartsDataImpl implements _SalesSummaryChartsData {
  const _$SalesSummaryChartsDataImpl(
      {required final List<ChartPoint> timeOfDaySelectedSeries,
      required final List<ChartPoint> timeOfDayCompareSeries,
      required final List<ChartPoint> periodTrendSeries,
      final List<ChartPoint>? periodTrendCompareSeries,
      required final Map<int, double> dayOfWeekTotals,
      required final Map<int, int> dayOfWeekPayments,
      required this.lastUpdatedAt,
      required this.selectedStartDate,
      required this.selectedEndDate,
      this.compareStartDate,
      this.compareEndDate,
      required this.totalGrossSales,
      required this.totalPayments,
      this.compareTotalGrossSales,
      this.compareTotalPayments})
      : _timeOfDaySelectedSeries = timeOfDaySelectedSeries,
        _timeOfDayCompareSeries = timeOfDayCompareSeries,
        _periodTrendSeries = periodTrendSeries,
        _periodTrendCompareSeries = periodTrendCompareSeries,
        _dayOfWeekTotals = dayOfWeekTotals,
        _dayOfWeekPayments = dayOfWeekPayments;

  factory _$SalesSummaryChartsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalesSummaryChartsDataImplFromJson(json);

// Time of Day chart (hourly 0-23)
  final List<ChartPoint> _timeOfDaySelectedSeries;
// Time of Day chart (hourly 0-23)
  @override
  List<ChartPoint> get timeOfDaySelectedSeries {
    if (_timeOfDaySelectedSeries is EqualUnmodifiableListView)
      return _timeOfDaySelectedSeries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timeOfDaySelectedSeries);
  }

  final List<ChartPoint> _timeOfDayCompareSeries;
  @override
  List<ChartPoint> get timeOfDayCompareSeries {
    if (_timeOfDayCompareSeries is EqualUnmodifiableListView)
      return _timeOfDayCompareSeries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timeOfDayCompareSeries);
  }

// Period Trend chart (daily points across range)
  final List<ChartPoint> _periodTrendSeries;
// Period Trend chart (daily points across range)
  @override
  List<ChartPoint> get periodTrendSeries {
    if (_periodTrendSeries is EqualUnmodifiableListView)
      return _periodTrendSeries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_periodTrendSeries);
  }

  final List<ChartPoint>? _periodTrendCompareSeries;
  @override
  List<ChartPoint>? get periodTrendCompareSeries {
    final value = _periodTrendCompareSeries;
    if (value == null) return null;
    if (_periodTrendCompareSeries is EqualUnmodifiableListView)
      return _periodTrendCompareSeries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Day of Week chart (7 bars: Sun-Sat)
  final Map<int, double> _dayOfWeekTotals;
// Day of Week chart (7 bars: Sun-Sat)
  @override
  Map<int, double> get dayOfWeekTotals {
    if (_dayOfWeekTotals is EqualUnmodifiableMapView) return _dayOfWeekTotals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dayOfWeekTotals);
  }

// weekday (1=Mon, 7=Sun) -> amount
  final Map<int, int> _dayOfWeekPayments;
// weekday (1=Mon, 7=Sun) -> amount
  @override
  Map<int, int> get dayOfWeekPayments {
    if (_dayOfWeekPayments is EqualUnmodifiableMapView)
      return _dayOfWeekPayments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dayOfWeekPayments);
  }

// Metadata
  @override
  final DateTime lastUpdatedAt;
  @override
  final DateTime selectedStartDate;
  @override
  final DateTime selectedEndDate;
  @override
  final DateTime? compareStartDate;
  @override
  final DateTime? compareEndDate;
// Summary stats
  @override
  final double totalGrossSales;
  @override
  final int totalPayments;
  @override
  final double? compareTotalGrossSales;
  @override
  final int? compareTotalPayments;

  @override
  String toString() {
    return 'SalesSummaryChartsData(timeOfDaySelectedSeries: $timeOfDaySelectedSeries, timeOfDayCompareSeries: $timeOfDayCompareSeries, periodTrendSeries: $periodTrendSeries, periodTrendCompareSeries: $periodTrendCompareSeries, dayOfWeekTotals: $dayOfWeekTotals, dayOfWeekPayments: $dayOfWeekPayments, lastUpdatedAt: $lastUpdatedAt, selectedStartDate: $selectedStartDate, selectedEndDate: $selectedEndDate, compareStartDate: $compareStartDate, compareEndDate: $compareEndDate, totalGrossSales: $totalGrossSales, totalPayments: $totalPayments, compareTotalGrossSales: $compareTotalGrossSales, compareTotalPayments: $compareTotalPayments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesSummaryChartsDataImpl &&
            const DeepCollectionEquality().equals(
                other._timeOfDaySelectedSeries, _timeOfDaySelectedSeries) &&
            const DeepCollectionEquality().equals(
                other._timeOfDayCompareSeries, _timeOfDayCompareSeries) &&
            const DeepCollectionEquality()
                .equals(other._periodTrendSeries, _periodTrendSeries) &&
            const DeepCollectionEquality().equals(
                other._periodTrendCompareSeries, _periodTrendCompareSeries) &&
            const DeepCollectionEquality()
                .equals(other._dayOfWeekTotals, _dayOfWeekTotals) &&
            const DeepCollectionEquality()
                .equals(other._dayOfWeekPayments, _dayOfWeekPayments) &&
            (identical(other.lastUpdatedAt, lastUpdatedAt) ||
                other.lastUpdatedAt == lastUpdatedAt) &&
            (identical(other.selectedStartDate, selectedStartDate) ||
                other.selectedStartDate == selectedStartDate) &&
            (identical(other.selectedEndDate, selectedEndDate) ||
                other.selectedEndDate == selectedEndDate) &&
            (identical(other.compareStartDate, compareStartDate) ||
                other.compareStartDate == compareStartDate) &&
            (identical(other.compareEndDate, compareEndDate) ||
                other.compareEndDate == compareEndDate) &&
            (identical(other.totalGrossSales, totalGrossSales) ||
                other.totalGrossSales == totalGrossSales) &&
            (identical(other.totalPayments, totalPayments) ||
                other.totalPayments == totalPayments) &&
            (identical(other.compareTotalGrossSales, compareTotalGrossSales) ||
                other.compareTotalGrossSales == compareTotalGrossSales) &&
            (identical(other.compareTotalPayments, compareTotalPayments) ||
                other.compareTotalPayments == compareTotalPayments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_timeOfDaySelectedSeries),
      const DeepCollectionEquality().hash(_timeOfDayCompareSeries),
      const DeepCollectionEquality().hash(_periodTrendSeries),
      const DeepCollectionEquality().hash(_periodTrendCompareSeries),
      const DeepCollectionEquality().hash(_dayOfWeekTotals),
      const DeepCollectionEquality().hash(_dayOfWeekPayments),
      lastUpdatedAt,
      selectedStartDate,
      selectedEndDate,
      compareStartDate,
      compareEndDate,
      totalGrossSales,
      totalPayments,
      compareTotalGrossSales,
      compareTotalPayments);

  /// Create a copy of SalesSummaryChartsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesSummaryChartsDataImplCopyWith<_$SalesSummaryChartsDataImpl>
      get copyWith => __$$SalesSummaryChartsDataImplCopyWithImpl<
          _$SalesSummaryChartsDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalesSummaryChartsDataImplToJson(
      this,
    );
  }
}

abstract class _SalesSummaryChartsData implements SalesSummaryChartsData {
  const factory _SalesSummaryChartsData(
      {required final List<ChartPoint> timeOfDaySelectedSeries,
      required final List<ChartPoint> timeOfDayCompareSeries,
      required final List<ChartPoint> periodTrendSeries,
      final List<ChartPoint>? periodTrendCompareSeries,
      required final Map<int, double> dayOfWeekTotals,
      required final Map<int, int> dayOfWeekPayments,
      required final DateTime lastUpdatedAt,
      required final DateTime selectedStartDate,
      required final DateTime selectedEndDate,
      final DateTime? compareStartDate,
      final DateTime? compareEndDate,
      required final double totalGrossSales,
      required final int totalPayments,
      final double? compareTotalGrossSales,
      final int? compareTotalPayments}) = _$SalesSummaryChartsDataImpl;

  factory _SalesSummaryChartsData.fromJson(Map<String, dynamic> json) =
      _$SalesSummaryChartsDataImpl.fromJson;

// Time of Day chart (hourly 0-23)
  @override
  List<ChartPoint> get timeOfDaySelectedSeries;
  @override
  List<ChartPoint>
      get timeOfDayCompareSeries; // Period Trend chart (daily points across range)
  @override
  List<ChartPoint> get periodTrendSeries;
  @override
  List<ChartPoint>?
      get periodTrendCompareSeries; // Day of Week chart (7 bars: Sun-Sat)
  @override
  Map<int, double> get dayOfWeekTotals; // weekday (1=Mon, 7=Sun) -> amount
  @override
  Map<int, int> get dayOfWeekPayments; // Metadata
  @override
  DateTime get lastUpdatedAt;
  @override
  DateTime get selectedStartDate;
  @override
  DateTime get selectedEndDate;
  @override
  DateTime? get compareStartDate;
  @override
  DateTime? get compareEndDate; // Summary stats
  @override
  double get totalGrossSales;
  @override
  int get totalPayments;
  @override
  double? get compareTotalGrossSales;
  @override
  int? get compareTotalPayments;

  /// Create a copy of SalesSummaryChartsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalesSummaryChartsDataImplCopyWith<_$SalesSummaryChartsDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TimeRangeSelection {
  int get startHour => throw _privateConstructorUsedError; // 0-23
  int get endHour => throw _privateConstructorUsedError; // 0-23
  double get totalSales => throw _privateConstructorUsedError;
  int get paymentsCount => throw _privateConstructorUsedError;

  /// Create a copy of TimeRangeSelection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeRangeSelectionCopyWith<TimeRangeSelection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeRangeSelectionCopyWith<$Res> {
  factory $TimeRangeSelectionCopyWith(
          TimeRangeSelection value, $Res Function(TimeRangeSelection) then) =
      _$TimeRangeSelectionCopyWithImpl<$Res, TimeRangeSelection>;
  @useResult
  $Res call({int startHour, int endHour, double totalSales, int paymentsCount});
}

/// @nodoc
class _$TimeRangeSelectionCopyWithImpl<$Res, $Val extends TimeRangeSelection>
    implements $TimeRangeSelectionCopyWith<$Res> {
  _$TimeRangeSelectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeRangeSelection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startHour = null,
    Object? endHour = null,
    Object? totalSales = null,
    Object? paymentsCount = null,
  }) {
    return _then(_value.copyWith(
      startHour: null == startHour
          ? _value.startHour
          : startHour // ignore: cast_nullable_to_non_nullable
              as int,
      endHour: null == endHour
          ? _value.endHour
          : endHour // ignore: cast_nullable_to_non_nullable
              as int,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as double,
      paymentsCount: null == paymentsCount
          ? _value.paymentsCount
          : paymentsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimeRangeSelectionImplCopyWith<$Res>
    implements $TimeRangeSelectionCopyWith<$Res> {
  factory _$$TimeRangeSelectionImplCopyWith(_$TimeRangeSelectionImpl value,
          $Res Function(_$TimeRangeSelectionImpl) then) =
      __$$TimeRangeSelectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int startHour, int endHour, double totalSales, int paymentsCount});
}

/// @nodoc
class __$$TimeRangeSelectionImplCopyWithImpl<$Res>
    extends _$TimeRangeSelectionCopyWithImpl<$Res, _$TimeRangeSelectionImpl>
    implements _$$TimeRangeSelectionImplCopyWith<$Res> {
  __$$TimeRangeSelectionImplCopyWithImpl(_$TimeRangeSelectionImpl _value,
      $Res Function(_$TimeRangeSelectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimeRangeSelection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startHour = null,
    Object? endHour = null,
    Object? totalSales = null,
    Object? paymentsCount = null,
  }) {
    return _then(_$TimeRangeSelectionImpl(
      startHour: null == startHour
          ? _value.startHour
          : startHour // ignore: cast_nullable_to_non_nullable
              as int,
      endHour: null == endHour
          ? _value.endHour
          : endHour // ignore: cast_nullable_to_non_nullable
              as int,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as double,
      paymentsCount: null == paymentsCount
          ? _value.paymentsCount
          : paymentsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$TimeRangeSelectionImpl implements _TimeRangeSelection {
  const _$TimeRangeSelectionImpl(
      {required this.startHour,
      required this.endHour,
      required this.totalSales,
      required this.paymentsCount});

  @override
  final int startHour;
// 0-23
  @override
  final int endHour;
// 0-23
  @override
  final double totalSales;
  @override
  final int paymentsCount;

  @override
  String toString() {
    return 'TimeRangeSelection(startHour: $startHour, endHour: $endHour, totalSales: $totalSales, paymentsCount: $paymentsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeRangeSelectionImpl &&
            (identical(other.startHour, startHour) ||
                other.startHour == startHour) &&
            (identical(other.endHour, endHour) || other.endHour == endHour) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.paymentsCount, paymentsCount) ||
                other.paymentsCount == paymentsCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, startHour, endHour, totalSales, paymentsCount);

  /// Create a copy of TimeRangeSelection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeRangeSelectionImplCopyWith<_$TimeRangeSelectionImpl> get copyWith =>
      __$$TimeRangeSelectionImplCopyWithImpl<_$TimeRangeSelectionImpl>(
          this, _$identity);
}

abstract class _TimeRangeSelection implements TimeRangeSelection {
  const factory _TimeRangeSelection(
      {required final int startHour,
      required final int endHour,
      required final double totalSales,
      required final int paymentsCount}) = _$TimeRangeSelectionImpl;

  @override
  int get startHour; // 0-23
  @override
  int get endHour; // 0-23
  @override
  double get totalSales;
  @override
  int get paymentsCount;

  /// Create a copy of TimeRangeSelection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeRangeSelectionImplCopyWith<_$TimeRangeSelectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ChartPointSelection {
  ChartPoint get point => throw _privateConstructorUsedError;
  ChartPoint? get comparePoint => throw _privateConstructorUsedError;
  String get dateLabel => throw _privateConstructorUsedError;
  String? get compareDateLabel => throw _privateConstructorUsedError;

  /// Create a copy of ChartPointSelection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChartPointSelectionCopyWith<ChartPointSelection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChartPointSelectionCopyWith<$Res> {
  factory $ChartPointSelectionCopyWith(
          ChartPointSelection value, $Res Function(ChartPointSelection) then) =
      _$ChartPointSelectionCopyWithImpl<$Res, ChartPointSelection>;
  @useResult
  $Res call(
      {ChartPoint point,
      ChartPoint? comparePoint,
      String dateLabel,
      String? compareDateLabel});

  $ChartPointCopyWith<$Res> get point;
  $ChartPointCopyWith<$Res>? get comparePoint;
}

/// @nodoc
class _$ChartPointSelectionCopyWithImpl<$Res, $Val extends ChartPointSelection>
    implements $ChartPointSelectionCopyWith<$Res> {
  _$ChartPointSelectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChartPointSelection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? point = null,
    Object? comparePoint = freezed,
    Object? dateLabel = null,
    Object? compareDateLabel = freezed,
  }) {
    return _then(_value.copyWith(
      point: null == point
          ? _value.point
          : point // ignore: cast_nullable_to_non_nullable
              as ChartPoint,
      comparePoint: freezed == comparePoint
          ? _value.comparePoint
          : comparePoint // ignore: cast_nullable_to_non_nullable
              as ChartPoint?,
      dateLabel: null == dateLabel
          ? _value.dateLabel
          : dateLabel // ignore: cast_nullable_to_non_nullable
              as String,
      compareDateLabel: freezed == compareDateLabel
          ? _value.compareDateLabel
          : compareDateLabel // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ChartPointSelection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChartPointCopyWith<$Res> get point {
    return $ChartPointCopyWith<$Res>(_value.point, (value) {
      return _then(_value.copyWith(point: value) as $Val);
    });
  }

  /// Create a copy of ChartPointSelection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChartPointCopyWith<$Res>? get comparePoint {
    if (_value.comparePoint == null) {
      return null;
    }

    return $ChartPointCopyWith<$Res>(_value.comparePoint!, (value) {
      return _then(_value.copyWith(comparePoint: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChartPointSelectionImplCopyWith<$Res>
    implements $ChartPointSelectionCopyWith<$Res> {
  factory _$$ChartPointSelectionImplCopyWith(_$ChartPointSelectionImpl value,
          $Res Function(_$ChartPointSelectionImpl) then) =
      __$$ChartPointSelectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ChartPoint point,
      ChartPoint? comparePoint,
      String dateLabel,
      String? compareDateLabel});

  @override
  $ChartPointCopyWith<$Res> get point;
  @override
  $ChartPointCopyWith<$Res>? get comparePoint;
}

/// @nodoc
class __$$ChartPointSelectionImplCopyWithImpl<$Res>
    extends _$ChartPointSelectionCopyWithImpl<$Res, _$ChartPointSelectionImpl>
    implements _$$ChartPointSelectionImplCopyWith<$Res> {
  __$$ChartPointSelectionImplCopyWithImpl(_$ChartPointSelectionImpl _value,
      $Res Function(_$ChartPointSelectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChartPointSelection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? point = null,
    Object? comparePoint = freezed,
    Object? dateLabel = null,
    Object? compareDateLabel = freezed,
  }) {
    return _then(_$ChartPointSelectionImpl(
      point: null == point
          ? _value.point
          : point // ignore: cast_nullable_to_non_nullable
              as ChartPoint,
      comparePoint: freezed == comparePoint
          ? _value.comparePoint
          : comparePoint // ignore: cast_nullable_to_non_nullable
              as ChartPoint?,
      dateLabel: null == dateLabel
          ? _value.dateLabel
          : dateLabel // ignore: cast_nullable_to_non_nullable
              as String,
      compareDateLabel: freezed == compareDateLabel
          ? _value.compareDateLabel
          : compareDateLabel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ChartPointSelectionImpl implements _ChartPointSelection {
  const _$ChartPointSelectionImpl(
      {required this.point,
      this.comparePoint,
      required this.dateLabel,
      this.compareDateLabel});

  @override
  final ChartPoint point;
  @override
  final ChartPoint? comparePoint;
  @override
  final String dateLabel;
  @override
  final String? compareDateLabel;

  @override
  String toString() {
    return 'ChartPointSelection(point: $point, comparePoint: $comparePoint, dateLabel: $dateLabel, compareDateLabel: $compareDateLabel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChartPointSelectionImpl &&
            (identical(other.point, point) || other.point == point) &&
            (identical(other.comparePoint, comparePoint) ||
                other.comparePoint == comparePoint) &&
            (identical(other.dateLabel, dateLabel) ||
                other.dateLabel == dateLabel) &&
            (identical(other.compareDateLabel, compareDateLabel) ||
                other.compareDateLabel == compareDateLabel));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, point, comparePoint, dateLabel, compareDateLabel);

  /// Create a copy of ChartPointSelection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChartPointSelectionImplCopyWith<_$ChartPointSelectionImpl> get copyWith =>
      __$$ChartPointSelectionImplCopyWithImpl<_$ChartPointSelectionImpl>(
          this, _$identity);
}

abstract class _ChartPointSelection implements ChartPointSelection {
  const factory _ChartPointSelection(
      {required final ChartPoint point,
      final ChartPoint? comparePoint,
      required final String dateLabel,
      final String? compareDateLabel}) = _$ChartPointSelectionImpl;

  @override
  ChartPoint get point;
  @override
  ChartPoint? get comparePoint;
  @override
  String get dateLabel;
  @override
  String? get compareDateLabel;

  /// Create a copy of ChartPointSelection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChartPointSelectionImplCopyWith<_$ChartPointSelectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
