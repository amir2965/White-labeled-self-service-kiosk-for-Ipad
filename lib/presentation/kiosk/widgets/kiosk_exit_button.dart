import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import 'kiosk_pin_screen.dart';

/// Reusable hidden exit button for kiosk templates
/// Shows a 3-dot menu icon that requires 5 quick taps to trigger PIN screen
class KioskExitButton extends StatefulWidget {
  final bool isVisible;
  final double? size;
  final Color? color;
  final EdgeInsets? padding;

  const KioskExitButton({
    super.key,
    this.isVisible = true,
    this.size = 24,
    this.color,
    this.padding,
  });

  @override
  State<KioskExitButton> createState() => _KioskExitButtonState();
}

class _KioskExitButtonState extends State<KioskExitButton> {
  int _tapCount = 0;
  DateTime? _lastTapTime;

  void _handleTap() {
    final now = DateTime.now();

    // Reset if more than 2 seconds since last tap
    if (_lastTapTime == null || now.difference(_lastTapTime!).inSeconds > 2) {
      _tapCount = 1;
    } else {
      _tapCount++;
    }

    _lastTapTime = now;

    // Show PIN after 5 taps
    if (_tapCount >= 5) {
      _tapCount = 0;
      _showPinScreen();
    }
  }

  void _showPinScreen() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => KioskPinScreen(
        onCorrectPin: () {
          // Close PIN dialog
          Navigator.of(dialogContext).pop();
          // Navigate to dashboard using go_router
          context.go('/dashboard');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        padding: widget.padding ?? const EdgeInsets.all(8),
        child: Icon(
          Icons.more_vert,
          size: widget.size,
          color: widget.color ?? AppColors.gray400,
        ),
      ),
    );
  }
}
