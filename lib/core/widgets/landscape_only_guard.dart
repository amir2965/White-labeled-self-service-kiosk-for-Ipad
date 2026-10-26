import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';

/// Widget that enforces landscape orientation for certain templates
/// Shows a professional prompt when in portrait mode
class LandscapeOnlyGuard extends StatelessWidget {
  final Widget child;
  final String templateName;

  const LandscapeOnlyGuard({
    super.key,
    required this.child,
    this.templateName = 'This template',
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _RotatePrompt(templateName: templateName);
        }
        return child;
      },
    );
  }
}

class _RotatePrompt extends StatelessWidget {
  final String templateName;

  const _RotatePrompt({required this.templateName});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Container(
          margin: EdgeInsets.all(AppSpacing.xxl),
          padding: EdgeInsets.all(AppSpacing.xxl * 2),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.1),
                blurRadius: 40,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Rotation icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Icon(
                  Icons.screen_rotation,
                  size: 64,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: AppSpacing.xxl),

              // Title
              Text(
                'Rotate to Landscape',
                style: AppTypography.h1.copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.md),

              // Description
              Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Text(
                  '$templateName is optimized for landscape orientation.\n\nPlease rotate your device to continue.',
                  style: AppTypography.bodyLarge.copyWith(
                    fontSize: 18,
                    color: AppColors.gray600,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: AppSpacing.xxl),

              // Visual indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _DeviceIcon(isPortrait: true, isActive: true),
                  SizedBox(width: AppSpacing.xl),
                  Icon(Icons.arrow_forward, size: 32, color: AppColors.gray400),
                  SizedBox(width: AppSpacing.xl),
                  _DeviceIcon(isPortrait: false, isActive: false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeviceIcon extends StatelessWidget {
  final bool isPortrait;
  final bool isActive;

  const _DeviceIcon({required this.isPortrait, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isPortrait ? 60 : 90,
      height: isPortrait ? 90 : 60,
      decoration: BoxDecoration(
        color: isActive ? AppColors.gray300 : AppColors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? AppColors.gray400 : AppColors.black,
          width: 3,
        ),
      ),
      child: Center(
        child: Icon(
          isPortrait
              ? Icons.stay_current_portrait
              : Icons.stay_current_landscape,
          color: isActive ? AppColors.gray600 : AppColors.white,
          size: isPortrait ? 32 : 40,
        ),
      ),
    );
  }
}
