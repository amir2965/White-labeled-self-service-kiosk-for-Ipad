import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Modern, minimal confirmation dialog for branding actions
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final IconData? icon;
  final Color? iconColor;
  final bool isDangerous;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    required this.onConfirm,
    this.onCancel,
    this.icon,
    this.iconColor,
    this.isDangerous = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            if (icon != null)
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.blue).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: iconColor ?? AppColors.blue),
              ),
            if (icon != null) const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.gray700,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onCancel?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: AppColors.gray300, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      cancelText,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDangerous
                          ? AppColors.error
                          : AppColors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Show save changes confirmation
  static Future<void> showSaveConfirmation(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: 'Save Changes?',
        message:
            'Your branding settings will be applied to the kiosk welcome page. Are you sure you want to save these changes?',
        confirmText: 'Save',
        cancelText: 'Cancel',
        icon: Icons.save_outlined,
        iconColor: AppColors.success,
        onConfirm: onConfirm,
      ),
    );
  }

  /// Show reset confirmation
  static Future<void> showResetConfirmation(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: 'Reset to Defaults?',
        message:
            'This will reset all branding settings including template, colors, fonts, and customizations to their default values. This action cannot be undone.',
        confirmText: 'Reset',
        cancelText: 'Cancel',
        icon: Icons.restore,
        iconColor: AppColors.warning,
        isDangerous: true,
        onConfirm: onConfirm,
      ),
    );
  }

  /// Show discard changes confirmation (for back button)
  static Future<bool> showDiscardConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: 'Unsaved Changes',
        message:
            'You have unsaved changes. Are you sure you want to leave? Your changes will be lost.',
        confirmText: 'Leave',
        cancelText: 'Stay',
        icon: Icons.warning_outlined,
        iconColor: AppColors.warning,
        isDangerous: true,
        onConfirm: () {},
      ),
    );
    return result == null;
  }

  /// Show font reset confirmation
  static Future<void> showFontResetConfirmation(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: 'Reset Font to Default?',
        message:
            'This will reset the selected font to the default typography. Your current font selection will be lost.',
        confirmText: 'Reset Font',
        cancelText: 'Cancel',
        icon: Icons.text_fields,
        iconColor: AppColors.info,
        onConfirm: onConfirm,
      ),
    );
  }
}
