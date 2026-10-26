import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing recent custom colors (max 2)
final recentColorsProvider =
    StateNotifierProvider<RecentColorsNotifier, List<Color>>((ref) {
      return RecentColorsNotifier();
    });

class RecentColorsNotifier extends StateNotifier<List<Color>> {
  RecentColorsNotifier() : super([]);

  /// Add a new color (max 2 colors, newest replaces oldest)
  void addColor(Color color) {
    final newColors = List<Color>.from(state);

    // Remove if already exists
    newColors.removeWhere((c) => c.value == color.value);

    // Add to front
    newColors.insert(0, color);

    // Keep only 2 most recent
    if (newColors.length > 2) {
      newColors.removeLast();
    }

    state = newColors;
  }

  /// Clear all recent colors
  void clear() {
    state = [];
  }
}
