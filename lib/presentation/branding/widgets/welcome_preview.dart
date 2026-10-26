import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/branding_settings.dart';
import '../models/welcome_template_config.dart';
import '../../../core/constants/app_colors.dart';

/// Preview widget that renders the kiosk welcome page with applied branding settings
class WelcomePreview extends StatelessWidget {
  final BrandingSettings settings;

  const WelcomePreview({Key? key, required this.settings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final metadata = WelcomeTemplateConfig.getMetadata(
      settings.welcomeTemplate,
    );

    // Get effective colors
    final primaryColor =
        settings.primaryColor ?? metadata?.primaryColor ?? AppColors.blue;
    final secondaryColor =
        settings.secondaryColor ?? metadata?.secondaryColor ?? AppColors.blue;
    final textColor = settings.textColor ?? Colors.black87;

    // For templates with separate image sections or logo-focused templates,
    // don't use background image in main container
    final template = settings.welcomeTemplate;
    final useBackgroundImage =
        template != WelcomePageTemplate.splitScreenImage &&
        template != WelcomePageTemplate.topImageBanner &&
        template != WelcomePageTemplate.bottomImageBanner &&
        // Logo-Prominent templates should not show background images
        template != WelcomePageTemplate.largeLogo &&
        template != WelcomePageTemplate.logoWithTagline &&
        template != WelcomePageTemplate.circularLogo &&
        // Typography-focused and subtle templates should not show background
        template != WelcomePageTemplate.subtleColor &&
        template != WelcomePageTemplate.bigTypography &&
        template != WelcomePageTemplate.minimalistText;

    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(metadata, primaryColor, secondaryColor),
        image: useBackgroundImage && settings.backgroundImageUrl != null
            ? DecorationImage(
                image: NetworkImage(settings.backgroundImageUrl!),
                fit: settings.backgroundImageFit,
              )
            : null,
      ),
      child: _buildTemplateLayout(
        context,
        metadata,
        primaryColor,
        secondaryColor,
        textColor,
      ),
    );
  }

  Color _getBackgroundColor(
    WelcomeTemplateMetadata? metadata,
    Color primaryColor,
    Color secondaryColor,
  ) {
    switch (settings.welcomeTemplate) {
      case WelcomePageTemplate.gradientBackground:
        return primaryColor;
      case WelcomePageTemplate.subtleColor:
        return primaryColor.withOpacity(0.1);
      default:
        return Colors.white;
    }
  }

  Widget _buildTemplateLayout(
    BuildContext context,
    WelcomeTemplateMetadata? metadata,
    Color primaryColor,
    Color secondaryColor,
    Color textColor,
  ) {
    final template = settings.welcomeTemplate;

    // Split screen image templates
    if (template == WelcomePageTemplate.splitScreenImage) {
      return Row(
        children: [
          Expanded(child: _buildImageSection()),
          Expanded(
            child: _buildContentSection(
              primaryColor,
              secondaryColor,
              textColor,
            ),
          ),
        ],
      );
    }

    // Top image banner template
    if (template == WelcomePageTemplate.topImageBanner) {
      return Column(
        children: [
          Expanded(flex: 2, child: _buildImageSection()),
          Expanded(
            flex: 3,
            child: _buildContentSection(
              primaryColor,
              secondaryColor,
              textColor,
            ),
          ),
        ],
      );
    }

    // Bottom image banner template
    if (template == WelcomePageTemplate.bottomImageBanner) {
      return Column(
        children: [
          Expanded(
            flex: 3,
            child: _buildContentSection(
              primaryColor,
              secondaryColor,
              textColor,
            ),
          ),
          Expanded(flex: 2, child: _buildImageSection()),
        ],
      );
    }

    // Full screen image with overlay
    if (template == WelcomePageTemplate.fullScreenImage) {
      return Stack(
        children: [
          if (settings.backgroundImageUrl != null)
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          Center(
            child: _buildContentSection(
              Colors.white,
              Colors.white70,
              Colors.white,
            ),
          ),
        ],
      );
    }

    // Gradient background templates
    if (template == WelcomePageTemplate.gradientBackground) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, secondaryColor],
          ),
        ),
        child: Center(
          child: _buildContentSection(
            Colors.white,
            Colors.white70,
            Colors.white,
          ),
        ),
      );
    }

    // Default: centered content
    return Center(
      child: _buildContentSection(primaryColor, secondaryColor, textColor),
    );
  }

  Widget _buildImageSection() {
    if (settings.backgroundImageUrl != null) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(settings.backgroundImageUrl!),
            fit: settings.backgroundImageFit,
          ),
        ),
      );
    }

    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(Icons.image, size: 80, color: Colors.grey[400]),
      ),
    );
  }

  Widget _buildContentSection(
    Color primaryColor,
    Color secondaryColor,
    Color textColor,
  ) {
    final template = settings.welcomeTemplate;
    final metadata = WelcomeTemplateConfig.getMetadata(template);

    // Large logo templates
    if (template == WelcomePageTemplate.largeLogo ||
        template == WelcomePageTemplate.circularLogo) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (settings.showLogo && settings.logoUrl != null)
            _buildLogo(
              template == WelcomePageTemplate.circularLogo,
              settings.logoSize * 1.5, // Larger for these templates
            ),
          const SizedBox(height: 24),
          if (settings.showBusinessName)
            _buildBusinessName(
              template == WelcomePageTemplate.bigTypography ? 56 : 32,
              textColor,
            ),
          if (settings.showTagline && settings.tagline != null) ...[
            const SizedBox(height: 8),
            _buildTagline(textColor.withOpacity(0.7)),
          ],
          const SizedBox(height: 16),
          _buildButton(primaryColor),
        ],
      );
    }

    // Big typography template
    if (template == WelcomePageTemplate.bigTypography) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (settings.showLogo && settings.logoUrl != null) ...[
            _buildLogo(false, settings.logoSize * 0.8),
            const SizedBox(height: 20),
          ],
          if (settings.showBusinessName) _buildBusinessName(64, textColor),
          if (settings.showTagline && settings.tagline != null) ...[
            const SizedBox(height: 12),
            _buildTagline(textColor.withOpacity(0.8), fontSize: 24),
          ],
          const SizedBox(height: 20),
          _buildButton(primaryColor, large: true),
        ],
      );
    }

    // Logo with tagline template
    if (template == WelcomePageTemplate.logoWithTagline) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (settings.showLogo && settings.logoUrl != null)
            _buildLogo(false, settings.logoSize * 1.2),
          const SizedBox(height: 16),
          if (settings.showTagline && settings.tagline != null)
            _buildTagline(textColor, fontSize: 20, bold: true),
          if (settings.showBusinessName) ...[
            const SizedBox(height: 8),
            _buildBusinessName(28, textColor.withOpacity(0.8)),
          ],
          const SizedBox(height: 16),
          _buildButton(primaryColor),
        ],
      );
    }

    // Default: classic centered layout
    return Padding(
      padding: const EdgeInsets.all(48.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Don't show logo for image-focused banner templates
          if (settings.showLogo &&
              settings.logoUrl != null &&
              template != WelcomePageTemplate.topImageBanner &&
              template != WelcomePageTemplate.bottomImageBanner) ...[
            _buildLogo(false, settings.logoSize),
            const SizedBox(height: 20),
          ],
          if (settings.showBusinessName) _buildBusinessName(36, textColor),
          if (settings.showTagline && settings.tagline != null) ...[
            const SizedBox(height: 8),
            _buildTagline(textColor.withOpacity(0.7)),
          ],
          const SizedBox(height: 16),
          _buildButton(primaryColor),
        ],
      ),
    );
  }

  Widget _buildLogo(bool circular, double size) {
    // Apply logo scale
    final scaledSize = size * settings.logoScale;

    final logoWidget = settings.logoUrl != null
        ? Image.network(
            settings.logoUrl!,
            width: scaledSize,
            height: scaledSize,
            fit: settings.logoFit,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.business,
                size: scaledSize * 0.6,
                color: Colors.grey[400],
              );
            },
          )
        : Icon(Icons.business, size: scaledSize * 0.6, color: Colors.grey[400]);

    if (circular) {
      return Container(
        width: scaledSize,
        height: scaledSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(scaledSize * 0.2),
        child: logoWidget,
      );
    }

    return logoWidget;
  }

  Widget _buildBusinessName(double fontSize, Color color) {
    return Text(
      settings.businessName,
      style: settings.customFont != null
          ? GoogleFonts.getFont(
              settings.customFont!,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: -0.5,
            )
          : TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: -0.5,
            ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTagline(Color color, {double fontSize = 18, bool bold = false}) {
    if (settings.tagline == null) return const SizedBox.shrink();

    // Use custom tagline settings if available
    final taglineColor = settings.taglineColor ?? color;
    final taglineFontSize = settings.taglineFontSize;
    final taglineFontWeight = settings.taglineFontWeight;
    final taglineLetterSpacing = settings.taglineLetterSpacing;

    return Text(
      settings.tagline!,
      style: settings.customFont != null
          ? GoogleFonts.getFont(
              settings.customFont!,
              fontSize: taglineFontSize,
              fontWeight: taglineFontWeight,
              color: taglineColor,
              letterSpacing: taglineLetterSpacing,
            )
          : TextStyle(
              fontSize: taglineFontSize,
              fontWeight: taglineFontWeight,
              color: taglineColor,
              letterSpacing: taglineLetterSpacing,
            ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButton(Color color, {bool large = false}) {
    // Use custom button colors or fall back to defaults
    final buttonBgColor = settings.buttonColor ?? color;
    final buttonTextColor =
        settings.buttonTextColor ?? _getContrastingTextColor(buttonBgColor);

    // Build shadow list
    List<BoxShadow> shadows = [];

    // Add outer glow if enabled
    if (settings.buttonHasOuterGlow) {
      final glowColor = settings.buttonGlowColor ?? buttonBgColor;
      shadows.add(
        BoxShadow(
          color: glowColor.withOpacity(0.5),
          blurRadius: settings.buttonGlowRadius,
          spreadRadius: settings.buttonGlowRadius / 2,
        ),
      );
    }

    // Add shadow if enabled
    if (settings.buttonHasShadow) {
      final shadowColor = settings.buttonShadowColor ?? Colors.black;
      shadows.add(
        BoxShadow(
          color: shadowColor.withOpacity(0.3),
          blurRadius: settings.buttonShadowBlur,
          offset: Offset(
            settings.buttonShadowOffsetX,
            settings.buttonShadowOffsetY,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(settings.buttonBorderRadius),
        boxShadow: !settings.buttonShadowInner ? shadows : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: settings.buttonWidth,
          height: settings.buttonHeight,
          decoration: BoxDecoration(
            color: buttonBgColor,
            borderRadius: BorderRadius.circular(settings.buttonBorderRadius),
            border: settings.buttonHasStroke
                ? Border.all(
                    color: settings.buttonStrokeColor ?? Colors.white,
                    width: settings.buttonStrokeWidth,
                  )
                : null,
            boxShadow: settings.buttonShadowInner
                ? [
                    BoxShadow(
                      color: (settings.buttonShadowColor ?? Colors.black)
                          .withOpacity(0.3),
                      blurRadius: settings.buttonShadowBlur,
                      offset: Offset(
                        settings.buttonShadowOffsetX,
                        settings.buttonShadowOffsetY,
                      ),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(settings.buttonBorderRadius),
              child: Center(
                child: Text(
                  settings.buttonText,
                  style: settings.customFont != null
                      ? GoogleFonts.getFont(
                          settings.customFont!,
                          fontSize: settings.buttonTextSize,
                          fontWeight: FontWeight.w600,
                          color: buttonTextColor,
                        )
                      : TextStyle(
                          fontSize: settings.buttonTextSize,
                          fontWeight: FontWeight.w600,
                          color: buttonTextColor,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Calculate contrasting text color based on background brightness
  Color _getContrastingTextColor(Color backgroundColor) {
    // Calculate luminance
    final luminance = backgroundColor.computeLuminance();
    // If background is light, use dark text; if dark, use light text
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}
