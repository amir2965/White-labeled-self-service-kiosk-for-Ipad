import 'package:freezed_annotation/freezed_annotation.dart';

part 'kiosk_template.freezed.dart';
part 'kiosk_template.g.dart';

@freezed
class KioskTemplate with _$KioskTemplate {
  const factory KioskTemplate({
    required String id,
    required String name,
    required String description,
    String? thumbnailUrl,
    required TemplateStyle style,
    required LayoutConfig layoutConfig,
    @Default(false) bool isCustom,
  }) = _KioskTemplate;

  factory KioskTemplate.fromJson(Map<String, dynamic> json) =>
      _$KioskTemplateFromJson(json);
}

enum TemplateStyle {
  minimalGrid,
  bigTiles,
  listWithHero,
  coffeeMenu,
  restaurantMenu,
}

@freezed
class LayoutConfig with _$LayoutConfig {
  const factory LayoutConfig({
    // Hero section
    @Default(false) bool showHeroSection,
    String? heroImageUrl,
    String? heroTitle,

    // Category display
    @Default(CategoryStyle.tabs) CategoryStyle categoryStyle,

    // Product card style
    @Default(ProductCardStyle.imageHeavy) ProductCardStyle productCardStyle,

    // Typography
    @Default(FontScale.normal) FontScale fontScale,

    // Button style
    @Default(ButtonStyle.filled) ButtonStyle buttonStyle,

    // Colors
    @Default(AppThemeMode.light) AppThemeMode themeMode,
    String? primaryColor,
    String? accentColor,
  }) = _LayoutConfig;

  factory LayoutConfig.fromJson(Map<String, dynamic> json) =>
      _$LayoutConfigFromJson(json);
}

enum CategoryStyle { tabs, grid, list }

enum ProductCardStyle { compact, imageHeavy, listView }

enum FontScale { normal, large, extraLarge }

enum ButtonStyle { filled, outline, text }

enum AppThemeMode { light, dark }
