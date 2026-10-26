import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import 'theme_provider.dart';
import 'models/fee_models.dart';
import 'providers/service_fees_provider.dart';
import 'widgets/components/custom_single_date_picker.dart';

/// **Service Fees Page**
///
/// Purpose: Build merchant trust through transparency
/// Design: calm, minimal, semi-luxury, enterprise-grade
///
/// This page provides:
/// - Clear overview of platform fees
/// - Transparent fee breakdown
/// - Detailed transaction table
/// - Context and explanation
///
/// Terminology: NEVER "commission", ALWAYS "Platform Fee" or "Service Fee"
class ServiceFeesPage extends ConsumerStatefulWidget {
  const ServiceFeesPage({super.key});

  @override
  ConsumerState<ServiceFeesPage> createState() => _ServiceFeesPageState();
}

class _ServiceFeesPageState extends ConsumerState<ServiceFeesPage> {
  late DateTime _selectedDate; // Currently selected date for transaction view
  int _currentPage = 1; // Current pagination page
  static const int _transactionsPerPage = 10; // Transactions per page
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Default to today
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goToPreviousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
      _currentPage = 1; // Reset pagination
    });
  }

  void _goToNextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
      _currentPage = 1; // Reset pagination
    });
  }

  void _goToToday() {
    setState(() {
      final now = DateTime.now();
      _selectedDate = DateTime(now.year, now.month, now.day);
      _currentPage = 1;
    });
  }

  void _goToYesterday() {
    setState(() {
      final now = DateTime.now();
      _selectedDate = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 1));
      _currentPage = 1;
    });
  }

  void _changePage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _openDatePicker() async {
    final now = DateTime.now();
    final picked = await showCustomSingleDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020, 1, 1),
      lastDate: now,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
        _currentPage = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final feesAsync = ref.watch(serviceFeesProvider);
    final isDarkMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF1A1A1A) : AppColors.gray50,
      body: feesAsync.when(
        data: (data) => _ServiceFeesContent(
          data: data,
          selectedDate: _selectedDate,
          currentPage: _currentPage,
          transactionsPerPage: _transactionsPerPage,
          searchQuery: _searchQuery,
          searchController: _searchController,
          isDarkMode: isDarkMode,
          onSearchChanged: (query) {
            setState(() {
              _searchQuery = query;
              _currentPage = 1; // Reset pagination on search
            });
          },
          onPreviousDay: _goToPreviousDay,
          onNextDay: _goToNextDay,
          onToday: _goToToday,
          onYesterday: _goToYesterday,
          onPageChanged: _changePage,
          onOpenDatePicker: _openDatePicker,
        ),
        loading: () => Center(
          child: CircularProgressIndicator(
            color: AppColors.blue,
            strokeWidth: 2,
          ),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Unable to load service fees data',
            style: AppTypography.bodyMedium.copyWith(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.7)
                  : AppColors.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceFeesContent extends StatelessWidget {
  final ServiceFeesData data;
  final DateTime selectedDate;
  final int currentPage;
  final int transactionsPerPage;
  final String searchQuery;
  final TextEditingController searchController;
  final bool isDarkMode;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final VoidCallback onToday;
  final VoidCallback onYesterday;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onOpenDatePicker;

  const _ServiceFeesContent({
    required this.data,
    required this.selectedDate,
    required this.currentPage,
    required this.transactionsPerPage,
    required this.searchQuery,
    required this.searchController,
    required this.isDarkMode,
    required this.onSearchChanged,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onToday,
    required this.onYesterday,
    required this.onPageChanged,
    required this.onOpenDatePicker,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 200),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPaddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: AppSpacing.xxl),

            // Summary Cards
            _buildSummaryCards(),
            const SizedBox(height: AppSpacing.sectionSpacing),

            // Fee Breakdown
            _buildFeeBreakdown(),
            const SizedBox(height: AppSpacing.sectionSpacing),

            // Transaction History Title
            _buildTransactionHistoryTitle(),
            const SizedBox(height: AppSpacing.lg),

            // Date Navigation
            _buildDateNavigation(),
            const SizedBox(height: AppSpacing.lg),

            // Single Day Transaction Container (Portrait)
            _buildSingleDayTransactionContainer(),
            const SizedBox(height: AppSpacing.sectionSpacing),

            // Context Note
            _buildContextNote(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Fees',
          style: AppTypography.h1.copyWith(
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Overview of platform fees deducted from transactions processed through the platform.',
          style: AppTypography.bodyMedium.copyWith(
            color: isDarkMode
                ? Colors.white.withOpacity(0.7)
                : AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Determine layout based on width
        // Large screens (>1000px): 3 columns
        // Medium screens (700-1000px): 2 columns + 1 full width
        // Small screens (<700px): 1 column

        if (width > 1000) {
          // 3-column grid for large screens
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ModernSummaryCard(
                  icon: Icons.payments_outlined,
                  iconColor: AppColors.blue,
                  label: 'Total Service Fees',
                  value: _formatCurrency(data.summary.totalServiceFees),
                  subtitle: 'Fees deducted',
                  accentColor: AppColors.blue.withOpacity(0.1),
                  isDarkMode: isDarkMode,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: _ModernSummaryCard(
                  icon: Icons.percent,
                  iconColor: Color(0xFF34C759),
                  label: 'Average Fee Rate',
                  value: _formatPercent(data.summary.averageFeePercent),
                  subtitle: 'Per transaction',
                  accentColor: Color(0xFF34C759).withOpacity(0.1),
                  isDarkMode: isDarkMode,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: _ModernSummaryCard(
                  icon: Icons.trending_up,
                  iconColor: Color(0xFFFF9500),
                  label: 'Effective Rate',
                  value: _formatPercent(data.summary.effectiveFeeRate),
                  subtitle: 'Of total sales',
                  accentColor: Color(0xFFFF9500).withOpacity(0.1),
                  isDarkMode: isDarkMode,
                ),
              ),
            ],
          );
        } else if (width > 700) {
          // 2+1 layout for medium screens
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _ModernSummaryCard(
                      icon: Icons.payments_outlined,
                      iconColor: AppColors.blue,
                      label: 'Total Service Fees',
                      value: _formatCurrency(data.summary.totalServiceFees),
                      subtitle: 'Fees deducted',
                      accentColor: AppColors.blue.withOpacity(0.1),
                      isDarkMode: isDarkMode,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: _ModernSummaryCard(
                      icon: Icons.percent,
                      iconColor: Color(0xFF34C759),
                      label: 'Average Fee Rate',
                      value: _formatPercent(data.summary.averageFeePercent),
                      subtitle: 'Per transaction',
                      accentColor: Color(0xFF34C759).withOpacity(0.1),
                      isDarkMode: isDarkMode,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _ModernSummaryCard(
                icon: Icons.trending_up,
                iconColor: Color(0xFFFF9500),
                label: 'Effective Rate',
                value: _formatPercent(data.summary.effectiveFeeRate),
                subtitle: 'Of total sales',
                accentColor: Color(0xFFFF9500).withOpacity(0.1),
                isDarkMode: isDarkMode,
              ),
            ],
          );
        } else {
          // Single column for small screens
          return Column(
            children: [
              _ModernSummaryCard(
                icon: Icons.payments_outlined,
                iconColor: AppColors.blue,
                label: 'Total Service Fees',
                value: _formatCurrency(data.summary.totalServiceFees),
                subtitle: 'Fees deducted',
                accentColor: AppColors.blue.withOpacity(0.1),
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: AppSpacing.lg),
              _ModernSummaryCard(
                icon: Icons.percent,
                iconColor: Color(0xFF34C759),
                label: 'Average Fee Rate',
                value: _formatPercent(data.summary.averageFeePercent),
                subtitle: 'Per transaction',
                accentColor: Color(0xFF34C759).withOpacity(0.1),
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: AppSpacing.lg),
              _ModernSummaryCard(
                icon: Icons.trending_up,
                iconColor: Color(0xFFFF9500),
                label: 'Effective Rate',
                value: _formatPercent(data.summary.effectiveFeeRate),
                subtitle: 'Of total sales',
                accentColor: Color(0xFFFF9500).withOpacity(0.1),
                isDarkMode: isDarkMode,
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildFeeBreakdown() {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2A2A2A) : AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.15)
              : AppColors.gray200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(isDarkMode ? 0.4 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Gross Sales
          _buildBreakdownRow(
            label: 'Gross Sales',
            value: _formatCurrency(data.breakdown.grossSales),
            isTotal: false,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Platform Fee
          _buildBreakdownRow(
            label:
                'Platform Fee (${_formatPercent(data.breakdown.feePercent)})',
            value: '− ${_formatCurrency(data.breakdown.platformFee)}',
            isTotal: false,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Divider
          Container(
            height: 1,
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : AppColors.gray300.withOpacity(0.6),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Net Before GST
          _buildBreakdownRow(
            label: 'Net Before GST',
            value: _formatCurrency(data.breakdown.netBeforeGst),
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow({
    required String label,
    required String value,
    required bool isTotal,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTypography.h4.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black87,
                )
              : AppTypography.bodyLarge.copyWith(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.7)
                      : AppColors.textSecondary,
                ),
        ),
        Text(
          value,
          style: isTotal
              ? AppTypography.priceLarge.copyWith(
                  fontSize: 32,
                  color: isDarkMode ? Colors.white : Colors.black87,
                )
              : AppTypography.price.copyWith(
                  fontSize: 28,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
        ),
      ],
    );
  }

  /// Transaction History Title Section
  Widget _buildTransactionHistoryTitle() {
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
              'Transaction History',
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
            'View detailed transaction records by date',
            style: AppTypography.bodyMedium.copyWith(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.6)
                  : AppColors.gray600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  /// Date Navigation Widget - Select day and navigate
  Widget _buildDateNavigation() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final isToday = selectedDate == today;
    final isYesterday = selectedDate == yesterday;
    final isFuture = selectedDate.isAfter(today);

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2A2A2A) : AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.15)
              : AppColors.gray200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(isDarkMode ? 0.4 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Quick selectors
          _QuickDateButton(
            label: 'Today',
            isSelected: isToday,
            onTap: onToday,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(width: AppSpacing.sm),
          _QuickDateButton(
            label: 'Yesterday',
            isSelected: isYesterday,
            onTap: onYesterday,
            isDarkMode: isDarkMode,
          ),

          const Spacer(),

          // Date display with navigation
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Previous day
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: onPreviousDay,
                color: isDarkMode
                    ? Colors.white.withOpacity(0.7)
                    : AppColors.gray700,
                iconSize: 24,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),

              // Current date display (clickable for calendar)
              Material(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.05)
                    : AppColors.gray50,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                child: InkWell(
                  onTap: onOpenDatePicker,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatDateDisplay(selectedDate),
                          style: AppTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: AppColors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Next day (disabled if future)
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: isFuture ? null : onNextDay,
                color: isFuture
                    ? (isDarkMode
                          ? Colors.white.withOpacity(0.2)
                          : AppColors.gray300)
                    : (isDarkMode
                          ? Colors.white.withOpacity(0.7)
                          : AppColors.gray700),
                iconSize: 24,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Single Day Transaction Container - portrait-oriented, showing only selected date
  Widget _buildSingleDayTransactionContainer() {
    // Filter transactions for selected date only
    final selectedDateOnly = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    var dayTransactions = data.transactions.where((t) {
      final tDate = DateTime(t.date.year, t.date.month, t.date.day);
      return tDate == selectedDateOnly;
    }).toList();

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      dayTransactions = dayTransactions.where((t) {
        return t.orderId.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Sort by time (most recent first)
    dayTransactions.sort((a, b) => b.date.compareTo(a.date));

    // Calculate daily totals
    final dailyGross = dayTransactions.fold<double>(
      0.0,
      (sum, t) => sum + t.grossAmount,
    );
    final dailyFees = dayTransactions.fold<double>(
      0.0,
      (sum, t) => sum + t.serviceFee,
    );

    // Pagination logic
    final totalTransactions = dayTransactions.length;
    final totalPages = (totalTransactions / transactionsPerPage).ceil();
    final startIndex = (currentPage - 1) * transactionsPerPage;
    final endIndex = (startIndex + transactionsPerPage).clamp(
      0,
      totalTransactions,
    );
    final paginatedTransactions = totalTransactions > 0
        ? dayTransactions.sublist(startIndex, endIndex)
        : <FeeTransaction>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        _buildSearchBar(),
        const SizedBox(height: AppSpacing.lg),

        // Transaction statement container
        Container(
          constraints: const BoxConstraints(
            minHeight: 400, // Portrait-oriented minimum height
          ),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Color(0xFF1A1A1A)
                : AppColors.gray50.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.15)
                  : AppColors.gray200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(isDarkMode ? 0.4 : 0.02),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Daily summary header
              _buildDailySummary(totalTransactions, dailyGross, dailyFees),

              // Transaction list
              if (paginatedTransactions.isEmpty)
                _buildEmptyState()
              else
                ..._buildTransactionRows(paginatedTransactions),

              // Pagination
              if (totalPages > 1) _buildPagination(totalPages),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2A2A2A) : AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.15)
              : AppColors.gray200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(isDarkMode ? 0.4 : 0.02),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: isDarkMode
                ? Colors.white.withOpacity(0.5)
                : AppColors.gray500,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search by Order ID...',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.4)
                      : AppColors.textTertiary,
                ),
                filled: true,
                fillColor: isDarkMode ? Color(0xFF2A2A2A) : AppColors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : AppColors.gray200.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDarkMode
                        ? AppColors.blue.withOpacity(0.5)
                        : AppColors.blue,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
              ),
              style: AppTypography.bodyMedium.copyWith(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          if (searchQuery.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.clear,
                size: 20,
                color: isDarkMode
                    ? Colors.white.withOpacity(0.5)
                    : AppColors.gray500,
              ),
              onPressed: () {
                searchController.clear();
                onSearchChanged('');
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
        ],
      ),
    );
  }

  /// Daily summary section at top of transaction container
  Widget _buildDailySummary(int count, double gross, double fees) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Color(0xFF2A2A2A).withOpacity(0.8)
            : AppColors.white.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusXl),
          topRight: Radius.circular(AppSpacing.radiusXl),
        ),
        border: Border(
          bottom: BorderSide(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : AppColors.gray200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily Summary',
                style: AppTypography.label.copyWith(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.6)
                      : AppColors.gray600,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$count transaction${count != 1 ? 's' : ''}',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.9)
                      : AppColors.gray700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatCurrency(gross),
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: isDarkMode ? Colors.white : AppColors.black,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${_formatCurrency(fees)} fee',
                style: AppTypography.bodySmall.copyWith(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.6)
                      : AppColors.gray600,
                  fontSize: 13,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Transaction rows - simplified, scannable
  List<Widget> _buildTransactionRows(List<FeeTransaction> transactions) {
    return transactions.map((transaction) {
      return Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? Color(0xFF2A2A2A).withOpacity(0.6)
              : AppColors.white.withOpacity(0.6),
          border: Border(
            bottom: BorderSide(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.05)
                  : AppColors.gray200.withOpacity(0.5),
              width: 0.5,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            // Time
            SizedBox(
              width: 70,
              child: Text(
                _formatTime(transaction.date),
                style: AppTypography.bodySmall.copyWith(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.5)
                      : AppColors.gray500,
                  fontSize: 13,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Order ID
            Expanded(
              flex: 2,
              child: Text(
                transaction.orderId,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.9)
                      : AppColors.gray800,
                  fontSize: 14,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.lg),

            // Descriptor (payment type)
            Expanded(
              flex: 1,
              child: Text(
                'QR Payment', // TODO: Add payment type to transaction model
                style: AppTypography.bodySmall.copyWith(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.6)
                      : AppColors.gray600,
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.lg),

            // Amount (right-aligned, primary emphasis)
            SizedBox(
              width: 100,
              child: Text(
                _formatCurrency(transaction.grossAmount),
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : AppColors.black,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  /// Pagination controls
  Widget _buildPagination(int totalPages) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Color(0xFF2A2A2A).withOpacity(0.8)
            : AppColors.white.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppSpacing.radiusXl),
          bottomRight: Radius.circular(AppSpacing.radiusXl),
        ),
        border: Border(
          top: BorderSide(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : AppColors.gray200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous button
          _PaginationButton(
            icon: Icons.chevron_left,
            onPressed: currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
            isDarkMode: isDarkMode,
          ),

          const SizedBox(width: AppSpacing.md),

          // Page numbers
          ...List.generate(totalPages, (index) {
            final page = index + 1;
            final isCurrentPage = page == currentPage;

            // Show first, last, current, and adjacent pages
            final shouldShow =
                page == 1 ||
                page == totalPages ||
                (page >= currentPage - 1 && page <= currentPage + 1);

            if (!shouldShow) {
              // Show ellipsis once
              if (page == currentPage - 2 || page == currentPage + 2) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '...',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _PageNumberButton(
                page: page,
                isSelected: isCurrentPage,
                onPressed: () => onPageChanged(page),
                isDarkMode: isDarkMode,
              ),
            );
          }),

          const SizedBox(width: AppSpacing.md),

          // Next button
          _PaginationButton(
            icon: Icons.chevron_right,
            onPressed: currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl * 2),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.3)
                  : AppColors.gray400,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No transactions',
              style: AppTypography.h4.copyWith(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.7)
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              searchQuery.isEmpty
                  ? 'No transactions on this date'
                  : 'No matching results',
              style: AppTypography.bodyMedium.copyWith(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.5)
                    : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextNote() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Color(0xFF2A2A2A).withOpacity(0.6)
            : AppColors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : AppColors.gray300.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color: isDarkMode
                ? Colors.white.withOpacity(0.6)
                : AppColors.gray600,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Fees are calculated consistently based on your pricing plan and transaction volume.',
              style: AppTypography.bodySmall.copyWith(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.7)
                    : AppColors.gray700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateDisplay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('EEEE, MMM d, y').format(date);
    }
  }

  String _formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return formatter.format(amount);
  }

  String _formatPercent(double percent) {
    return '${percent.toStringAsFixed(2)}%';
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('MMM d, y');
    return formatter.format(date);
  }
}

/// Modern summary card with icon, accent color, and professional layout
class _ModernSummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String subtitle;
  final Color accentColor;
  final bool isDarkMode;

  const _ModernSummaryCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.accentColor,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2A2A2A) : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.15)
              : AppColors.gray200.withOpacity(0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(isDarkMode ? 0.4 : 0.02),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top section with icon and label
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accentColor, accentColor.withOpacity(0.3)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Icon with background
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                // Label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.8)
                              : AppColors.gray800,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTypography.caption.copyWith(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.6)
                              : AppColors.gray600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Value section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTypography.priceLarge.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                    height: 1.1,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Quick date selector button (Today / Yesterday)
class _QuickDateButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDarkMode;

  const _QuickDateButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? AppColors.blue
          : (isDarkMode ? Colors.white.withOpacity(0.05) : AppColors.gray50),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? AppColors.white
                  : (isDarkMode
                        ? Colors.white.withOpacity(0.7)
                        : AppColors.gray700),
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

/// Pagination arrow button
class _PaginationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isDarkMode;

  const _PaginationButton({
    required this.icon,
    required this.onPressed,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    return Material(
      color: isEnabled
          ? (isDarkMode ? Colors.white.withOpacity(0.05) : AppColors.gray50)
          : (isDarkMode ? Colors.white.withOpacity(0.02) : AppColors.gray100),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 20,
            color: isEnabled
                ? (isDarkMode
                      ? Colors.white.withOpacity(0.7)
                      : AppColors.gray700)
                : (isDarkMode
                      ? Colors.white.withOpacity(0.2)
                      : AppColors.gray400),
          ),
        ),
      ),
    );
  }
}

/// Page number button
class _PageNumberButton extends StatelessWidget {
  final int page;
  final bool isSelected;
  final VoidCallback onPressed;
  final bool isDarkMode;

  const _PageNumberButton({
    required this.page,
    required this.isSelected,
    required this.onPressed,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? AppColors.blue
          : (isDarkMode ? Colors.transparent : Colors.transparent),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Text(
            page.toString(),
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? AppColors.white
                  : (isDarkMode
                        ? Colors.white.withOpacity(0.7)
                        : AppColors.gray700),
              fontSize: 14,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
  }
}
