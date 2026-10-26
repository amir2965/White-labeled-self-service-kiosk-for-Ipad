import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

/// Modern exit confirmation overlay for kiosk mode
class KioskExitOverlay extends StatefulWidget {
  final VoidCallback onConfirmExit;
  final VoidCallback onCancel;

  const KioskExitOverlay({
    super.key,
    required this.onConfirmExit,
    required this.onCancel,
  });

  @override
  State<KioskExitOverlay> createState() => _KioskExitOverlayState();
}

class _KioskExitOverlayState extends State<KioskExitOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Blurred/dimmed background
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              color: Colors.black.withOpacity(0.75),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.black.withOpacity(0.2)),
              ),
            ),
          ),

          // Center content
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 48),
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.blue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.exit_to_app_rounded,
                        size: 40,
                        color: AppColors.blue,
                      ),
                    ),
                    SizedBox(height: 24),

                    // Title
                    Text(
                      'Exit Kiosk Mode',
                      style: AppTypography.h2.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),

                    // Subtitle
                    Text(
                      'Return to merchant dashboard',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.gray600,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildButton(
                            label: 'Cancel',
                            onTap: () {
                              HapticFeedback.lightImpact();
                              widget.onCancel();
                            },
                            isPrimary: false,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildButton(
                            label: 'Exit',
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              widget.onConfirmExit();
                            },
                            isPrimary: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return Material(
      color: isPrimary ? AppColors.blue : AppColors.background,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPrimary ? AppColors.blue : AppColors.gray300,
              width: isPrimary ? 0 : 1.5,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.h4.copyWith(
                color: isPrimary ? AppColors.white : AppColors.gray900,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
