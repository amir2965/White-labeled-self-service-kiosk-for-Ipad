import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../models/date_range_selection.dart';
import '../theme_provider.dart';

/// Quick preset buttons list for date range selection
class QuickPresetList extends ConsumerWidget {
  final Function(RangePreset) onPresetSelected;

  const QuickPresetList({super.key, required this.onPresetSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'QUICK SELECT',
            style: AppTypography.label.copyWith(
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.6)
                  : AppColors.gray600,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Expanded(
            child: ListView(
              children: RangePreset.values
                  .map((preset) => _buildPresetButton(preset, isDarkMode))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetButton(RangePreset preset, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPresetSelected(preset),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.05)
                  : AppColors.gray100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.15)
                    : AppColors.gray300.withOpacity(0.5),
              ),
            ),
            child: Center(
              child: Text(
                preset.label,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : AppColors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
