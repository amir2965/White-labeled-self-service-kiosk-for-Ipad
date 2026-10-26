import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import 'theme_provider.dart';

/// **GST Overview Page**
///
/// Informational GST summary for transparency and record-keeping.
/// NOT accounting software - shows platform transaction data only.
///
/// Design: Calm, professional, compliance-grade
///
/// Features:
/// - GST collected from sales (observable data)
/// - GST on platform fees (observable data)
/// - Clear disclaimer
class GSTPage extends ConsumerStatefulWidget {
  const GSTPage({super.key});

  @override
  ConsumerState<GSTPage> createState() => _GSTPageState();
}

class _GSTPageState extends ConsumerState<GSTPage> {
  final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

  // Mock GST data - backend ready structure
  // TODO: Replace with actual API data from backend
  final _mockGSTData = _GSTData(
    totalGSTCollected: 1234.56, // GST included in customer payments
    totalGSTOnFees: 45.67, // GST charged on platform service fees
  );

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Container(
      color: isDarkMode ? Color(0xFF1A1A1A) : AppColors.gray50,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.xxl * 2,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(isDarkMode),

                const SizedBox(height: AppSpacing.xxl * 1.5),

                // Summary Cards
                _buildSummaryCards(isDarkMode),

                const SizedBox(height: AppSpacing.xxl * 2),

                // Disclaimer
                _buildDisclaimer(isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'GST Overview',
              style: AppTypography.h3.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                letterSpacing: -0.5,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            'Summary of GST amounts from platform transactions',
            style: AppTypography.bodyMedium.copyWith(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.7)
                  : AppColors.gray600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(bool isDarkMode) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth > 700
            ? (constraints.maxWidth - AppSpacing.xxl) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: AppSpacing.xxl,
          runSpacing: AppSpacing.xl,
          alignment: WrapAlignment.center,
          children: [
            SizedBox(
              width: cardWidth > 450 ? 450 : cardWidth,
              child: _buildSummaryCard(
                label: 'GST Collected (Sales)',
                value: currencyFormat.format(_mockGSTData.totalGSTCollected),
                subtitle:
                    'GST included in customer payments processed through the platform',
                icon: Icons.point_of_sale,
                isDarkMode: isDarkMode,
              ),
            ),
            SizedBox(
              width: cardWidth > 450 ? 450 : cardWidth,
              child: _buildSummaryCard(
                label: 'GST on Platform Fees',
                value: currencyFormat.format(_mockGSTData.totalGSTOnFees),
                subtitle:
                    'GST charged on service fees deducted by the platform',
                icon: Icons.receipt_long,
                isSecondary: true,
                isDarkMode: isDarkMode,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDisclaimer(bool isDarkMode) {
    return Container(
      constraints: BoxConstraints(maxWidth: 800),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2A2A2A) : AppColors.gray50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : AppColors.gray300,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : AppColors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.info_outline,
              size: 18,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.8)
                  : AppColors.blue,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'GST figures shown are informational estimates based on transactions processed through the platform. '
              'They do not account for GST credits, expenses, or other business activity. '
              'Please consult your accountant for your actual GST obligations.',
              style: AppTypography.bodySmall.copyWith(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.8)
                    : AppColors.gray700,
                fontSize: 12,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required String value,
    required String subtitle,
    required IconData icon,
    required bool isDarkMode,
    bool isSecondary = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2A2A2A) : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : AppColors.gray200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and label
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.05)
                  : AppColors.gray50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.08)
                    : AppColors.gray200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.9)
                      : AppColors.black,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 13,
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.9)
                          : AppColors.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Value
          Text(
            value,
            style: AppTypography.h2.copyWith(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              color: isDarkMode ? Colors.white : AppColors.black,
              height: 1.0,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Subtitle
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.05)
                  : AppColors.gray100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 11,
                color: isDarkMode
                    ? Colors.white.withOpacity(0.7)
                    : AppColors.gray700,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ========================================
// Backend-Ready Data Models
// ========================================

/// Backend-ready GST data model
/// Contains only observable, factual data - no calculations or advice
class _GSTData {
  final double totalGSTCollected; // GST in customer payments
  final double totalGSTOnFees; // GST on platform service fees

  _GSTData({required this.totalGSTCollected, required this.totalGSTOnFees});
}
