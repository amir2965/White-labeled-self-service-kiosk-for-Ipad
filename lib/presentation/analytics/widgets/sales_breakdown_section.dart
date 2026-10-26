import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

/// Sales breakdown section showing itemized sales components
class SalesBreakdownSection extends StatelessWidget {
  final double grossSales;
  final double netSales;
  final double taxes;
  final double discounts;
  final double returns;
  final double tips;
  final double serviceCharges;

  const SalesBreakdownSection({
    super.key,
    required this.grossSales,
    required this.netSales,
    required this.taxes,
    required this.discounts,
    required this.returns,
    required this.tips,
    required this.serviceCharges,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray300.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'SALES BREAKDOWN',
            style: AppTypography.label.copyWith(
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: AppSpacing.lg),

          // Product sales (calculated)
          _buildRow(
            label: 'Product sales',
            amount: netSales,
            isSubtotal: false,
          ),

          if (discounts > 0) ...[
            SizedBox(height: AppSpacing.md),
            _buildRow(
              label: 'Discounts',
              amount: -discounts,
              isSubtotal: false,
              isNegative: true,
            ),
          ],

          if (returns > 0) ...[
            SizedBox(height: AppSpacing.md),
            _buildRow(
              label: 'Returns',
              amount: -returns,
              isSubtotal: false,
              isNegative: true,
            ),
          ],

          SizedBox(height: AppSpacing.lg),
          Divider(color: AppColors.gray300.withOpacity(0.5), height: 1),
          SizedBox(height: AppSpacing.lg),

          // Net sales subtotal
          _buildRow(
            label: 'Net sales',
            amount: netSales - discounts - returns,
            isSubtotal: true,
          ),

          if (taxes > 0) ...[
            SizedBox(height: AppSpacing.md),
            _buildRow(label: 'Tax', amount: taxes, isSubtotal: false),
          ],

          if (tips > 0) ...[
            SizedBox(height: AppSpacing.md),
            _buildRow(label: 'Tips', amount: tips, isSubtotal: false),
          ],

          if (serviceCharges > 0) ...[
            SizedBox(height: AppSpacing.md),
            _buildRow(
              label: 'Service charges',
              amount: serviceCharges,
              isSubtotal: false,
            ),
          ],

          SizedBox(height: AppSpacing.lg),
          Divider(color: AppColors.gray300, height: 1, thickness: 1.5),
          SizedBox(height: AppSpacing.lg),

          // Gross sales total
          _buildRow(label: 'Gross sales', amount: grossSales, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required double amount,
    bool isSubtotal = false,
    bool isTotal = false,
    bool isNegative = false,
  }) {
    TextStyle labelStyle;
    TextStyle amountStyle;

    if (isTotal) {
      labelStyle = AppTypography.bodyLarge.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      );
      amountStyle = labelStyle;
    } else if (isSubtotal) {
      labelStyle = AppTypography.bodyMedium.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );
      amountStyle = labelStyle;
    } else {
      labelStyle = AppTypography.bodyMedium.copyWith(
        fontSize: 15,
        color: AppColors.gray700,
      );
      amountStyle = AppTypography.bodyMedium.copyWith(
        fontSize: 15,
        color: isNegative ? AppColors.error : AppColors.gray800,
        fontWeight: FontWeight.w500,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(
          isNegative
              ? '-\$${(-amount).toStringAsFixed(2)}'
              : '\$${amount.toStringAsFixed(2)}',
          style: amountStyle,
        ),
      ],
    );
  }
}
