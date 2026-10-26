import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../branding/providers/branding_provider.dart';
import '../branding/widgets/welcome_preview.dart';
import 'kiosk_menu_screen.dart';
import 'menu_template_config.dart';
import 'template_selector_screen.dart';
import '../providers/template_provider.dart';

/// Order mode selection
enum OrderMode { dineIn, takeaway }

/// Kiosk welcome/home screen - first screen customers see
/// Implements "Centered Fast Order" template design
class KioskWelcomeScreen extends ConsumerStatefulWidget {
  const KioskWelcomeScreen({super.key});

  @override
  ConsumerState<KioskWelcomeScreen> createState() => _KioskWelcomeScreenState();
}

class _KioskWelcomeScreenState extends ConsumerState<KioskWelcomeScreen> {
  OrderMode? selectedMode;
  bool hasStarted = false;

  void _startOrder() {
    setState(() {
      hasStarted = true;
    });
  }

  void _selectMode(OrderMode mode) {
    setState(() {
      selectedMode = mode;
    });

    // Navigate to product menu after brief delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        // Get selected template or use default
        final template =
            ref.read(selectedTemplateProvider) ??
            MenuDisplayTemplate.categorySidebar;
        // Navigate to menu screen with selected template via GoRouter
        context.go('/menu', extra: template);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get branding settings
    final brandingSettings = ref.watch(brandingSettingsProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: hasStarted ? null : _startOrder,
        child: Stack(
          children: [
            // Use the branded welcome preview as the main content
            WelcomePreview(
              settings: brandingSettings,
              onButtonTap: hasStarted ? null : _startOrder,
            ),

            // Overlay interactive elements for order mode selection
            if (hasStarted)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(48),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'How would you like your order?',
                          style: AppTypography.h3.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 32),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ModeButton(
                              label: 'Dine In',
                              icon: Icons.restaurant,
                              isSelected: selectedMode == OrderMode.dineIn,
                              onTap: () => _selectMode(OrderMode.dineIn),
                            ),
                            SizedBox(width: 32),
                            _ModeButton(
                              label: 'Takeaway',
                              icon: Icons.shopping_bag_outlined,
                              isSelected: selectedMode == OrderMode.takeaway,
                              onTap: () => _selectMode(OrderMode.takeaway),
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
      ),
    );
  }
}

/// Mode selection button
class _ModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 200,
        height: 160,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.blue : AppColors.gray300,
            width: isSelected ? 3 : 2,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? AppColors.blue.withOpacity(0.1) : AppColors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: isSelected ? AppColors.blue : AppColors.gray600,
            ),
            SizedBox(height: 16),
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 20,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.blue : AppColors.gray900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
