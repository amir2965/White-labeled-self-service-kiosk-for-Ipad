import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';

enum AppButtonSize { small, medium, large, extraLarge }

enum AppButtonVariant { filled, outline, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonSize size;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.variant = AppButtonVariant.filled,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = _getHeight();
    final buttonPadding = _getPadding();
    final textStyle = _getTextStyle();

    Widget child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: variant == AppButtonVariant.filled
                  ? AppColors.white
                  : AppColors.blue,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: _getIconSize()),
                SizedBox(width: AppSpacing.sm),
              ],
              Text(label, style: textStyle),
            ],
          );

    return SizedBox(
      height: buttonHeight,
      width: fullWidth ? double.infinity : null,
      child: _buildButtonByVariant(child, buttonPadding),
    );
  }

  Widget _buildButtonByVariant(Widget child, EdgeInsets padding) {
    switch (variant) {
      case AppButtonVariant.filled:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            padding: padding,
            backgroundColor: AppColors.blue,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.disabled,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            elevation: 0,
          ),
          child: child,
        );
      case AppButtonVariant.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: padding,
            foregroundColor: AppColors.black,
            side: BorderSide(color: AppColors.border, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
          child: child,
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding: padding,
            foregroundColor: AppColors.blue,
          ),
          child: child,
        );
    }
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return AppSpacing.minTouchTarget;
      case AppButtonSize.medium:
        return AppSpacing.largeTouchTarget;
      case AppButtonSize.large:
        return AppSpacing.extraLargeTouchTarget;
      case AppButtonSize.extraLarge:
        return 96;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return EdgeInsets.symmetric(horizontal: AppSpacing.md);
      case AppButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: AppSpacing.lg);
      case AppButtonSize.large:
        return EdgeInsets.symmetric(horizontal: AppSpacing.xl);
      case AppButtonSize.extraLarge:
        return EdgeInsets.symmetric(horizontal: AppSpacing.xxl);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSize.small:
        return AppTypography.buttonSmall;
      case AppButtonSize.medium:
        return AppTypography.buttonMedium;
      case AppButtonSize.large:
      case AppButtonSize.extraLarge:
        return AppTypography.buttonLarge;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 18;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
      case AppButtonSize.extraLarge:
        return 24;
    }
  }
}
