// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeeSummaryImpl _$$FeeSummaryImplFromJson(Map<String, dynamic> json) =>
    _$FeeSummaryImpl(
      totalServiceFees: (json['totalServiceFees'] as num).toDouble(),
      averageFeePercent: (json['averageFeePercent'] as num).toDouble(),
      effectiveFeeRate: (json['effectiveFeeRate'] as num).toDouble(),
      grossSales: (json['grossSales'] as num).toDouble(),
      netBeforeGst: (json['netBeforeGst'] as num).toDouble(),
    );

Map<String, dynamic> _$$FeeSummaryImplToJson(_$FeeSummaryImpl instance) =>
    <String, dynamic>{
      'totalServiceFees': instance.totalServiceFees,
      'averageFeePercent': instance.averageFeePercent,
      'effectiveFeeRate': instance.effectiveFeeRate,
      'grossSales': instance.grossSales,
      'netBeforeGst': instance.netBeforeGst,
    };

_$FeeBreakdownImpl _$$FeeBreakdownImplFromJson(Map<String, dynamic> json) =>
    _$FeeBreakdownImpl(
      grossSales: (json['grossSales'] as num).toDouble(),
      platformFee: (json['platformFee'] as num).toDouble(),
      feePercent: (json['feePercent'] as num).toDouble(),
      netBeforeGst: (json['netBeforeGst'] as num).toDouble(),
    );

Map<String, dynamic> _$$FeeBreakdownImplToJson(_$FeeBreakdownImpl instance) =>
    <String, dynamic>{
      'grossSales': instance.grossSales,
      'platformFee': instance.platformFee,
      'feePercent': instance.feePercent,
      'netBeforeGst': instance.netBeforeGst,
    };

_$FeeTransactionImpl _$$FeeTransactionImplFromJson(Map<String, dynamic> json) =>
    _$FeeTransactionImpl(
      date: DateTime.parse(json['date'] as String),
      orderId: json['orderId'] as String,
      grossAmount: (json['grossAmount'] as num).toDouble(),
      serviceFee: (json['serviceFee'] as num).toDouble(),
      feePercent: (json['feePercent'] as num).toDouble(),
    );

Map<String, dynamic> _$$FeeTransactionImplToJson(
        _$FeeTransactionImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'orderId': instance.orderId,
      'grossAmount': instance.grossAmount,
      'serviceFee': instance.serviceFee,
      'feePercent': instance.feePercent,
    };

_$ServiceFeesDataImpl _$$ServiceFeesDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceFeesDataImpl(
      summary: FeeSummary.fromJson(json['summary'] as Map<String, dynamic>),
      breakdown:
          FeeBreakdown.fromJson(json['breakdown'] as Map<String, dynamic>),
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => FeeTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ServiceFeesDataImplToJson(
        _$ServiceFeesDataImpl instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'breakdown': instance.breakdown,
      'transactions': instance.transactions,
    };
