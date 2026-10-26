import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Simple segmented bar showing QR vs Counter payment split
class PaymentMixBar extends StatelessWidget {
  final double qrAmount;
  final double counterAmount;
  final int qrCount;
  final int counterCount;
  final bool isDarkMode;

  const PaymentMixBar({
    super.key,
    required this.qrAmount,
    required this.counterAmount,
    required this.qrCount,
    required this.counterCount,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final total = qrAmount + counterAmount;
    final qrPercent = total > 0 ? (qrAmount / total * 100) : 0;
    final counterPercent = 100 - qrPercent;
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );

    return Column(
      children: [
        // Labels and amounts
        Row(
          children: [
            // QR Code payment
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'QR Code',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.9)
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(qrAmount),
                    style: AppTypography.h3.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    '$qrCount orders',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.6)
                          : AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),

            // Pay at Counter
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.gray400,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Pay at Counter',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.9)
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(counterAmount),
                    style: AppTypography.h3.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    '$counterCount orders',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.6)
                          : AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        // Segmented bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 48,
            child: Row(
              children: [
                if (qrPercent > 0)
                  Expanded(
                    flex: qrPercent.round(),
                    child: Container(
                      color: AppColors.blue,
                      alignment: Alignment.center,
                      child: qrPercent > 15
                          ? Text(
                              '${qrPercent.toStringAsFixed(0)}%',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : null,
                    ),
                  ),
                if (counterPercent > 0)
                  Expanded(
                    flex: counterPercent.round(),
                    child: Container(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.2)
                          : AppColors.gray300,
                      alignment: Alignment.center,
                      child: counterPercent > 15
                          ? Text(
                              '${counterPercent.toStringAsFixed(0)}%',
                              style: AppTypography.bodyMedium.copyWith(
                                color: isDarkMode
                                    ? Colors.white
                                    : AppColors.gray800,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : null,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
