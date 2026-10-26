import 'package:flutter/material.dart';
import '../../../domain/entities/merchant.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

class BusinessTypeStep extends StatelessWidget {
  final BusinessType selectedType;
  final Function(BusinessType) onSelected;

  const BusinessTypeStep({
    super.key,
    required this.selectedType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What type of business do you run?', style: AppTypography.h2),
          SizedBox(height: AppSpacing.xl),

          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.lg,
            mainAxisSpacing: AppSpacing.lg,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildTypeCard(
                type: BusinessType.cafe,
                title: 'Cafe',
                icon: Icons.local_cafe,
              ),
              _buildTypeCard(
                type: BusinessType.restaurant,
                title: 'Restaurant',
                icon: Icons.restaurant,
              ),
              _buildTypeCard(
                type: BusinessType.retail,
                title: 'Retail',
                icon: Icons.shopping_bag,
              ),
              _buildTypeCard(
                type: BusinessType.clinic,
                title: 'Clinic',
                icon: Icons.medical_services,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard({
    required BusinessType type,
    required String title,
    required IconData icon,
  }) {
    final isSelected = type == selectedType;

    return GestureDetector(
      onTap: () => onSelected(type),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: isSelected ? AppColors.blue : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: isSelected ? AppColors.white : AppColors.textPrimary,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: AppTypography.h3.copyWith(
                color: isSelected ? AppColors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
