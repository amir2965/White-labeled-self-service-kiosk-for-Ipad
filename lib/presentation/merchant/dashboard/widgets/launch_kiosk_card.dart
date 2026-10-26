import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Primary action card for launching kiosk mode
class LaunchKioskCard extends StatefulWidget {
  final VoidCallback onLaunch;

  const LaunchKioskCard({super.key, required this.onLaunch});

  @override
  State<LaunchKioskCard> createState() => _LaunchKioskCardState();
}

class _LaunchKioskCardState extends State<LaunchKioskCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onLaunch,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: _isPressed ? AppColors.gray900 : AppColors.black,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(_isPressed ? 0.08 : 0.12),
              blurRadius: _isPressed ? 8 : 16,
              offset: Offset(0, _isPressed ? 2 : 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                size: 36,
                color: AppColors.white,
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              'Launch Kiosk Mode',
              style: AppTypography.h2.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),

            SizedBox(height: AppSpacing.xs),

            // Description
            Text(
              'Start customer-facing ordering experience',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.white.withOpacity(0.8),
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            // Action Indicator
            Row(
              children: [
                Text(
                  'Ready to Launch',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: AppSpacing.xs),
                Icon(Icons.arrow_forward, size: 20, color: AppColors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
