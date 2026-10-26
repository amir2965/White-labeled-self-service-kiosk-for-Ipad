import 'package:flutter/material.dart';

/// Welcome page template styles for kiosk
enum WelcomePageTemplate {
  // Image-Focused
  fullScreenImage, // #1 - Background image with overlay
  splitScreenImage, // #5 - Image left, content right
  topImageBanner, // #6 - Large image header, content below
  bottomImageBanner, // #7 - Content top, image showcase bottom
  // Logo-Prominent
  largeLogo, // #8 - Oversized logo, minimal text
  logoWithTagline, // #9 - Medium logo with prominent tagline
  circularLogo, // #10 - Circular logo with gradient background
  // Colorful & Branded
  gradientBackground, // #11 - Smooth gradient with brand colors
  subtleColor, // #12 - Soft pastel tones
  // Typography-Focused
  bigTypography, // #13 - Large, bold welcome text
  minimalistText, // #14 - Ultra-clean text-only
}

class WelcomeTemplateMetadata {
  final String name;
  final String description;
  final String category;
  final bool requiresImage;
  final bool supportsBranding;
  final List<String> recommendedFor;
  final Color? primaryColor;
  final Color? secondaryColor;
  final bool supportsLogo;
  final String layoutType;

  const WelcomeTemplateMetadata({
    required this.name,
    required this.description,
    required this.category,
    required this.requiresImage,
    required this.supportsBranding,
    required this.recommendedFor,
    this.primaryColor,
    this.secondaryColor,
    required this.supportsLogo,
    required this.layoutType,
  });
}

/// Template metadata definitions
class WelcomeTemplateConfig {
  static const Map<WelcomePageTemplate, WelcomeTemplateMetadata> templates = {
    // IMAGE-FOCUSED
    WelcomePageTemplate.fullScreenImage: WelcomeTemplateMetadata(
      name: 'Full Screen Image',
      description: 'Immersive background with overlay text',
      category: 'Image-Focused',
      requiresImage: true,
      supportsBranding: true,
      supportsLogo: true,
      layoutType: 'Full Screen',
      recommendedFor: ['Restaurants', 'Cafes', 'Bars'],
      primaryColor: Colors.black54,
    ),

    WelcomePageTemplate.splitScreenImage: WelcomeTemplateMetadata(
      name: 'Split Screen',
      description: 'Image and content side by side',
      category: 'Image-Focused',
      requiresImage: true,
      supportsBranding: true,
      supportsLogo: true,
      layoutType: 'Split',
      recommendedFor: ['Upscale Restaurants', 'Specialty Cafes'],
    ),

    WelcomePageTemplate.topImageBanner: WelcomeTemplateMetadata(
      name: 'Top Image Banner',
      description: 'Large header image with content below',
      category: 'Image-Focused',
      requiresImage: true,
      supportsBranding: true,
      supportsLogo: true,
      layoutType: 'Top Banner',
      recommendedFor: ['All Restaurant Types'],
    ),

    WelcomePageTemplate.bottomImageBanner: WelcomeTemplateMetadata(
      name: 'Bottom Image Showcase',
      description: 'Content first, image showcase below',
      category: 'Image-Focused',
      requiresImage: true,
      supportsBranding: true,
      supportsLogo: true,
      layoutType: 'Bottom Banner',
      recommendedFor: ['Multi-concept Venues', 'Food Courts'],
    ),

    // LOGO-PROMINENT
    WelcomePageTemplate.largeLogo: WelcomeTemplateMetadata(
      name: 'Large Logo',
      description: 'Oversized brand mark as hero element',
      category: 'Logo-Prominent',
      requiresImage: false,
      supportsBranding: true,
      supportsLogo: true,
      layoutType: 'Logo Hero',
      recommendedFor: ['Strong Brand Recognition', 'Chain Restaurants'],
    ),

    WelcomePageTemplate.logoWithTagline: WelcomeTemplateMetadata(
      name: 'Logo with Tagline',
      description: 'Brand mark paired with mission statement',
      category: 'Logo-Prominent',
      requiresImage: false,
      supportsBranding: true,
      supportsLogo: true,
      layoutType: 'Logo + Text',
      recommendedFor: ['Branded Concepts', 'Franchises'],
    ),

    WelcomePageTemplate.circularLogo: WelcomeTemplateMetadata(
      name: 'Circular Logo',
      description: 'Round logo with gradient background',
      category: 'Logo-Prominent',
      requiresImage: false,
      supportsBranding: true,
      supportsLogo: true,
      layoutType: 'Circular',
      recommendedFor: ['Coffee Shops', 'Specialty Foods'],
      primaryColor: Color(0xFF007AFF),
      secondaryColor: Color(0xFF00C7BE),
    ),

    // COLORFUL & BRANDED
    WelcomePageTemplate.gradientBackground: WelcomeTemplateMetadata(
      name: 'Gradient Background',
      description: 'Smooth color transition with brand colors',
      category: 'Colorful & Branded',
      requiresImage: false,
      supportsBranding: true,
      supportsLogo: true,
      layoutType: 'Gradient',
      recommendedFor: ['Modern Brands', 'Trendy Cafes'],
      primaryColor: Color(0xFF667eea),
      secondaryColor: Color(0xFF764ba2),
    ),

    WelcomePageTemplate.subtleColor: WelcomeTemplateMetadata(
      name: 'Subtle Color',
      description: 'Soft pastel tones for elegant feel',
      category: 'Colorful & Branded',
      requiresImage: false,
      supportsBranding: true,
      supportsLogo: true,
      layoutType: 'Pastel',
      recommendedFor: ['Bakeries', 'Tea Houses', 'Dessert Shops'],
      primaryColor: Color(0xFFFFF5F7),
      secondaryColor: Color(0xFFF0E5F3),
    ),

    // TYPOGRAPHY-FOCUSED
    WelcomePageTemplate.bigTypography: WelcomeTemplateMetadata(
      name: 'Big Typography',
      description: 'Large, bold statement text',
      category: 'Typography-Focused',
      requiresImage: false,
      supportsBranding: true,
      supportsLogo: false,
      layoutType: 'Typography',
      recommendedFor: ['Modern Concepts', 'Urban Eateries'],
    ),

    WelcomePageTemplate.minimalistText: WelcomeTemplateMetadata(
      name: 'Minimalist Text',
      description: 'Ultra-clean text-only design',
      category: 'Typography-Focused',
      requiresImage: false,
      supportsBranding: true,
      supportsLogo: false,
      layoutType: 'Text Only',
      recommendedFor: ['High-End Dining', 'Exclusive Venues'],
    ),
  };

  /// Get template metadata
  static WelcomeTemplateMetadata? getMetadata(WelcomePageTemplate template) {
    return templates[template];
  }

  /// Get all templates by category
  static Map<String, List<WelcomePageTemplate>> getTemplatesByCategory() {
    final Map<String, List<WelcomePageTemplate>> categorized = {};

    templates.forEach((template, metadata) {
      if (!categorized.containsKey(metadata.category)) {
        categorized[metadata.category] = [];
      }
      categorized[metadata.category]!.add(template);
    });

    return categorized;
  }

  /// Get templates recommended for a specific venue type
  static List<WelcomePageTemplate> getRecommendedTemplates(String venueType) {
    return templates.entries
        .where((entry) => entry.value.recommendedFor.contains(venueType))
        .map((entry) => entry.key)
        .toList();
  }
}
