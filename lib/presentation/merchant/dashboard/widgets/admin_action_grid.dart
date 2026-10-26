import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Admin actions grid for navigation to management features
class AdminActionGrid extends StatelessWidget {
  final Function(String) onNavigate;

  const AdminActionGrid({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.md),
          child: Text(
            'Management',
            style: AppTypography.h3.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        // Grid
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 700 ? 3 : 2;
            final spacing = AppSpacing.lg;

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              childAspectRatio: 1.6,
              children: [
                _ActionCard(
                  icon: Icons.restaurant_menu,
                  title: 'Menu & Items',
                  description: 'Manage products',
                  onTap: () => onNavigate('menu'),
                ),
                _ActionCard(
                  icon: Icons.receipt_long,
                  title: 'Orders',
                  description: 'View transactions',
                  onTap: () => onNavigate('orders'),
                ),
                _ActionCard(
                  icon: Icons.tablet_mac,
                  title: 'Devices',
                  description: 'Manage kiosks',
                  onTap: () => onNavigate('devices'),
                ),
                _ActionCard(
                  icon: Icons.palette_outlined,
                  title: 'Templates',
                  description: 'Change layout',
                  onTap: () => onNavigate('settings'),
                ),
                _ActionCard(
                  icon: Icons.brush_outlined,
                  title: 'Branding',
                  description: 'Customize look',
                  onTap: () => onNavigate('branding'),
                ),
                _ActionCard(
                  icon: Icons.analytics_outlined,
                  title: 'Analytics',
                  description: 'View insights',
                  onTap: () => onNavigate('analytics'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: _isPressed ? AppColors.background : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.gray300.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(_isPressed ? 0.02 : 0.04),
              blurRadius: _isPressed ? 4 : 8,
              offset: Offset(0, _isPressed ? 1 : 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 32, color: AppColors.gray900),
            SizedBox(height: AppSpacing.md),
            Text(
              widget.title,
              style: AppTypography.h4.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              widget.description,
              style: AppTypography.bodySmall.copyWith(color: AppColors.gray600),
            ),
          ],
        ),
      ),
    );
  }
}
