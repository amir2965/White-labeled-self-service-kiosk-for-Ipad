// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reporting_timeframe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportingTimeframeImpl _$$ReportingTimeframeImplFromJson(
        Map<String, dynamic> json) =>
    _$ReportingTimeframeImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      timezone: json['timezone'] as String,
      startLocalTime: json['startLocalTime'] as String,
      endLocalTime: json['endLocalTime'] as String,
    );

Map<String, dynamic> _$$ReportingTimeframeImplToJson(
        _$ReportingTimeframeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'timezone': instance.timezone,
      'startLocalTime': instance.startLocalTime,
      'endLocalTime': instance.endLocalTime,
    };

_$ReportingTimeframeSelectionImpl _$$ReportingTimeframeSelectionImplFromJson(
        Map<String, dynamic> json) =>
    _$ReportingTimeframeSelectionImpl(
      type: $enumDecode(_$ReportingTimeframeTypeEnumMap, json['type']),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      timezone: json['timezone'] as String,
      presetId: json['presetId'] as String?,
      presetName: json['presetName'] as String?,
    );

Map<String, dynamic> _$$ReportingTimeframeSelectionImplToJson(
        _$ReportingTimeframeSelectionImpl instance) =>
    <String, dynamic>{
      'type': _$ReportingTimeframeTypeEnumMap[instance.type]!,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'timezone': instance.timezone,
      'presetId': instance.presetId,
      'presetName': instance.presetName,
    };

const _$ReportingTimeframeTypeEnumMap = {
  ReportingTimeframeType.defaultDay: 'defaultDay',
  ReportingTimeframeType.custom: 'custom',
  ReportingTimeframeType.savedPreset: 'savedPreset',
};
