/// Professional font configurations for welcome page branding
class FontConfig {
  final String name;
  final String fontFamily;
  final String description;
  final String category;
  final bool isGoogleFont;

  const FontConfig({
    required this.name,
    required this.fontFamily,
    required this.description,
    required this.category,
    this.isGoogleFont = true,
  });

  /// 25 carefully curated professional fonts for enterprise kiosk systems
  static const List<FontConfig> availableFonts = [
    // MODERN SANS-SERIF (8 fonts)
    FontConfig(
      name: 'Inter',
      fontFamily: 'Inter',
      description: 'Clean, modern, highly legible',
      category: 'Modern Sans-Serif',
    ),
    FontConfig(
      name: 'Poppins',
      fontFamily: 'Poppins',
      description: 'Geometric, friendly, professional',
      category: 'Modern Sans-Serif',
    ),
    FontConfig(
      name: 'Montserrat',
      fontFamily: 'Montserrat',
      description: 'Urban, contemporary, versatile',
      category: 'Modern Sans-Serif',
    ),
    FontConfig(
      name: 'Raleway',
      fontFamily: 'Raleway',
      description: 'Elegant, sophisticated, refined',
      category: 'Modern Sans-Serif',
    ),
    FontConfig(
      name: 'Nunito',
      fontFamily: 'Nunito',
      description: 'Rounded, warm, approachable',
      category: 'Modern Sans-Serif',
    ),
    FontConfig(
      name: 'Lexend',
      fontFamily: 'Lexend',
      description: 'Hyper-legible, accessible',
      category: 'Modern Sans-Serif',
    ),
    FontConfig(
      name: 'DM Sans',
      fontFamily: 'DM Sans',
      description: 'Low contrast, clean, modern',
      category: 'Modern Sans-Serif',
    ),
    FontConfig(
      name: 'Work Sans',
      fontFamily: 'Work Sans',
      description: 'Optimized for screen, clear',
      category: 'Modern Sans-Serif',
    ),

    // ELEGANT SERIF (6 fonts)
    FontConfig(
      name: 'Playfair Display',
      fontFamily: 'Playfair Display',
      description: 'Luxurious, high contrast, editorial',
      category: 'Elegant Serif',
    ),
    FontConfig(
      name: 'Lora',
      fontFamily: 'Lora',
      description: 'Brushed curves, contemporary serif',
      category: 'Elegant Serif',
    ),
    FontConfig(
      name: 'Merriweather',
      fontFamily: 'Merriweather',
      description: 'Readable, pleasant, classic',
      category: 'Elegant Serif',
    ),
    FontConfig(
      name: 'Crimson Text',
      fontFamily: 'Crimson Text',
      description: 'Book typography, refined',
      category: 'Elegant Serif',
    ),
    FontConfig(
      name: 'Libre Baskerville',
      fontFamily: 'Libre Baskerville',
      description: 'Traditional, trustworthy',
      category: 'Elegant Serif',
    ),
    FontConfig(
      name: 'Cormorant',
      fontFamily: 'Cormorant',
      description: 'Display serif, graceful',
      category: 'Elegant Serif',
    ),

    // LUXURY & DISPLAY (5 fonts)
    FontConfig(
      name: 'Cinzel',
      fontFamily: 'Cinzel',
      description: 'Classical, premium, upscale',
      category: 'Luxury & Display',
    ),
    FontConfig(
      name: 'Bodoni Moda',
      fontFamily: 'Bodoni Moda',
      description: 'High fashion, dramatic contrast',
      category: 'Luxury & Display',
    ),
    FontConfig(
      name: 'Abril Fatface',
      fontFamily: 'Abril Fatface',
      description: 'Bold, attention-grabbing',
      category: 'Luxury & Display',
    ),
    FontConfig(
      name: 'Spectral',
      fontFamily: 'Spectral',
      description: 'Efficient, beautiful, modern serif',
      category: 'Luxury & Display',
    ),
    FontConfig(
      name: 'Italiana',
      fontFamily: 'Italiana',
      description: 'Elegant, wide, sophisticated',
      category: 'Luxury & Display',
    ),

    // FRIENDLY & CASUAL (4 fonts)
    FontConfig(
      name: 'Quicksand',
      fontFamily: 'Quicksand',
      description: 'Friendly, rounded, inviting',
      category: 'Friendly & Casual',
    ),
    FontConfig(
      name: 'Comfortaa',
      fontFamily: 'Comfortaa',
      description: 'Soft, rounded, comfortable',
      category: 'Friendly & Casual',
    ),
    FontConfig(
      name: 'Josefin Sans',
      fontFamily: 'Josefin Sans',
      description: 'Geometric, vintage, stylish',
      category: 'Friendly & Casual',
    ),
    FontConfig(
      name: 'Cabin',
      fontFamily: 'Cabin',
      description: 'Humanist, warm, welcoming',
      category: 'Friendly & Casual',
    ),

    // TECHNICAL & MODERN (2 fonts)
    FontConfig(
      name: 'Space Grotesk',
      fontFamily: 'Space Grotesk',
      description: 'Futuristic, tech-forward',
      category: 'Technical & Modern',
    ),
    FontConfig(
      name: 'Syne',
      fontFamily: 'Syne',
      description: 'Contemporary, distinctive',
      category: 'Technical & Modern',
    ),
  ];

  /// Get font by family name
  static FontConfig? getFontByFamily(String? fontFamily) {
    if (fontFamily == null) return null;
    try {
      return availableFonts.firstWhere((font) => font.fontFamily == fontFamily);
    } catch (_) {
      return null;
    }
  }

  /// Get fonts by category
  static Map<String, List<FontConfig>> getFontsByCategory() {
    final Map<String, List<FontConfig>> categorized = {};
    for (final font in availableFonts) {
      categorized.putIfAbsent(font.category, () => []).add(font);
    }
    return categorized;
  }

  /// Get sample text for preview
  static String getSampleText(String businessName) {
    return businessName;
  }
}
