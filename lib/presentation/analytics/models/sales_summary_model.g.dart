// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalesSummaryModelImpl _$$SalesSummaryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SalesSummaryModelImpl(
      selectedDate: DateTime.parse(json['selectedDate'] as String),
      compareDate: json['compareDate'] == null
          ? null
          : DateTime.parse(json['compareDate'] as String),
      grossSales: (json['grossSales'] as num).toDouble(),
      netSales: (json['netSales'] as num).toDouble(),
      taxes: (json['taxes'] as num).toDouble(),
      discounts: (json['discounts'] as num?)?.toDouble() ?? 0.0,
      returns: (json['returns'] as num?)?.toDouble() ?? 0.0,
      tips: (json['tips'] as num?)?.toDouble() ?? 0.0,
      serviceCharges: (json['serviceCharges'] as num?)?.toDouble() ?? 0.0,
      totalSales: (json['totalSales'] as num).toDouble(),
      totalCollected: (json['totalCollected'] as num).toDouble(),
      paymentsBreakdown: PaymentsBreakdown.fromJson(
          json['paymentsBreakdown'] as Map<String, dynamic>),
      hourlySalesPointsSelectedDay: (json['hourlySalesPointsSelectedDay']
                  as List<dynamic>?)
              ?.map((e) => HourlySalesPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      hourlySalesPointsCompareDay: (json['hourlySalesPointsCompareDay']
                  as List<dynamic>?)
              ?.map((e) => HourlySalesPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
      productSales: (json['productSales'] as num?)?.toDouble() ?? 0.0,
      paymentMethodTrends: (json['paymentMethodTrends'] as List<dynamic>?)
              ?.map(
                  (e) => PaymentMethodTrend.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      kioskPerformances: (json['kioskPerformances'] as List<dynamic>?)
              ?.map((e) => KioskPerformance.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      averageOrderValue: (json['averageOrderValue'] as num?)?.toDouble() ?? 0.0,
      peakHour: (json['peakHour'] as num?)?.toInt() ?? 0,
      peakHourSales: (json['peakHourSales'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$SalesSummaryModelImplToJson(
        _$SalesSummaryModelImpl instance) =>
    <String, dynamic>{
      'selectedDate': instance.selectedDate.toIso8601String(),
      'compareDate': instance.compareDate?.toIso8601String(),
      'grossSales': instance.grossSales,
      'netSales': instance.netSales,
      'taxes': instance.taxes,
      'discounts': instance.discounts,
      'returns': instance.returns,
      'tips': instance.tips,
      'serviceCharges': instance.serviceCharges,
      'totalSales': instance.totalSales,
      'totalCollected': instance.totalCollected,
      'paymentsBreakdown': instance.paymentsBreakdown,
      'hourlySalesPointsSelectedDay': instance.hourlySalesPointsSelectedDay,
      'hourlySalesPointsCompareDay': instance.hourlySalesPointsCompareDay,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'totalOrders': instance.totalOrders,
      'productSales': instance.productSales,
      'paymentMethodTrends': instance.paymentMethodTrends,
      'kioskPerformances': instance.kioskPerformances,
      'averageOrderValue': instance.averageOrderValue,
      'peakHour': instance.peakHour,
      'peakHourSales': instance.peakHourSales,
    };

_$PaymentsBreakdownImpl _$$PaymentsBreakdownImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentsBreakdownImpl(
      card: (json['card'] as num?)?.toDouble() ?? 0.0,
      cash: (json['cash'] as num?)?.toDouble() ?? 0.0,
      giftCard: (json['giftCard'] as num?)?.toDouble() ?? 0.0,
      other: (json['other'] as num?)?.toDouble() ?? 0.0,
      fees: (json['fees'] as num?)?.toDouble() ?? 0.0,
      qrCode: (json['qrCode'] as num?)?.toDouble() ?? 0.0,
      payAtCounter: (json['payAtCounter'] as num?)?.toDouble() ?? 0.0,
      qrCodeCount: (json['qrCodeCount'] as num?)?.toInt() ?? 0,
      payAtCounterCount: (json['payAtCounterCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PaymentsBreakdownImplToJson(
        _$PaymentsBreakdownImpl instance) =>
    <String, dynamic>{
      'card': instance.card,
      'cash': instance.cash,
      'giftCard': instance.giftCard,
      'other': instance.other,
      'fees': instance.fees,
      'qrCode': instance.qrCode,
      'payAtCounter': instance.payAtCounter,
      'qrCodeCount': instance.qrCodeCount,
      'payAtCounterCount': instance.payAtCounterCount,
    };

_$PaymentMethodTrendImpl _$$PaymentMethodTrendImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentMethodTrendImpl(
      timestamp: DateTime.parse(json['timestamp'] as String),
      qrCodeAmount: (json['qrCodeAmount'] as num).toDouble(),
      payAtCounterAmount: (json['payAtCounterAmount'] as num).toDouble(),
      qrCodeCount: (json['qrCodeCount'] as num).toInt(),
      payAtCounterCount: (json['payAtCounterCount'] as num).toInt(),
    );

Map<String, dynamic> _$$PaymentMethodTrendImplToJson(
        _$PaymentMethodTrendImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'qrCodeAmount': instance.qrCodeAmount,
      'payAtCounterAmount': instance.payAtCounterAmount,
      'qrCodeCount': instance.qrCodeCount,
      'payAtCounterCount': instance.payAtCounterCount,
    };

_$KioskPerformanceImpl _$$KioskPerformanceImplFromJson(
        Map<String, dynamic> json) =>
    _$KioskPerformanceImpl(
      kioskId: json['kioskId'] as String,
      kioskName: json['kioskName'] as String,
      totalSales: (json['totalSales'] as num).toDouble(),
      transactionCount: (json['transactionCount'] as num).toInt(),
      averageOrderValue: (json['averageOrderValue'] as num).toDouble(),
      qrCodeSales: (json['qrCodeSales'] as num).toDouble(),
      payAtCounterSales: (json['payAtCounterSales'] as num).toDouble(),
    );

Map<String, dynamic> _$$KioskPerformanceImplToJson(
        _$KioskPerformanceImpl instance) =>
    <String, dynamic>{
      'kioskId': instance.kioskId,
      'kioskName': instance.kioskName,
      'totalSales': instance.totalSales,
      'transactionCount': instance.transactionCount,
      'averageOrderValue': instance.averageOrderValue,
      'qrCodeSales': instance.qrCodeSales,
      'payAtCounterSales': instance.payAtCounterSales,
    };

_$HourlySalesPointImpl _$$HourlySalesPointImplFromJson(
        Map<String, dynamic> json) =>
    _$HourlySalesPointImpl(
      hour: (json['hour'] as num).toInt(),
      sales: (json['sales'] as num).toDouble(),
    );

Map<String, dynamic> _$$HourlySalesPointImplToJson(
        _$HourlySalesPointImpl instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'sales': instance.sales,
    };
