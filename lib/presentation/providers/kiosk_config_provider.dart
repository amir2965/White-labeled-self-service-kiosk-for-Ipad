import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Template style options
enum TemplateStyle {
  minimalGrid,
  bigTiles,
  listHero,
  coffeeMenu,
  restaurantMenu,
}

enum CategoryStyle { tabs, grid }

enum ProductCardStyle { compact, imageHeavy }

enum FontScale { normal, large }

enum ButtonStyle { filled, outline }

/// Kiosk configuration state
class KioskConfig {
  final TemplateStyle templateStyle;
  final bool showHero;
  final CategoryStyle categoryStyle;
  final ProductCardStyle productCardStyle;
  final FontScale fontScale;
  final ButtonStyle buttonStyle;
  final bool isDarkMode;
  final int autoResetSeconds;
  final bool isFullscreen;

  KioskConfig({
    this.templateStyle = TemplateStyle.minimalGrid,
    this.showHero = false,
    this.categoryStyle = CategoryStyle.tabs,
    this.productCardStyle = ProductCardStyle.imageHeavy,
    this.fontScale = FontScale.normal,
    this.buttonStyle = ButtonStyle.filled,
    this.isDarkMode = false,
    this.autoResetSeconds = 30,
    this.isFullscreen = false,
  });

  KioskConfig copyWith({
    TemplateStyle? templateStyle,
    bool? showHero,
    CategoryStyle? categoryStyle,
    ProductCardStyle? productCardStyle,
    FontScale? fontScale,
    ButtonStyle? buttonStyle,
    bool? isDarkMode,
    int? autoResetSeconds,
    bool? isFullscreen,
  }) {
    return KioskConfig(
      templateStyle: templateStyle ?? this.templateStyle,
      showHero: showHero ?? this.showHero,
      categoryStyle: categoryStyle ?? this.categoryStyle,
      productCardStyle: productCardStyle ?? this.productCardStyle,
      fontScale: fontScale ?? this.fontScale,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      autoResetSeconds: autoResetSeconds ?? this.autoResetSeconds,
      isFullscreen: isFullscreen ?? this.isFullscreen,
    );
  }

  /// Template presets
  static KioskConfig getPreset(TemplateStyle style) {
    switch (style) {
      case TemplateStyle.minimalGrid:
        return KioskConfig(
          templateStyle: style,
          showHero: false,
          categoryStyle: CategoryStyle.tabs,
          productCardStyle: ProductCardStyle.compact,
          fontScale: FontScale.normal,
          buttonStyle: ButtonStyle.outline,
        );
      case TemplateStyle.bigTiles:
        return KioskConfig(
          templateStyle: style,
          showHero: true,
          categoryStyle: CategoryStyle.grid,
          productCardStyle: ProductCardStyle.imageHeavy,
          fontScale: FontScale.large,
          buttonStyle: ButtonStyle.filled,
        );
      case TemplateStyle.listHero:
        return KioskConfig(
          templateStyle: style,
          showHero: true,
          categoryStyle: CategoryStyle.tabs,
          productCardStyle: ProductCardStyle.compact,
          fontScale: FontScale.normal,
          buttonStyle: ButtonStyle.filled,
        );
      case TemplateStyle.coffeeMenu:
        return KioskConfig(
          templateStyle: style,
          showHero: false,
          categoryStyle: CategoryStyle.tabs,
          productCardStyle: ProductCardStyle.imageHeavy,
          fontScale: FontScale.normal,
          buttonStyle: ButtonStyle.filled,
        );
      case TemplateStyle.restaurantMenu:
        return KioskConfig(
          templateStyle: style,
          showHero: true,
          categoryStyle: CategoryStyle.grid,
          productCardStyle: ProductCardStyle.imageHeavy,
          fontScale: FontScale.large,
          buttonStyle: ButtonStyle.filled,
        );
    }
  }
}

/// Kiosk config notifier
class KioskConfigNotifier extends StateNotifier<KioskConfig> {
  KioskConfigNotifier() : super(KioskConfig());

  void applyTemplate(TemplateStyle style) {
    state = KioskConfig.getPreset(style);
  }

  void updateConfig({
    TemplateStyle? templateStyle,
    bool? showHero,
    CategoryStyle? categoryStyle,
    ProductCardStyle? productCardStyle,
    FontScale? fontScale,
    ButtonStyle? buttonStyle,
    bool? isDarkMode,
    int? autoResetSeconds,
    bool? isFullscreen,
  }) {
    state = state.copyWith(
      templateStyle: templateStyle,
      showHero: showHero,
      categoryStyle: categoryStyle,
      productCardStyle: productCardStyle,
      fontScale: fontScale,
      buttonStyle: buttonStyle,
      isDarkMode: isDarkMode,
      autoResetSeconds: autoResetSeconds,
      isFullscreen: isFullscreen,
    );
  }

  void toggleHero() => state = state.copyWith(showHero: !state.showHero);
  void toggleDarkMode() =>
      state = state.copyWith(isDarkMode: !state.isDarkMode);
  void toggleFullscreen() =>
      state = state.copyWith(isFullscreen: !state.isFullscreen);
}

/// Kiosk config provider
final kioskConfigProvider =
    StateNotifierProvider<KioskConfigNotifier, KioskConfig>((ref) {
      return KioskConfigNotifier();
    });
