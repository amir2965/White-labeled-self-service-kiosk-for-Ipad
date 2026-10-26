import 'package:flutter/material.dart';

/// Professional gradient presets for different restaurant types
class GradientPreset {
  final String name;
  final String description;
  final LinearGradient gradient;
  final String category;

  const GradientPreset({
    required this.name,
    required this.description,
    required this.gradient,
    required this.category,
  });
}

class GradientPresets {
  static const List<GradientPreset> presets = [
    // Elegant & Luxury
    GradientPreset(
      name: 'Gold Elegance',
      description: 'Sophisticated gold for fine dining',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1a1a1a), Color(0xFFD4AF37)],
      ),
      category: 'Fine Dining',
    ),

    GradientPreset(
      name: 'Royal Purple',
      description: 'Luxurious purple for upscale venues',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
      ),
      category: 'Fine Dining',
    ),

    // Warm & Cozy
    GradientPreset(
      name: 'Coffee Warmth',
      description: 'Rich browns for coffee shops',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF6F4E37), Color(0xFFF5DEB3)],
      ),
      category: 'Coffee Shop',
    ),

    GradientPreset(
      name: 'Sunset Glow',
      description: 'Warm orange tones for casual dining',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
      ),
      category: 'Casual Dining',
    ),

    // Fresh & Modern
    GradientPreset(
      name: 'Ocean Breeze',
      description: 'Fresh blue for modern cafes',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF007AFF), Color(0xFF00C7BE)],
      ),
      category: 'Modern Cafe',
    ),

    GradientPreset(
      name: 'Mint Fresh',
      description: 'Light green for healthy eateries',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF34C759), Color(0xFF90EE90)],
      ),
      category: 'Healthy Food',
    ),

    // Vibrant & Energetic
    GradientPreset(
      name: 'Sunset Vibes',
      description: 'Pink to orange for trendy spots',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFF3B30), Color(0xFFFFCC00)],
      ),
      category: 'Fast Casual',
    ),

    GradientPreset(
      name: 'Berry Burst',
      description: 'Purple to pink for dessert shops',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFAF40FF), Color(0xFFFF63C7)],
      ),
      category: 'Dessert Shop',
    ),

    // Sophisticated & Neutral
    GradientPreset(
      name: 'Slate Gray',
      description: 'Professional gray for corporate venues',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
      ),
      category: 'Corporate',
    ),

    GradientPreset(
      name: 'Midnight Blue',
      description: 'Deep blue for sophisticated bars',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF000428), Color(0xFF004e92)],
      ),
      category: 'Bar & Lounge',
    ),
  ];

  static List<GradientPreset> getByCategory(String category) {
    return presets.where((p) => p.category == category).toList();
  }
}
