// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SalesSummaryModel _$SalesSummaryModelFromJson(Map<String, dynamic> json) {
  return _SalesSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$SalesSummaryModel {
  DateTime get selectedDate => throw _privateConstructorUsedError;
  DateTime? get compareDate => throw _privateConstructorUsedError;
  double get grossSales => throw _privateConstructorUsedError;
  double get netSales => throw _privateConstructorUsedError;
  double get taxes => throw _privateConstructorUsedError;
  double get discounts => throw _privateConstructorUsedError;
  double get returns => throw _privateConstructorUsedError;
  double get tips => throw _privateConstructorUsedError;
  double get serviceCharges => throw _privateConstructorUsedError;
  double get totalSales => throw _privateConstructorUsedError;
  double get totalCollected => throw _privateConstructorUsedError;
  PaymentsBreakdown get paymentsBreakdown => throw _privateConstructorUsedError;
  List<HourlySalesPoint> get hourlySalesPointsSelectedDay =>
      throw _privateConstructorUsedError;
  List<HourlySalesPoint> get hourlySalesPointsCompareDay =>
      throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  int get totalOrders => throw _privateConstructorUsedError;
  double get productSales =>
      throw _privateConstructorUsedError; // Enhanced analytics
  List<PaymentMethodTrend> get paymentMethodTrends =>
      throw _privateConstructorUsedError;
  List<KioskPerformance> get kioskPerformances =>
      throw _privateConstructorUsedError;
  double get averageOrderValue => throw _privateConstructorUsedError;
  int get peakHour => throw _privateConstructorUsedError;
  double get peakHourSales => throw _privateConstructorUsedError;

  /// Serializes this SalesSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalesSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalesSummaryModelCopyWith<SalesSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesSummaryModelCopyWith<$Res> {
  factory $SalesSummaryModelCopyWith(
          SalesSummaryModel value, $Res Function(SalesSummaryModel) then) =
      _$SalesSummaryModelCopyWithImpl<$Res, SalesSummaryModel>;
  @useResult
  $Res call(
      {DateTime selectedDate,
      DateTime? compareDate,
      double grossSales,
      double netSales,
      double taxes,
      double discounts,
      double returns,
      double tips,
      double serviceCharges,
      double totalSales,
      double totalCollected,
      PaymentsBreakdown paymentsBreakdown,
      List<HourlySalesPoint> hourlySalesPointsSelectedDay,
      List<HourlySalesPoint> hourlySalesPointsCompareDay,
      DateTime lastUpdated,
      int totalOrders,
      double productSales,
      List<PaymentMethodTrend> paymentMethodTrends,
      List<KioskPerformance> kioskPerformances,
      double averageOrderValue,
      int peakHour,
      double peakHourSales});

  $PaymentsBreakdownCopyWith<$Res> get paymentsBreakdown;
}

/// @nodoc
class _$SalesSummaryModelCopyWithImpl<$Res, $Val extends SalesSummaryModel>
    implements $SalesSummaryModelCopyWith<$Res> {
  _$SalesSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalesSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedDate = null,
    Object? compareDate = freezed,
    Object? grossSales = null,
    Object? netSales = null,
    Object? taxes = null,
    Object? discounts = null,
    Object? returns = null,
    Object? tips = null,
    Object? serviceCharges = null,
    Object? totalSales = null,
    Object? totalCollected = null,
    Object? paymentsBreakdown = null,
    Object? hourlySalesPointsSelectedDay = null,
    Object? hourlySalesPointsCompareDay = null,
    Object? lastUpdated = null,
    Object? totalOrders = null,
    Object? productSales = null,
    Object? paymentMethodTrends = null,
    Object? kioskPerformances = null,
    Object? averageOrderValue = null,
    Object? peakHour = null,
    Object? peakHourSales = null,
  }) {
    return _then(_value.copyWith(
      selectedDate: null == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      compareDate: freezed == compareDate
          ? _value.compareDate
          : compareDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      grossSales: null == grossSales
          ? _value.grossSales
          : grossSales // ignore: cast_nullable_to_non_nullable
              as double,
      netSales: null == netSales
          ? _value.netSales
          : netSales // ignore: cast_nullable_to_non_nullable
              as double,
      taxes: null == taxes
          ? _value.taxes
          : taxes // ignore: cast_nullable_to_non_nullable
              as double,
      discounts: null == discounts
          ? _value.discounts
          : discounts // ignore: cast_nullable_to_non_nullable
              as double,
      returns: null == returns
          ? _value.returns
          : returns // ignore: cast_nullable_to_non_nullable
              as double,
      tips: null == tips
          ? _value.tips
          : tips // ignore: cast_nullable_to_non_nullable
              as double,
      serviceCharges: null == serviceCharges
          ? _value.serviceCharges
          : serviceCharges // ignore: cast_nullable_to_non_nullable
              as double,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as double,
      totalCollected: null == totalCollected
          ? _value.totalCollected
          : totalCollected // ignore: cast_nullable_to_non_nullable
              as double,
      paymentsBreakdown: null == paymentsBreakdown
          ? _value.paymentsBreakdown
          : paymentsBreakdown // ignore: cast_nullable_to_non_nullable
              as PaymentsBreakdown,
      hourlySalesPointsSelectedDay: null == hourlySalesPointsSelectedDay
          ? _value.hourlySalesPointsSelectedDay
          : hourlySalesPointsSelectedDay // ignore: cast_nullable_to_non_nullable
              as List<HourlySalesPoint>,
      hourlySalesPointsCompareDay: null == hourlySalesPointsCompareDay
          ? _value.hourlySalesPointsCompareDay
          : hourlySalesPointsCompareDay // ignore: cast_nullable_to_non_nullable
              as List<HourlySalesPoint>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      productSales: null == productSales
          ? _value.productSales
          : productSales // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethodTrends: null == paymentMethodTrends
          ? _value.paymentMethodTrends
          : paymentMethodTrends // ignore: cast_nullable_to_non_nullable
              as List<PaymentMethodTrend>,
      kioskPerformances: null == kioskPerformances
          ? _value.kioskPerformances
          : kioskPerformances // ignore: cast_nullable_to_non_nullable
              as List<KioskPerformance>,
      averageOrderValue: null == averageOrderValue
          ? _value.averageOrderValue
          : averageOrderValue // ignore: cast_nullable_to_non_nullable
              as double,
      peakHour: null == peakHour
          ? _value.peakHour
          : peakHour // ignore: cast_nullable_to_non_nullable
              as int,
      peakHourSales: null == peakHourSales
          ? _value.peakHourSales
          : peakHourSales // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of SalesSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaymentsBreakdownCopyWith<$Res> get paymentsBreakdown {
    return $PaymentsBreakdownCopyWith<$Res>(_value.paymentsBreakdown, (value) {
      return _then(_value.copyWith(paymentsBreakdown: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SalesSummaryModelImplCopyWith<$Res>
    implements $SalesSummaryModelCopyWith<$Res> {
  factory _$$SalesSummaryModelImplCopyWith(_$SalesSummaryModelImpl value,
          $Res Function(_$SalesSummaryModelImpl) then) =
      __$$SalesSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime selectedDate,
      DateTime? compareDate,
      double grossSales,
      double netSales,
      double taxes,
      double discounts,
      double returns,
      double tips,
      double serviceCharges,
      double totalSales,
      double totalCollected,
      PaymentsBreakdown paymentsBreakdown,
      List<HourlySalesPoint> hourlySalesPointsSelectedDay,
      List<HourlySalesPoint> hourlySalesPointsCompareDay,
      DateTime lastUpdated,
      int totalOrders,
      double productSales,
      List<PaymentMethodTrend> paymentMethodTrends,
      List<KioskPerformance> kioskPerformances,
      double averageOrderValue,
      int peakHour,
      double peakHourSales});

  @override
  $PaymentsBreakdownCopyWith<$Res> get paymentsBreakdown;
}

/// @nodoc
class __$$SalesSummaryModelImplCopyWithImpl<$Res>
    extends _$SalesSummaryModelCopyWithImpl<$Res, _$SalesSummaryModelImpl>
    implements _$$SalesSummaryModelImplCopyWith<$Res> {
  __$$SalesSummaryModelImplCopyWithImpl(_$SalesSummaryModelImpl _value,
      $Res Function(_$SalesSummaryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SalesSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedDate = null,
    Object? compareDate = freezed,
    Object? grossSales = null,
    Object? netSales = null,
    Object? taxes = null,
    Object? discounts = null,
    Object? returns = null,
    Object? tips = null,
    Object? serviceCharges = null,
    Object? totalSales = null,
    Object? totalCollected = null,
    Object? paymentsBreakdown = null,
    Object? hourlySalesPointsSelectedDay = null,
    Object? hourlySalesPointsCompareDay = null,
    Object? lastUpdated = null,
    Object? totalOrders = null,
    Object? productSales = null,
    Object? paymentMethodTrends = null,
    Object? kioskPerformances = null,
    Object? averageOrderValue = null,
    Object? peakHour = null,
    Object? peakHourSales = null,
  }) {
    return _then(_$SalesSummaryModelImpl(
      selectedDate: null == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      compareDate: freezed == compareDate
          ? _value.compareDate
          : compareDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      grossSales: null == grossSales
          ? _value.grossSales
          : grossSales // ignore: cast_nullable_to_non_nullable
              as double,
      netSales: null == netSales
          ? _value.netSales
          : netSales // ignore: cast_nullable_to_non_nullable
              as double,
      taxes: null == taxes
          ? _value.taxes
          : taxes // ignore: cast_nullable_to_non_nullable
              as double,
      discounts: null == discounts
          ? _value.discounts
          : discounts // ignore: cast_nullable_to_non_nullable
              as double,
      returns: null == returns
          ? _value.returns
          : returns // ignore: cast_nullable_to_non_nullable
              as double,
      tips: null == tips
          ? _value.tips
          : tips // ignore: cast_nullable_to_non_nullable
              as double,
      serviceCharges: null == serviceCharges
          ? _value.serviceCharges
          : serviceCharges // ignore: cast_nullable_to_non_nullable
              as double,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as double,
      totalCollected: null == totalCollected
          ? _value.totalCollected
          : totalCollected // ignore: cast_nullable_to_non_nullable
              as double,
      paymentsBreakdown: null == paymentsBreakdown
          ? _value.paymentsBreakdown
          : paymentsBreakdown // ignore: cast_nullable_to_non_nullable
              as PaymentsBreakdown,
      hourlySalesPointsSelectedDay: null == hourlySalesPointsSelectedDay
          ? _value._hourlySalesPointsSelectedDay
          : hourlySalesPointsSelectedDay // ignore: cast_nullable_to_non_nullable
              as List<HourlySalesPoint>,
      hourlySalesPointsCompareDay: null == hourlySalesPointsCompareDay
          ? _value._hourlySalesPointsCompareDay
          : hourlySalesPointsCompareDay // ignore: cast_nullable_to_non_nullable
              as List<HourlySalesPoint>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      productSales: null == productSales
          ? _value.productSales
          : productSales // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethodTrends: null == paymentMethodTrends
          ? _value._paymentMethodTrends
          : paymentMethodTrends // ignore: cast_nullable_to_non_nullable
              as List<PaymentMethodTrend>,
      kioskPerformances: null == kioskPerformances
          ? _value._kioskPerformances
          : kioskPerformances // ignore: cast_nullable_to_non_nullable
              as List<KioskPerformance>,
      averageOrderValue: null == averageOrderValue
          ? _value.averageOrderValue
          : averageOrderValue // ignore: cast_nullable_to_non_nullable
              as double,
      peakHour: null == peakHour
          ? _value.peakHour
          : peakHour // ignore: cast_nullable_to_non_nullable
              as int,
      peakHourSales: null == peakHourSales
          ? _value.peakHourSales
          : peakHourSales // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalesSummaryModelImpl implements _SalesSummaryModel {
  const _$SalesSummaryModelImpl(
      {required this.selectedDate,
      this.compareDate,
      required this.grossSales,
      required this.netSales,
      required this.taxes,
      this.discounts = 0.0,
      this.returns = 0.0,
      this.tips = 0.0,
      this.serviceCharges = 0.0,
      required this.totalSales,
      required this.totalCollected,
      required this.paymentsBreakdown,
      final List<HourlySalesPoint> hourlySalesPointsSelectedDay = const [],
      final List<HourlySalesPoint> hourlySalesPointsCompareDay = const [],
      required this.lastUpdated,
      this.totalOrders = 0,
      this.productSales = 0.0,
      final List<PaymentMethodTrend> paymentMethodTrends = const [],
      final List<KioskPerformance> kioskPerformances = const [],
      this.averageOrderValue = 0.0,
      this.peakHour = 0,
      this.peakHourSales = 0.0})
      : _hourlySalesPointsSelectedDay = hourlySalesPointsSelectedDay,
        _hourlySalesPointsCompareDay = hourlySalesPointsCompareDay,
        _paymentMethodTrends = paymentMethodTrends,
        _kioskPerformances = kioskPerformances;

  factory _$SalesSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalesSummaryModelImplFromJson(json);

  @override
  final DateTime selectedDate;
  @override
  final DateTime? compareDate;
  @override
  final double grossSales;
  @override
  final double netSales;
  @override
  final double taxes;
  @override
  @JsonKey()
  final double discounts;
  @override
  @JsonKey()
  final double returns;
  @override
  @JsonKey()
  final double tips;
  @override
  @JsonKey()
  final double serviceCharges;
  @override
  final double totalSales;
  @override
  final double totalCollected;
  @override
  final PaymentsBreakdown paymentsBreakdown;
  final List<HourlySalesPoint> _hourlySalesPointsSelectedDay;
  @override
  @JsonKey()
  List<HourlySalesPoint> get hourlySalesPointsSelectedDay {
    if (_hourlySalesPointsSelectedDay is EqualUnmodifiableListView)
      return _hourlySalesPointsSelectedDay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hourlySalesPointsSelectedDay);
  }

  final List<HourlySalesPoint> _hourlySalesPointsCompareDay;
  @override
  @JsonKey()
  List<HourlySalesPoint> get hourlySalesPointsCompareDay {
    if (_hourlySalesPointsCompareDay is EqualUnmodifiableListView)
      return _hourlySalesPointsCompareDay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hourlySalesPointsCompareDay);
  }

  @override
  final DateTime lastUpdated;
  @override
  @JsonKey()
  final int totalOrders;
  @override
  @JsonKey()
  final double productSales;
// Enhanced analytics
  final List<PaymentMethodTrend> _paymentMethodTrends;
// Enhanced analytics
  @override
  @JsonKey()
  List<PaymentMethodTrend> get paymentMethodTrends {
    if (_paymentMethodTrends is EqualUnmodifiableListView)
      return _paymentMethodTrends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_paymentMethodTrends);
  }

  final List<KioskPerformance> _kioskPerformances;
  @override
  @JsonKey()
  List<KioskPerformance> get kioskPerformances {
    if (_kioskPerformances is EqualUnmodifiableListView)
      return _kioskPerformances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_kioskPerformances);
  }

  @override
  @JsonKey()
  final double averageOrderValue;
  @override
  @JsonKey()
  final int peakHour;
  @override
  @JsonKey()
  final double peakHourSales;

  @override
  String toString() {
    return 'SalesSummaryModel(selectedDate: $selectedDate, compareDate: $compareDate, grossSales: $grossSales, netSales: $netSales, taxes: $taxes, discounts: $discounts, returns: $returns, tips: $tips, serviceCharges: $serviceCharges, totalSales: $totalSales, totalCollected: $totalCollected, paymentsBreakdown: $paymentsBreakdown, hourlySalesPointsSelectedDay: $hourlySalesPointsSelectedDay, hourlySalesPointsCompareDay: $hourlySalesPointsCompareDay, lastUpdated: $lastUpdated, totalOrders: $totalOrders, productSales: $productSales, paymentMethodTrends: $paymentMethodTrends, kioskPerformances: $kioskPerformances, averageOrderValue: $averageOrderValue, peakHour: $peakHour, peakHourSales: $peakHourSales)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesSummaryModelImpl &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.compareDate, compareDate) ||
                other.compareDate == compareDate) &&
            (identical(other.grossSales, grossSales) ||
                other.grossSales == grossSales) &&
            (identical(other.netSales, netSales) ||
                other.netSales == netSales) &&
            (identical(other.taxes, taxes) || other.taxes == taxes) &&
            (identical(other.discounts, discounts) ||
                other.discounts == discounts) &&
            (identical(other.returns, returns) || other.returns == returns) &&
            (identical(other.tips, tips) || other.tips == tips) &&
            (identical(other.serviceCharges, serviceCharges) ||
                other.serviceCharges == serviceCharges) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.totalCollected, totalCollected) ||
                other.totalCollected == totalCollected) &&
            (identical(other.paymentsBreakdown, paymentsBreakdown) ||
                other.paymentsBreakdown == paymentsBreakdown) &&
            const DeepCollectionEquality().equals(
                other._hourlySalesPointsSelectedDay,
                _hourlySalesPointsSelectedDay) &&
            const DeepCollectionEquality().equals(
                other._hourlySalesPointsCompareDay,
                _hourlySalesPointsCompareDay) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.productSales, productSales) ||
                other.productSales == productSales) &&
            const DeepCollectionEquality()
                .equals(other._paymentMethodTrends, _paymentMethodTrends) &&
            const DeepCollectionEquality()
                .equals(other._kioskPerformances, _kioskPerformances) &&
            (identical(other.averageOrderValue, averageOrderValue) ||
                other.averageOrderValue == averageOrderValue) &&
            (identical(other.peakHour, peakHour) ||
                other.peakHour == peakHour) &&
            (identical(other.peakHourSales, peakHourSales) ||
                other.peakHourSales == peakHourSales));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        selectedDate,
        compareDate,
        grossSales,
        netSales,
        taxes,
        discounts,
        returns,
        tips,
        serviceCharges,
        totalSales,
        totalCollected,
        paymentsBreakdown,
        const DeepCollectionEquality().hash(_hourlySalesPointsSelectedDay),
        const DeepCollectionEquality().hash(_hourlySalesPointsCompareDay),
        lastUpdated,
        totalOrders,
        productSales,
        const DeepCollectionEquality().hash(_paymentMethodTrends),
        const DeepCollectionEquality().hash(_kioskPerformances),
        averageOrderValue,
        peakHour,
        peakHourSales
      ]);

  /// Create a copy of SalesSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesSummaryModelImplCopyWith<_$SalesSummaryModelImpl> get copyWith =>
      __$$SalesSummaryModelImplCopyWithImpl<_$SalesSummaryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalesSummaryModelImplToJson(
      this,
    );
  }
}

abstract class _SalesSummaryModel implements SalesSummaryModel {
  const factory _SalesSummaryModel(
      {required final DateTime selectedDate,
      final DateTime? compareDate,
      required final double grossSales,
      required final double netSales,
      required final double taxes,
      final double discounts,
      final double returns,
      final double tips,
      final double serviceCharges,
      required final double totalSales,
      required final double totalCollected,
      required final PaymentsBreakdown paymentsBreakdown,
      final List<HourlySalesPoint> hourlySalesPointsSelectedDay,
      final List<HourlySalesPoint> hourlySalesPointsCompareDay,
      required final DateTime lastUpdated,
      final int totalOrders,
      final double productSales,
      final List<PaymentMethodTrend> paymentMethodTrends,
      final List<KioskPerformance> kioskPerformances,
      final double averageOrderValue,
      final int peakHour,
      final double peakHourSales}) = _$SalesSummaryModelImpl;

  factory _SalesSummaryModel.fromJson(Map<String, dynamic> json) =
      _$SalesSummaryModelImpl.fromJson;

  @override
  DateTime get selectedDate;
  @override
  DateTime? get compareDate;
  @override
  double get grossSales;
  @override
  double get netSales;
  @override
  double get taxes;
  @override
  double get discounts;
  @override
  double get returns;
  @override
  double get tips;
  @override
  double get serviceCharges;
  @override
  double get totalSales;
  @override
  double get totalCollected;
  @override
  PaymentsBreakdown get paymentsBreakdown;
  @override
  List<HourlySalesPoint> get hourlySalesPointsSelectedDay;
  @override
  List<HourlySalesPoint> get hourlySalesPointsCompareDay;
  @override
  DateTime get lastUpdated;
  @override
  int get totalOrders;
  @override
  double get productSales; // Enhanced analytics
  @override
  List<PaymentMethodTrend> get paymentMethodTrends;
  @override
  List<KioskPerformance> get kioskPerformances;
  @override
  double get averageOrderValue;
  @override
  int get peakHour;
  @override
  double get peakHourSales;

  /// Create a copy of SalesSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalesSummaryModelImplCopyWith<_$SalesSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentsBreakdown _$PaymentsBreakdownFromJson(Map<String, dynamic> json) {
  return _PaymentsBreakdown.fromJson(json);
}

/// @nodoc
mixin _$PaymentsBreakdown {
  double get card => throw _privateConstructorUsedError;
  double get cash => throw _privateConstructorUsedError;
  double get giftCard => throw _privateConstructorUsedError;
  double get other => throw _privateConstructorUsedError;
  double get fees =>
      throw _privateConstructorUsedError; // Kiosk-specific breakdown
  double get qrCode => throw _privateConstructorUsedError;
  double get payAtCounter => throw _privateConstructorUsedError;
  int get qrCodeCount => throw _privateConstructorUsedError;
  int get payAtCounterCount => throw _privateConstructorUsedError;

  /// Serializes this PaymentsBreakdown to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentsBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentsBreakdownCopyWith<PaymentsBreakdown> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentsBreakdownCopyWith<$Res> {
  factory $PaymentsBreakdownCopyWith(
          PaymentsBreakdown value, $Res Function(PaymentsBreakdown) then) =
      _$PaymentsBreakdownCopyWithImpl<$Res, PaymentsBreakdown>;
  @useResult
  $Res call(
      {double card,
      double cash,
      double giftCard,
      double other,
      double fees,
      double qrCode,
      double payAtCounter,
      int qrCodeCount,
      int payAtCounterCount});
}

/// @nodoc
class _$PaymentsBreakdownCopyWithImpl<$Res, $Val extends PaymentsBreakdown>
    implements $PaymentsBreakdownCopyWith<$Res> {
  _$PaymentsBreakdownCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentsBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? card = null,
    Object? cash = null,
    Object? giftCard = null,
    Object? other = null,
    Object? fees = null,
    Object? qrCode = null,
    Object? payAtCounter = null,
    Object? qrCodeCount = null,
    Object? payAtCounterCount = null,
  }) {
    return _then(_value.copyWith(
      card: null == card
          ? _value.card
          : card // ignore: cast_nullable_to_non_nullable
              as double,
      cash: null == cash
          ? _value.cash
          : cash // ignore: cast_nullable_to_non_nullable
              as double,
      giftCard: null == giftCard
          ? _value.giftCard
          : giftCard // ignore: cast_nullable_to_non_nullable
              as double,
      other: null == other
          ? _value.other
          : other // ignore: cast_nullable_to_non_nullable
              as double,
      fees: null == fees
          ? _value.fees
          : fees // ignore: cast_nullable_to_non_nullable
              as double,
      qrCode: null == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as double,
      payAtCounter: null == payAtCounter
          ? _value.payAtCounter
          : payAtCounter // ignore: cast_nullable_to_non_nullable
              as double,
      qrCodeCount: null == qrCodeCount
          ? _value.qrCodeCount
          : qrCodeCount // ignore: cast_nullable_to_non_nullable
              as int,
      payAtCounterCount: null == payAtCounterCount
          ? _value.payAtCounterCount
          : payAtCounterCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentsBreakdownImplCopyWith<$Res>
    implements $PaymentsBreakdownCopyWith<$Res> {
  factory _$$PaymentsBreakdownImplCopyWith(_$PaymentsBreakdownImpl value,
          $Res Function(_$PaymentsBreakdownImpl) then) =
      __$$PaymentsBreakdownImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double card,
      double cash,
      double giftCard,
      double other,
      double fees,
      double qrCode,
      double payAtCounter,
      int qrCodeCount,
      int payAtCounterCount});
}

/// @nodoc
class __$$PaymentsBreakdownImplCopyWithImpl<$Res>
    extends _$PaymentsBreakdownCopyWithImpl<$Res, _$PaymentsBreakdownImpl>
    implements _$$PaymentsBreakdownImplCopyWith<$Res> {
  __$$PaymentsBreakdownImplCopyWithImpl(_$PaymentsBreakdownImpl _value,
      $Res Function(_$PaymentsBreakdownImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentsBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? card = null,
    Object? cash = null,
    Object? giftCard = null,
    Object? other = null,
    Object? fees = null,
    Object? qrCode = null,
    Object? payAtCounter = null,
    Object? qrCodeCount = null,
    Object? payAtCounterCount = null,
  }) {
    return _then(_$PaymentsBreakdownImpl(
      card: null == card
          ? _value.card
          : card // ignore: cast_nullable_to_non_nullable
              as double,
      cash: null == cash
          ? _value.cash
          : cash // ignore: cast_nullable_to_non_nullable
              as double,
      giftCard: null == giftCard
          ? _value.giftCard
          : giftCard // ignore: cast_nullable_to_non_nullable
              as double,
      other: null == other
          ? _value.other
          : other // ignore: cast_nullable_to_non_nullable
              as double,
      fees: null == fees
          ? _value.fees
          : fees // ignore: cast_nullable_to_non_nullable
              as double,
      qrCode: null == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as double,
      payAtCounter: null == payAtCounter
          ? _value.payAtCounter
          : payAtCounter // ignore: cast_nullable_to_non_nullable
              as double,
      qrCodeCount: null == qrCodeCount
          ? _value.qrCodeCount
          : qrCodeCount // ignore: cast_nullable_to_non_nullable
              as int,
      payAtCounterCount: null == payAtCounterCount
          ? _value.payAtCounterCount
          : payAtCounterCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentsBreakdownImpl implements _PaymentsBreakdown {
  const _$PaymentsBreakdownImpl(
      {this.card = 0.0,
      this.cash = 0.0,
      this.giftCard = 0.0,
      this.other = 0.0,
      this.fees = 0.0,
      this.qrCode = 0.0,
      this.payAtCounter = 0.0,
      this.qrCodeCount = 0,
      this.payAtCounterCount = 0});

  factory _$PaymentsBreakdownImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentsBreakdownImplFromJson(json);

  @override
  @JsonKey()
  final double card;
  @override
  @JsonKey()
  final double cash;
  @override
  @JsonKey()
  final double giftCard;
  @override
  @JsonKey()
  final double other;
  @override
  @JsonKey()
  final double fees;
// Kiosk-specific breakdown
  @override
  @JsonKey()
  final double qrCode;
  @override
  @JsonKey()
  final double payAtCounter;
  @override
  @JsonKey()
  final int qrCodeCount;
  @override
  @JsonKey()
  final int payAtCounterCount;

  @override
  String toString() {
    return 'PaymentsBreakdown(card: $card, cash: $cash, giftCard: $giftCard, other: $other, fees: $fees, qrCode: $qrCode, payAtCounter: $payAtCounter, qrCodeCount: $qrCodeCount, payAtCounterCount: $payAtCounterCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentsBreakdownImpl &&
            (identical(other.card, card) || other.card == card) &&
            (identical(other.cash, cash) || other.cash == cash) &&
            (identical(other.giftCard, giftCard) ||
                other.giftCard == giftCard) &&
            (identical(other.other, this.other) || other.other == this.other) &&
            (identical(other.fees, fees) || other.fees == fees) &&
            (identical(other.qrCode, qrCode) || other.qrCode == qrCode) &&
            (identical(other.payAtCounter, payAtCounter) ||
                other.payAtCounter == payAtCounter) &&
            (identical(other.qrCodeCount, qrCodeCount) ||
                other.qrCodeCount == qrCodeCount) &&
            (identical(other.payAtCounterCount, payAtCounterCount) ||
                other.payAtCounterCount == payAtCounterCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, card, cash, giftCard, other,
      fees, qrCode, payAtCounter, qrCodeCount, payAtCounterCount);

  /// Create a copy of PaymentsBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentsBreakdownImplCopyWith<_$PaymentsBreakdownImpl> get copyWith =>
      __$$PaymentsBreakdownImplCopyWithImpl<_$PaymentsBreakdownImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentsBreakdownImplToJson(
      this,
    );
  }
}

abstract class _PaymentsBreakdown implements PaymentsBreakdown {
  const factory _PaymentsBreakdown(
      {final double card,
      final double cash,
      final double giftCard,
      final double other,
      final double fees,
      final double qrCode,
      final double payAtCounter,
      final int qrCodeCount,
      final int payAtCounterCount}) = _$PaymentsBreakdownImpl;

  factory _PaymentsBreakdown.fromJson(Map<String, dynamic> json) =
      _$PaymentsBreakdownImpl.fromJson;

  @override
  double get card;
  @override
  double get cash;
  @override
  double get giftCard;
  @override
  double get other;
  @override
  double get fees; // Kiosk-specific breakdown
  @override
  double get qrCode;
  @override
  double get payAtCounter;
  @override
  int get qrCodeCount;
  @override
  int get payAtCounterCount;

  /// Create a copy of PaymentsBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentsBreakdownImplCopyWith<_$PaymentsBreakdownImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentMethodTrend _$PaymentMethodTrendFromJson(Map<String, dynamic> json) {
  return _PaymentMethodTrend.fromJson(json);
}

/// @nodoc
mixin _$PaymentMethodTrend {
  DateTime get timestamp => throw _privateConstructorUsedError;
  double get qrCodeAmount => throw _privateConstructorUsedError;
  double get payAtCounterAmount => throw _privateConstructorUsedError;
  int get qrCodeCount => throw _privateConstructorUsedError;
  int get payAtCounterCount => throw _privateConstructorUsedError;

  /// Serializes this PaymentMethodTrend to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentMethodTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentMethodTrendCopyWith<PaymentMethodTrend> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentMethodTrendCopyWith<$Res> {
  factory $PaymentMethodTrendCopyWith(
          PaymentMethodTrend value, $Res Function(PaymentMethodTrend) then) =
      _$PaymentMethodTrendCopyWithImpl<$Res, PaymentMethodTrend>;
  @useResult
  $Res call(
      {DateTime timestamp,
      double qrCodeAmount,
      double payAtCounterAmount,
      int qrCodeCount,
      int payAtCounterCount});
}

/// @nodoc
class _$PaymentMethodTrendCopyWithImpl<$Res, $Val extends PaymentMethodTrend>
    implements $PaymentMethodTrendCopyWith<$Res> {
  _$PaymentMethodTrendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentMethodTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? qrCodeAmount = null,
    Object? payAtCounterAmount = null,
    Object? qrCodeCount = null,
    Object? payAtCounterCount = null,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      qrCodeAmount: null == qrCodeAmount
          ? _value.qrCodeAmount
          : qrCodeAmount // ignore: cast_nullable_to_non_nullable
              as double,
      payAtCounterAmount: null == payAtCounterAmount
          ? _value.payAtCounterAmount
          : payAtCounterAmount // ignore: cast_nullable_to_non_nullable
              as double,
      qrCodeCount: null == qrCodeCount
          ? _value.qrCodeCount
          : qrCodeCount // ignore: cast_nullable_to_non_nullable
              as int,
      payAtCounterCount: null == payAtCounterCount
          ? _value.payAtCounterCount
          : payAtCounterCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentMethodTrendImplCopyWith<$Res>
    implements $PaymentMethodTrendCopyWith<$Res> {
  factory _$$PaymentMethodTrendImplCopyWith(_$PaymentMethodTrendImpl value,
          $Res Function(_$PaymentMethodTrendImpl) then) =
      __$$PaymentMethodTrendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime timestamp,
      double qrCodeAmount,
      double payAtCounterAmount,
      int qrCodeCount,
      int payAtCounterCount});
}

/// @nodoc
class __$$PaymentMethodTrendImplCopyWithImpl<$Res>
    extends _$PaymentMethodTrendCopyWithImpl<$Res, _$PaymentMethodTrendImpl>
    implements _$$PaymentMethodTrendImplCopyWith<$Res> {
  __$$PaymentMethodTrendImplCopyWithImpl(_$PaymentMethodTrendImpl _value,
      $Res Function(_$PaymentMethodTrendImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentMethodTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? qrCodeAmount = null,
    Object? payAtCounterAmount = null,
    Object? qrCodeCount = null,
    Object? payAtCounterCount = null,
  }) {
    return _then(_$PaymentMethodTrendImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      qrCodeAmount: null == qrCodeAmount
          ? _value.qrCodeAmount
          : qrCodeAmount // ignore: cast_nullable_to_non_nullable
              as double,
      payAtCounterAmount: null == payAtCounterAmount
          ? _value.payAtCounterAmount
          : payAtCounterAmount // ignore: cast_nullable_to_non_nullable
              as double,
      qrCodeCount: null == qrCodeCount
          ? _value.qrCodeCount
          : qrCodeCount // ignore: cast_nullable_to_non_nullable
              as int,
      payAtCounterCount: null == payAtCounterCount
          ? _value.payAtCounterCount
          : payAtCounterCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentMethodTrendImpl implements _PaymentMethodTrend {
  const _$PaymentMethodTrendImpl(
      {required this.timestamp,
      required this.qrCodeAmount,
      required this.payAtCounterAmount,
      required this.qrCodeCount,
      required this.payAtCounterCount});

  factory _$PaymentMethodTrendImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentMethodTrendImplFromJson(json);

  @override
  final DateTime timestamp;
  @override
  final double qrCodeAmount;
  @override
  final double payAtCounterAmount;
  @override
  final int qrCodeCount;
  @override
  final int payAtCounterCount;

  @override
  String toString() {
    return 'PaymentMethodTrend(timestamp: $timestamp, qrCodeAmount: $qrCodeAmount, payAtCounterAmount: $payAtCounterAmount, qrCodeCount: $qrCodeCount, payAtCounterCount: $payAtCounterCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodTrendImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.qrCodeAmount, qrCodeAmount) ||
                other.qrCodeAmount == qrCodeAmount) &&
            (identical(other.payAtCounterAmount, payAtCounterAmount) ||
                other.payAtCounterAmount == payAtCounterAmount) &&
            (identical(other.qrCodeCount, qrCodeCount) ||
                other.qrCodeCount == qrCodeCount) &&
            (identical(other.payAtCounterCount, payAtCounterCount) ||
                other.payAtCounterCount == payAtCounterCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, timestamp, qrCodeAmount,
      payAtCounterAmount, qrCodeCount, payAtCounterCount);

  /// Create a copy of PaymentMethodTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentMethodTrendImplCopyWith<_$PaymentMethodTrendImpl> get copyWith =>
      __$$PaymentMethodTrendImplCopyWithImpl<_$PaymentMethodTrendImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentMethodTrendImplToJson(
      this,
    );
  }
}

abstract class _PaymentMethodTrend implements PaymentMethodTrend {
  const factory _PaymentMethodTrend(
      {required final DateTime timestamp,
      required final double qrCodeAmount,
      required final double payAtCounterAmount,
      required final int qrCodeCount,
      required final int payAtCounterCount}) = _$PaymentMethodTrendImpl;

  factory _PaymentMethodTrend.fromJson(Map<String, dynamic> json) =
      _$PaymentMethodTrendImpl.fromJson;

  @override
  DateTime get timestamp;
  @override
  double get qrCodeAmount;
  @override
  double get payAtCounterAmount;
  @override
  int get qrCodeCount;
  @override
  int get payAtCounterCount;

  /// Create a copy of PaymentMethodTrend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentMethodTrendImplCopyWith<_$PaymentMethodTrendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KioskPerformance _$KioskPerformanceFromJson(Map<String, dynamic> json) {
  return _KioskPerformance.fromJson(json);
}

/// @nodoc
mixin _$KioskPerformance {
  String get kioskId => throw _privateConstructorUsedError;
  String get kioskName => throw _privateConstructorUsedError;
  double get totalSales => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;
  double get averageOrderValue => throw _privateConstructorUsedError;
  double get qrCodeSales => throw _privateConstructorUsedError;
  double get payAtCounterSales => throw _privateConstructorUsedError;

  /// Serializes this KioskPerformance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KioskPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KioskPerformanceCopyWith<KioskPerformance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KioskPerformanceCopyWith<$Res> {
  factory $KioskPerformanceCopyWith(
          KioskPerformance value, $Res Function(KioskPerformance) then) =
      _$KioskPerformanceCopyWithImpl<$Res, KioskPerformance>;
  @useResult
  $Res call(
      {String kioskId,
      String kioskName,
      double totalSales,
      int transactionCount,
      double averageOrderValue,
      double qrCodeSales,
      double payAtCounterSales});
}

/// @nodoc
class _$KioskPerformanceCopyWithImpl<$Res, $Val extends KioskPerformance>
    implements $KioskPerformanceCopyWith<$Res> {
  _$KioskPerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KioskPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kioskId = null,
    Object? kioskName = null,
    Object? totalSales = null,
    Object? transactionCount = null,
    Object? averageOrderValue = null,
    Object? qrCodeSales = null,
    Object? payAtCounterSales = null,
  }) {
    return _then(_value.copyWith(
      kioskId: null == kioskId
          ? _value.kioskId
          : kioskId // ignore: cast_nullable_to_non_nullable
              as String,
      kioskName: null == kioskName
          ? _value.kioskName
          : kioskName // ignore: cast_nullable_to_non_nullable
              as String,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      averageOrderValue: null == averageOrderValue
          ? _value.averageOrderValue
          : averageOrderValue // ignore: cast_nullable_to_non_nullable
              as double,
      qrCodeSales: null == qrCodeSales
          ? _value.qrCodeSales
          : qrCodeSales // ignore: cast_nullable_to_non_nullable
              as double,
      payAtCounterSales: null == payAtCounterSales
          ? _value.payAtCounterSales
          : payAtCounterSales // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KioskPerformanceImplCopyWith<$Res>
    implements $KioskPerformanceCopyWith<$Res> {
  factory _$$KioskPerformanceImplCopyWith(_$KioskPerformanceImpl value,
          $Res Function(_$KioskPerformanceImpl) then) =
      __$$KioskPerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String kioskId,
      String kioskName,
      double totalSales,
      int transactionCount,
      double averageOrderValue,
      double qrCodeSales,
      double payAtCounterSales});
}

/// @nodoc
class __$$KioskPerformanceImplCopyWithImpl<$Res>
    extends _$KioskPerformanceCopyWithImpl<$Res, _$KioskPerformanceImpl>
    implements _$$KioskPerformanceImplCopyWith<$Res> {
  __$$KioskPerformanceImplCopyWithImpl(_$KioskPerformanceImpl _value,
      $Res Function(_$KioskPerformanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of KioskPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kioskId = null,
    Object? kioskName = null,
    Object? totalSales = null,
    Object? transactionCount = null,
    Object? averageOrderValue = null,
    Object? qrCodeSales = null,
    Object? payAtCounterSales = null,
  }) {
    return _then(_$KioskPerformanceImpl(
      kioskId: null == kioskId
          ? _value.kioskId
          : kioskId // ignore: cast_nullable_to_non_nullable
              as String,
      kioskName: null == kioskName
          ? _value.kioskName
          : kioskName // ignore: cast_nullable_to_non_nullable
              as String,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      averageOrderValue: null == averageOrderValue
          ? _value.averageOrderValue
          : averageOrderValue // ignore: cast_nullable_to_non_nullable
              as double,
      qrCodeSales: null == qrCodeSales
          ? _value.qrCodeSales
          : qrCodeSales // ignore: cast_nullable_to_non_nullable
              as double,
      payAtCounterSales: null == payAtCounterSales
          ? _value.payAtCounterSales
          : payAtCounterSales // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KioskPerformanceImpl implements _KioskPerformance {
  const _$KioskPerformanceImpl(
      {required this.kioskId,
      required this.kioskName,
      required this.totalSales,
      required this.transactionCount,
      required this.averageOrderValue,
      required this.qrCodeSales,
      required this.payAtCounterSales});

  factory _$KioskPerformanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$KioskPerformanceImplFromJson(json);

  @override
  final String kioskId;
  @override
  final String kioskName;
  @override
  final double totalSales;
  @override
  final int transactionCount;
  @override
  final double averageOrderValue;
  @override
  final double qrCodeSales;
  @override
  final double payAtCounterSales;

  @override
  String toString() {
    return 'KioskPerformance(kioskId: $kioskId, kioskName: $kioskName, totalSales: $totalSales, transactionCount: $transactionCount, averageOrderValue: $averageOrderValue, qrCodeSales: $qrCodeSales, payAtCounterSales: $payAtCounterSales)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KioskPerformanceImpl &&
            (identical(other.kioskId, kioskId) || other.kioskId == kioskId) &&
            (identical(other.kioskName, kioskName) ||
                other.kioskName == kioskName) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            (identical(other.averageOrderValue, averageOrderValue) ||
                other.averageOrderValue == averageOrderValue) &&
            (identical(other.qrCodeSales, qrCodeSales) ||
                other.qrCodeSales == qrCodeSales) &&
            (identical(other.payAtCounterSales, payAtCounterSales) ||
                other.payAtCounterSales == payAtCounterSales));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kioskId, kioskName, totalSales,
      transactionCount, averageOrderValue, qrCodeSales, payAtCounterSales);

  /// Create a copy of KioskPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KioskPerformanceImplCopyWith<_$KioskPerformanceImpl> get copyWith =>
      __$$KioskPerformanceImplCopyWithImpl<_$KioskPerformanceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KioskPerformanceImplToJson(
      this,
    );
  }
}

abstract class _KioskPerformance implements KioskPerformance {
  const factory _KioskPerformance(
      {required final String kioskId,
      required final String kioskName,
      required final double totalSales,
      required final int transactionCount,
      required final double averageOrderValue,
      required final double qrCodeSales,
      required final double payAtCounterSales}) = _$KioskPerformanceImpl;

  factory _KioskPerformance.fromJson(Map<String, dynamic> json) =
      _$KioskPerformanceImpl.fromJson;

  @override
  String get kioskId;
  @override
  String get kioskName;
  @override
  double get totalSales;
  @override
  int get transactionCount;
  @override
  double get averageOrderValue;
  @override
  double get qrCodeSales;
  @override
  double get payAtCounterSales;

  /// Create a copy of KioskPerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KioskPerformanceImplCopyWith<_$KioskPerformanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HourlySalesPoint _$HourlySalesPointFromJson(Map<String, dynamic> json) {
  return _HourlySalesPoint.fromJson(json);
}

/// @nodoc
mixin _$HourlySalesPoint {
  int get hour => throw _privateConstructorUsedError; // 0-23
  double get sales => throw _privateConstructorUsedError;

  /// Serializes this HourlySalesPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HourlySalesPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HourlySalesPointCopyWith<HourlySalesPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HourlySalesPointCopyWith<$Res> {
  factory $HourlySalesPointCopyWith(
          HourlySalesPoint value, $Res Function(HourlySalesPoint) then) =
      _$HourlySalesPointCopyWithImpl<$Res, HourlySalesPoint>;
  @useResult
  $Res call({int hour, double sales});
}

/// @nodoc
class _$HourlySalesPointCopyWithImpl<$Res, $Val extends HourlySalesPoint>
    implements $HourlySalesPointCopyWith<$Res> {
  _$HourlySalesPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HourlySalesPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? sales = null,
  }) {
    return _then(_value.copyWith(
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      sales: null == sales
          ? _value.sales
          : sales // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HourlySalesPointImplCopyWith<$Res>
    implements $HourlySalesPointCopyWith<$Res> {
  factory _$$HourlySalesPointImplCopyWith(_$HourlySalesPointImpl value,
          $Res Function(_$HourlySalesPointImpl) then) =
      __$$HourlySalesPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int hour, double sales});
}

/// @nodoc
class __$$HourlySalesPointImplCopyWithImpl<$Res>
    extends _$HourlySalesPointCopyWithImpl<$Res, _$HourlySalesPointImpl>
    implements _$$HourlySalesPointImplCopyWith<$Res> {
  __$$HourlySalesPointImplCopyWithImpl(_$HourlySalesPointImpl _value,
      $Res Function(_$HourlySalesPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of HourlySalesPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? sales = null,
  }) {
    return _then(_$HourlySalesPointImpl(
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      sales: null == sales
          ? _value.sales
          : sales // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HourlySalesPointImpl implements _HourlySalesPoint {
  const _$HourlySalesPointImpl({required this.hour, required this.sales});

  factory _$HourlySalesPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$HourlySalesPointImplFromJson(json);

  @override
  final int hour;
// 0-23
  @override
  final double sales;

  @override
  String toString() {
    return 'HourlySalesPoint(hour: $hour, sales: $sales)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HourlySalesPointImpl &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.sales, sales) || other.sales == sales));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hour, sales);

  /// Create a copy of HourlySalesPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HourlySalesPointImplCopyWith<_$HourlySalesPointImpl> get copyWith =>
      __$$HourlySalesPointImplCopyWithImpl<_$HourlySalesPointImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HourlySalesPointImplToJson(
      this,
    );
  }
}

abstract class _HourlySalesPoint implements HourlySalesPoint {
  const factory _HourlySalesPoint(
      {required final int hour,
      required final double sales}) = _$HourlySalesPointImpl;

  factory _HourlySalesPoint.fromJson(Map<String, dynamic> json) =
      _$HourlySalesPointImpl.fromJson;

  @override
  int get hour; // 0-23
  @override
  double get sales;

  /// Create a copy of HourlySalesPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HourlySalesPointImplCopyWith<_$HourlySalesPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
