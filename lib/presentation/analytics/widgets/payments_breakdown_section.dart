import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../models/sales_summary_model.dart';

/// Payments breakdown section showing payment method distribution
class PaymentsBreakdownSection extends StatelessWidget {
  final PaymentsBreakdown payments;
  final double grossSales;

  const PaymentsBreakdownSection({
    super.key,
    required this.payments,
    required this.grossSales,
  });

  @override
  Widget build(BuildContext context) {
    final totalPayments =
        payments.card + payments.cash + payments.giftCard + payments.other;

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
            'PAYMENTS',
            style: AppTypography.label.copyWith(
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: AppSpacing.lg),

          // Payment methods
          if (payments.card > 0)
            _buildPaymentRow(
              label: 'Card',
              amount: payments.card,
              total: totalPayments,
            ),

          if (payments.cash > 0) ...[
            SizedBox(height: AppSpacing.md),
            _buildPaymentRow(
              label: 'Cash',
              amount: payments.cash,
              total: totalPayments,
            ),
          ],

          if (payments.giftCard > 0) ...[
            SizedBox(height: AppSpacing.md),
            _buildPaymentRow(
              label: 'Gift card',
              amount: payments.giftCard,
              total: totalPayments,
            ),
          ],

          if (payments.other > 0) ...[
            SizedBox(height: AppSpacing.md),
            _buildPaymentRow(
              label: 'Other',
              amount: payments.other,
              total: totalPayments,
            ),
          ],

          if (payments.fees > 0) ...[
            SizedBox(height: AppSpacing.md),
            _buildPaymentRow(
              label: 'Processing fees',
              amount: -payments.fees,
              total: totalPayments,
              isNegative: true,
            ),
          ],

          SizedBox(height: AppSpacing.lg),
          Divider(color: AppColors.gray300, height: 1, thickness: 1.5),
          SizedBox(height: AppSpacing.lg),

          // Total payments
          _buildTotalRow(
            label: 'Total payments',
            amount: totalPayments - payments.fees,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow({
    required String label,
    required double amount,
    required double total,
    bool isNegative = false,
  }) {
    final percentage = total > 0
        ? (amount / total * 100).toStringAsFixed(0)
        : '0';

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 15,
              color: AppColors.gray700,
            ),
          ),
        ),

        Expanded(
          flex: 2,
          child: Text(
            isNegative
                ? '-\$${(-amount).toStringAsFixed(2)}'
                : '\$${amount.toStringAsFixed(2)}',
            textAlign: TextAlign.right,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 15,
              color: isNegative ? AppColors.error : AppColors.gray800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        SizedBox(width: AppSpacing.md),

        SizedBox(
          width: 50,
          child: Text(
            isNegative ? '' : '$percentage%',
            textAlign: TextAlign.right,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 13,
              color: AppColors.gray600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow({required String label, required double amount}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyLarge.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: AppTypography.bodyLarge.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
