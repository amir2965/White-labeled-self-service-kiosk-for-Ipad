import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Theme mode state notifier for analytics pages
class ThemeModeNotifier extends StateNotifier<bool> {
  ThemeModeNotifier() : super(false); // false = light mode, true = dark mode

  void toggleTheme() {
    state = !state;
  }

  void setDarkMode(bool isDark) {
    state = isDark;
  }

  bool get isDarkMode => state;
}

/// Provider for theme mode
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, bool>((ref) {
  return ThemeModeNotifier();
});
