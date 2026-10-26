// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kiosk_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KioskTemplateImpl _$$KioskTemplateImplFromJson(Map<String, dynamic> json) =>
    _$KioskTemplateImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      style: $enumDecode(_$TemplateStyleEnumMap, json['style']),
      layoutConfig:
          LayoutConfig.fromJson(json['layoutConfig'] as Map<String, dynamic>),
      isCustom: json['isCustom'] as bool? ?? false,
    );

Map<String, dynamic> _$$KioskTemplateImplToJson(_$KioskTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'thumbnailUrl': instance.thumbnailUrl,
      'style': _$TemplateStyleEnumMap[instance.style]!,
      'layoutConfig': instance.layoutConfig,
      'isCustom': instance.isCustom,
    };

const _$TemplateStyleEnumMap = {
  TemplateStyle.minimalGrid: 'minimalGrid',
  TemplateStyle.bigTiles: 'bigTiles',
  TemplateStyle.listWithHero: 'listWithHero',
  TemplateStyle.coffeeMenu: 'coffeeMenu',
  TemplateStyle.restaurantMenu: 'restaurantMenu',
};

_$LayoutConfigImpl _$$LayoutConfigImplFromJson(Map<String, dynamic> json) =>
    _$LayoutConfigImpl(
      showHeroSection: json['showHeroSection'] as bool? ?? false,
      heroImageUrl: json['heroImageUrl'] as String?,
      heroTitle: json['heroTitle'] as String?,
      categoryStyle:
          $enumDecodeNullable(_$CategoryStyleEnumMap, json['categoryStyle']) ??
              CategoryStyle.tabs,
      productCardStyle: $enumDecodeNullable(
              _$ProductCardStyleEnumMap, json['productCardStyle']) ??
          ProductCardStyle.imageHeavy,
      fontScale: $enumDecodeNullable(_$FontScaleEnumMap, json['fontScale']) ??
          FontScale.normal,
      buttonStyle:
          $enumDecodeNullable(_$ButtonStyleEnumMap, json['buttonStyle']) ??
              ButtonStyle.filled,
      themeMode:
          $enumDecodeNullable(_$AppThemeModeEnumMap, json['themeMode']) ??
              AppThemeMode.light,
      primaryColor: json['primaryColor'] as String?,
      accentColor: json['accentColor'] as String?,
    );

Map<String, dynamic> _$$LayoutConfigImplToJson(_$LayoutConfigImpl instance) =>
    <String, dynamic>{
      'showHeroSection': instance.showHeroSection,
      'heroImageUrl': instance.heroImageUrl,
      'heroTitle': instance.heroTitle,
      'categoryStyle': _$CategoryStyleEnumMap[instance.categoryStyle]!,
      'productCardStyle': _$ProductCardStyleEnumMap[instance.productCardStyle]!,
      'fontScale': _$FontScaleEnumMap[instance.fontScale]!,
      'buttonStyle': _$ButtonStyleEnumMap[instance.buttonStyle]!,
      'themeMode': _$AppThemeModeEnumMap[instance.themeMode]!,
      'primaryColor': instance.primaryColor,
      'accentColor': instance.accentColor,
    };

const _$CategoryStyleEnumMap = {
  CategoryStyle.tabs: 'tabs',
  CategoryStyle.grid: 'grid',
  CategoryStyle.list: 'list',
};

const _$ProductCardStyleEnumMap = {
  ProductCardStyle.compact: 'compact',
  ProductCardStyle.imageHeavy: 'imageHeavy',
  ProductCardStyle.listView: 'listView',
};

const _$FontScaleEnumMap = {
  FontScale.normal: 'normal',
  FontScale.large: 'large',
  FontScale.extraLarge: 'extraLarge',
};

const _$ButtonStyleEnumMap = {
  ButtonStyle.filled: 'filled',
  ButtonStyle.outline: 'outline',
  ButtonStyle.text: 'text',
};

const _$AppThemeModeEnumMap = {
  AppThemeMode.light: 'light',
  AppThemeMode.dark: 'dark',
};
