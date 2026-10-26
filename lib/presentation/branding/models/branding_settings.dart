import 'package:flutter/material.dart';
import 'welcome_template_config.dart';

/// Branding settings for kiosk welcome page
class BrandingSettings {
  final WelcomePageTemplate welcomeTemplate;
  final String businessName;
  final String? tagline;
  final String? logoUrl;
  final String? backgroundImageUrl;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? textColor;
  final String? customFont;
  final bool showLogo;
  final bool showBusinessName;
  final bool showTagline;
  final double logoSize;
  final String buttonText;
  final String? welcomeMessage;

  // Button Customization
  final Color? buttonColor;
  final Color? buttonTextColor;
  final bool buttonHasStroke;
  final Color? buttonStrokeColor;
  final double buttonStrokeWidth;
  final bool buttonHasOuterGlow;
  final Color? buttonGlowColor;
  final double buttonGlowRadius;
  final bool buttonHasShadow;
  final Color? buttonShadowColor;
  final double buttonShadowBlur;
  final double buttonShadowOffsetX;
  final double buttonShadowOffsetY;
  final bool buttonShadowInner;
  final double buttonWidth;
  final double buttonHeight;
  final double buttonBorderRadius;
  final double buttonTextSize;

  // Logo Customization
  final double logoScale; // 0.5 to 2.0
  final BoxFit logoFit; // cover, contain, fill, etc.

  // Background Image Customization
  final BoxFit backgroundImageFit; // cover, contain, fill, etc.

  // Tagline Customization
  final double taglineFontSize;
  final Color? taglineColor;
  final FontWeight taglineFontWeight;
  final double taglineLetterSpacing;

  const BrandingSettings({
    this.welcomeTemplate = WelcomePageTemplate.bigTypography,
    this.businessName = 'My Restaurant',
    this.tagline,
    this.logoUrl,
    this.backgroundImageUrl,
    this.primaryColor,
    this.secondaryColor,
    this.textColor,
    this.customFont,
    this.showLogo = true,
    this.showBusinessName = true,
    this.showTagline = true,
    this.logoSize = 140.0,
    this.buttonText = 'Start Order',
    this.welcomeMessage,
    // Button defaults
    this.buttonColor,
    this.buttonTextColor,
    this.buttonHasStroke = false,
    this.buttonStrokeColor,
    this.buttonStrokeWidth = 2.0,
    this.buttonHasOuterGlow = false,
    this.buttonGlowColor,
    this.buttonGlowRadius = 10.0,
    this.buttonHasShadow = false,
    this.buttonShadowColor,
    this.buttonShadowBlur = 10.0,
    this.buttonShadowOffsetX = 0.0,
    this.buttonShadowOffsetY = 4.0,
    this.buttonShadowInner = false,
    this.buttonWidth = 280.0,
    this.buttonHeight = 56.0,
    this.buttonBorderRadius = 12.0,
    this.buttonTextSize = 18.0,
    // Logo defaults
    this.logoScale = 1.0,
    this.logoFit = BoxFit.contain,
    // Background image defaults
    this.backgroundImageFit = BoxFit.cover,
    // Tagline defaults
    this.taglineFontSize = 18.0,
    this.taglineColor,
    this.taglineFontWeight = FontWeight.normal,
    this.taglineLetterSpacing = 0.0,
  });

  BrandingSettings copyWith({
    WelcomePageTemplate? welcomeTemplate,
    String? businessName,
    String? tagline,
    String? logoUrl,
    String? backgroundImageUrl,
    Color? primaryColor,
    Color? secondaryColor,
    Color? textColor,
    String? customFont,
    bool? showLogo,
    bool? showBusinessName,
    bool? showTagline,
    double? logoSize,
    String? buttonText,
    String? welcomeMessage,
    // Button settings
    Color? buttonColor,
    Color? buttonTextColor,
    bool? buttonHasStroke,
    Color? buttonStrokeColor,
    double? buttonStrokeWidth,
    bool? buttonHasOuterGlow,
    Color? buttonGlowColor,
    double? buttonGlowRadius,
    bool? buttonHasShadow,
    Color? buttonShadowColor,
    double? buttonShadowBlur,
    double? buttonShadowOffsetX,
    double? buttonShadowOffsetY,
    bool? buttonShadowInner,
    double? buttonWidth,
    double? buttonHeight,
    double? buttonBorderRadius,
    double? buttonTextSize,
    // Logo settings
    double? logoScale,
    BoxFit? logoFit,
    // Background image settings
    BoxFit? backgroundImageFit,
    // Tagline settings
    double? taglineFontSize,
    Color? taglineColor,
    FontWeight? taglineFontWeight,
    double? taglineLetterSpacing,
  }) {
    return BrandingSettings(
      welcomeTemplate: welcomeTemplate ?? this.welcomeTemplate,
      businessName: businessName ?? this.businessName,
      tagline: tagline ?? this.tagline,
      logoUrl: logoUrl ?? this.logoUrl,
      backgroundImageUrl: backgroundImageUrl ?? this.backgroundImageUrl,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      textColor: textColor ?? this.textColor,
      customFont: customFont ?? this.customFont,
      showLogo: showLogo ?? this.showLogo,
      showBusinessName: showBusinessName ?? this.showBusinessName,
      showTagline: showTagline ?? this.showTagline,
      logoSize: logoSize ?? this.logoSize,
      buttonText: buttonText ?? this.buttonText,
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      // Button settings
      buttonColor: buttonColor ?? this.buttonColor,
      buttonTextColor: buttonTextColor ?? this.buttonTextColor,
      buttonHasStroke: buttonHasStroke ?? this.buttonHasStroke,
      buttonStrokeColor: buttonStrokeColor ?? this.buttonStrokeColor,
      buttonStrokeWidth: buttonStrokeWidth ?? this.buttonStrokeWidth,
      buttonHasOuterGlow: buttonHasOuterGlow ?? this.buttonHasOuterGlow,
      buttonGlowColor: buttonGlowColor ?? this.buttonGlowColor,
      buttonGlowRadius: buttonGlowRadius ?? this.buttonGlowRadius,
      buttonHasShadow: buttonHasShadow ?? this.buttonHasShadow,
      buttonShadowColor: buttonShadowColor ?? this.buttonShadowColor,
      buttonShadowBlur: buttonShadowBlur ?? this.buttonShadowBlur,
      buttonShadowOffsetX: buttonShadowOffsetX ?? this.buttonShadowOffsetX,
      buttonShadowOffsetY: buttonShadowOffsetY ?? this.buttonShadowOffsetY,
      buttonShadowInner: buttonShadowInner ?? this.buttonShadowInner,
      buttonWidth: buttonWidth ?? this.buttonWidth,
      buttonHeight: buttonHeight ?? this.buttonHeight,
      buttonBorderRadius: buttonBorderRadius ?? this.buttonBorderRadius,
      buttonTextSize: buttonTextSize ?? this.buttonTextSize,
      // Logo settings
      logoScale: logoScale ?? this.logoScale,
      logoFit: logoFit ?? this.logoFit,
      // Background image settings
      backgroundImageFit: backgroundImageFit ?? this.backgroundImageFit,
      // Tagline settings
      taglineFontSize: taglineFontSize ?? this.taglineFontSize,
      taglineColor: taglineColor ?? this.taglineColor,
      taglineFontWeight: taglineFontWeight ?? this.taglineFontWeight,
      taglineLetterSpacing: taglineLetterSpacing ?? this.taglineLetterSpacing,
    );
  }
}
