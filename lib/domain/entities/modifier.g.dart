// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ModifierGroupImpl _$$ModifierGroupImplFromJson(Map<String, dynamic> json) =>
    _$ModifierGroupImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      isRequired: json['isRequired'] as bool,
      minSelection: (json['minSelection'] as num?)?.toInt() ?? 1,
      maxSelection: (json['maxSelection'] as num?)?.toInt() ?? 1,
      modifiers: (json['modifiers'] as List<dynamic>)
          .map((e) => Modifier.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ModifierGroupImplToJson(_$ModifierGroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isRequired': instance.isRequired,
      'minSelection': instance.minSelection,
      'maxSelection': instance.maxSelection,
      'modifiers': instance.modifiers,
    };

_$ModifierImpl _$$ModifierImplFromJson(Map<String, dynamic> json) =>
    _$ModifierImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      priceAdjustment: (json['priceAdjustment'] as num?)?.toDouble() ?? 0.0,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );

Map<String, dynamic> _$$ModifierImplToJson(_$ModifierImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'priceAdjustment': instance.priceAdjustment,
      'isAvailable': instance.isAvailable,
    };
