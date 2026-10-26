import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/branding_settings.dart';
import '../models/welcome_template_config.dart';

/// Provider for branding settings
final brandingSettingsProvider =
    StateNotifierProvider<BrandingSettingsNotifier, BrandingSettings>((ref) {
      return BrandingSettingsNotifier();
    });

class BrandingSettingsNotifier extends StateNotifier<BrandingSettings> {
  BrandingSettingsNotifier([BrandingSettings initial = const BrandingSettings()])
    : super(initial);

  void updateTemplate(WelcomePageTemplate template) {
    state = state.copyWith(welcomeTemplate: template);
  }

  void updateBusinessName(String name) {
    state = state.copyWith(businessName: name);
  }

  void updateTagline(String? tagline) {
    state = state.copyWith(tagline: tagline);
  }

  void updateLogoUrl(String? url) {
    state = state.copyWith(logoUrl: url);
  }

  void updateBackgroundImageUrl(String? url) {
    state = state.copyWith(backgroundImageUrl: url);
  }

  void updatePrimaryColor(Color? color) {
    state = state.copyWith(primaryColor: color);
  }

  void updateSecondaryColor(Color? color) {
    state = state.copyWith(secondaryColor: color);
  }

  void toggleLogo() {
    state = state.copyWith(showLogo: !state.showLogo);
  }

  void toggleBusinessName() {
    state = state.copyWith(showBusinessName: !state.showBusinessName);
  }

  void toggleTagline() {
    state = state.copyWith(showTagline: !state.showTagline);
  }

  void updateLogoSize(double size) {
    state = state.copyWith(logoSize: size);
  }

  void updateButtonText(String text) {
    state = state.copyWith(buttonText: text);
  }

  void updateWelcomeMessage(String? message) {
    state = state.copyWith(welcomeMessage: message);
  }

  void updateCustomFont(String? fontFamily) {
    state = state.copyWith(customFont: fontFamily);
  }

  // Button Customization Methods
  void updateButtonColor(Color? color) {
    state = state.copyWith(buttonColor: color);
  }

  void updateButtonTextColor(Color? color) {
    state = state.copyWith(buttonTextColor: color);
  }

  void toggleButtonStroke() {
    state = state.copyWith(buttonHasStroke: !state.buttonHasStroke);
  }

  void updateButtonStrokeColor(Color? color) {
    state = state.copyWith(buttonStrokeColor: color);
  }

  void updateButtonStrokeWidth(double width) {
    state = state.copyWith(buttonStrokeWidth: width);
  }

  void toggleButtonGlow() {
    state = state.copyWith(buttonHasOuterGlow: !state.buttonHasOuterGlow);
  }

  void updateButtonGlowColor(Color? color) {
    state = state.copyWith(buttonGlowColor: color);
  }

  void updateButtonGlowRadius(double radius) {
    state = state.copyWith(buttonGlowRadius: radius);
  }

  void toggleButtonShadow() {
    state = state.copyWith(buttonHasShadow: !state.buttonHasShadow);
  }

  void updateButtonShadowColor(Color? color) {
    state = state.copyWith(buttonShadowColor: color);
  }

  void updateButtonShadowBlur(double blur) {
    state = state.copyWith(buttonShadowBlur: blur);
  }

  void updateButtonShadowOffsetX(double offset) {
    state = state.copyWith(buttonShadowOffsetX: offset);
  }

  void updateButtonShadowOffsetY(double offset) {
    state = state.copyWith(buttonShadowOffsetY: offset);
  }

  void toggleButtonShadowInner() {
    state = state.copyWith(buttonShadowInner: !state.buttonShadowInner);
  }

  void updateButtonWidth(double width) {
    state = state.copyWith(buttonWidth: width);
  }

  void updateButtonHeight(double height) {
    state = state.copyWith(buttonHeight: height);
  }

  void updateButtonBorderRadius(double radius) {
    state = state.copyWith(buttonBorderRadius: radius);
  }

  void updateButtonTextSize(double size) {
    state = state.copyWith(buttonTextSize: size);
  }

  // Logo Customization Methods
  void updateLogoScale(double scale) {
    state = state.copyWith(logoScale: scale);
  }

  void updateLogoFit(BoxFit fit) {
    state = state.copyWith(logoFit: fit);
  }

  // Background Image Methods
  void updateBackgroundImageFit(BoxFit fit) {
    state = state.copyWith(backgroundImageFit: fit);
  }

  // Tagline Customization Methods
  void updateTaglineFontSize(double size) {
    state = state.copyWith(taglineFontSize: size);
  }

  void updateTaglineColor(Color? color) {
    state = state.copyWith(taglineColor: color);
  }

  void updateTaglineFontWeight(FontWeight weight) {
    state = state.copyWith(taglineFontWeight: weight);
  }

  void updateTaglineLetterSpacing(double spacing) {
    state = state.copyWith(taglineLetterSpacing: spacing);
  }

  void resetToDefaults() {
    state = const BrandingSettings();
  }
}
