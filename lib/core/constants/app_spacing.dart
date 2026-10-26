/// Generous spacing system for tablet/kiosk UI
class AppSpacing {
  AppSpacing._();

  // Base unit: 8px
  static const double unit = 8.0;

  // Spacing scale
  static const double xs = unit * 0.5; // 4
  static const double sm = unit; // 8
  static const double md = unit * 2; // 16
  static const double lg = unit * 3; // 24
  static const double xl = unit * 4; // 32
  static const double xxl = unit * 6; // 48
  static const double xxxl = unit * 8; // 64

  // Screen margins (tablet-optimized)
  static const double screenPadding = xl; // 32
  static const double screenPaddingLarge = xxl; // 48

  // Component spacing
  static const double cardPadding = lg; // 24
  static const double listItemPadding = md; // 16
  static const double sectionSpacing = xxl; // 48
  static const double groupSpacing = xl; // 32

  // Touch targets (minimum 48dp for accessibility)
  static const double minTouchTarget = 48.0;
  static const double largeTouchTarget = 64.0;
  static const double extraLargeTouchTarget = 80.0;

  // Border Radius
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusFull = 999.0;
  static const double radiusRound = 999.0;

  // Elevation (for shadows)
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
}
