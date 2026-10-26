// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalesEventImpl _$$SalesEventImplFromJson(Map<String, dynamic> json) =>
    _$SalesEventImpl(
      id: json['id'] as String,
      timestampUTC: DateTime.parse(json['timestampUTC'] as String),
      amountGross: (json['amountGross'] as num).toDouble(),
      amountNet: (json['amountNet'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      status: $enumDecode(_$SalesEventStatusEnumMap, json['status']),
      deviceId: json['deviceId'] as String?,
      venueId: json['venueId'] as String?,
      orderId: json['orderId'] as String?,
    );

Map<String, dynamic> _$$SalesEventImplToJson(_$SalesEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestampUTC': instance.timestampUTC.toIso8601String(),
      'amountGross': instance.amountGross,
      'amountNet': instance.amountNet,
      'tax': instance.tax,
      'paymentMethod': instance.paymentMethod,
      'status': _$SalesEventStatusEnumMap[instance.status]!,
      'deviceId': instance.deviceId,
      'venueId': instance.venueId,
      'orderId': instance.orderId,
    };

const _$SalesEventStatusEnumMap = {
  SalesEventStatus.paid: 'paid',
  SalesEventStatus.refunded: 'refunded',
  SalesEventStatus.voided: 'voided',
  SalesEventStatus.pending: 'pending',
};

_$ChartPointImpl _$$ChartPointImplFromJson(Map<String, dynamic> json) =>
    _$ChartPointImpl(
      x: DateTime.parse(json['x'] as String),
      grossSales: (json['grossSales'] as num).toDouble(),
      paymentsCount: (json['paymentsCount'] as num).toInt(),
      netSales: (json['netSales'] as num?)?.toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      label: json['label'] as String?,
    );

Map<String, dynamic> _$$ChartPointImplToJson(_$ChartPointImpl instance) =>
    <String, dynamic>{
      'x': instance.x.toIso8601String(),
      'grossSales': instance.grossSales,
      'paymentsCount': instance.paymentsCount,
      'netSales': instance.netSales,
      'tax': instance.tax,
      'label': instance.label,
    };

_$SalesSummaryChartsDataImpl _$$SalesSummaryChartsDataImplFromJson(
        Map<String, dynamic> json) =>
    _$SalesSummaryChartsDataImpl(
      timeOfDaySelectedSeries:
          (json['timeOfDaySelectedSeries'] as List<dynamic>)
              .map((e) => ChartPoint.fromJson(e as Map<String, dynamic>))
              .toList(),
      timeOfDayCompareSeries: (json['timeOfDayCompareSeries'] as List<dynamic>)
          .map((e) => ChartPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      periodTrendSeries: (json['periodTrendSeries'] as List<dynamic>)
          .map((e) => ChartPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      periodTrendCompareSeries:
          (json['periodTrendCompareSeries'] as List<dynamic>?)
              ?.map((e) => ChartPoint.fromJson(e as Map<String, dynamic>))
              .toList(),
      dayOfWeekTotals: (json['dayOfWeekTotals'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
      ),
      dayOfWeekPayments:
          (json['dayOfWeekPayments'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), (e as num).toInt()),
      ),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
      selectedStartDate: DateTime.parse(json['selectedStartDate'] as String),
      selectedEndDate: DateTime.parse(json['selectedEndDate'] as String),
      compareStartDate: json['compareStartDate'] == null
          ? null
          : DateTime.parse(json['compareStartDate'] as String),
      compareEndDate: json['compareEndDate'] == null
          ? null
          : DateTime.parse(json['compareEndDate'] as String),
      totalGrossSales: (json['totalGrossSales'] as num).toDouble(),
      totalPayments: (json['totalPayments'] as num).toInt(),
      compareTotalGrossSales:
          (json['compareTotalGrossSales'] as num?)?.toDouble(),
      compareTotalPayments: (json['compareTotalPayments'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SalesSummaryChartsDataImplToJson(
        _$SalesSummaryChartsDataImpl instance) =>
    <String, dynamic>{
      'timeOfDaySelectedSeries': instance.timeOfDaySelectedSeries,
      'timeOfDayCompareSeries': instance.timeOfDayCompareSeries,
      'periodTrendSeries': instance.periodTrendSeries,
      'periodTrendCompareSeries': instance.periodTrendCompareSeries,
      'dayOfWeekTotals':
          instance.dayOfWeekTotals.map((k, e) => MapEntry(k.toString(), e)),
      'dayOfWeekPayments':
          instance.dayOfWeekPayments.map((k, e) => MapEntry(k.toString(), e)),
      'lastUpdatedAt': instance.lastUpdatedAt.toIso8601String(),
      'selectedStartDate': instance.selectedStartDate.toIso8601String(),
      'selectedEndDate': instance.selectedEndDate.toIso8601String(),
      'compareStartDate': instance.compareStartDate?.toIso8601String(),
      'compareEndDate': instance.compareEndDate?.toIso8601String(),
      'totalGrossSales': instance.totalGrossSales,
      'totalPayments': instance.totalPayments,
      'compareTotalGrossSales': instance.compareTotalGrossSales,
      'compareTotalPayments': instance.compareTotalPayments,
    };
