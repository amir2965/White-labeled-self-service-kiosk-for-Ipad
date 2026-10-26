import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import 'analytics_provider.dart';
import 'analytics_state.dart';
import 'theme_provider.dart';
import 'widgets/sales_summary_content_v2.dart';
import 'widgets/components/luxury_back_button.dart';
import 'gst_page.dart';
import 'service_fees_page.dart';
import 'payouts_content/balances_content.dart';
import 'payouts_content/activity_content.dart';
import '../../features/payouts/presentation/screens/transfer_settings_screen.dart';

/// Professional Analytics/Reports page for iPad
class AnalyticsPage extends ConsumerStatefulWidget {
  final String section;

  const AnalyticsPage({super.key, this.section = 'Sales Summary'});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  String? _expandedGroup;
  Timer? _refreshTimer;
  late String _activeSection;

  @override
  void initState() {
    super.initState();
    _activeSection = widget.section; // Initialize from route parameter
    // Start auto-refresh every 10 seconds for live sales data
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      ref.read(analyticsProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final analyticsState = ref.watch(analyticsProvider);
    final isDarkMode = ref.watch(themeModeProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Responsive sidebar width
    final sidebarWidth = isLandscape ? 300.0 : 280.0;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF1A1A1A) : AppColors.background,
      body: Row(
        children: [
          // Left Sidebar
          _buildSidebar(sidebarWidth),

          // Right Main Content Area
          Expanded(child: _buildMainContent(analyticsState)),
        ],
      ),
    );
  }

  /// Build left sidebar with navigation
  Widget _buildSidebar(double width) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade900 : Colors.white,
        border: isDarkMode
            ? null
            : Border(right: BorderSide(color: AppColors.gray300, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.15 : 0.03),
            blurRadius: isDarkMode ? 24 : 8,
            offset: Offset(isDarkMode ? 4 : 2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Business selector card
          Container(
            margin: EdgeInsets.fromLTRB(20, 24, 20, 20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.08)
                    : AppColors.gray300.withOpacity(0.5),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF007AFF), Color(0xFF0056B3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF007AFF).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.store_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Demo Café',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Main Location',
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.6)
                              : AppColors.gray600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.expand_more,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.6)
                      : AppColors.gray600,
                  size: 20,
                ),
              ],
            ),
          ),

          // Section title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              'REPORTS',
              style: TextStyle(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.5)
                    : AppColors.gray600,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),

          // Navigation menu groups
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 12),
              children: [
                // Sales Overview (Home)
                _buildModernMenuItem(
                  label: 'Sales Overview',
                  icon: Icons.insights_rounded,
                  isActive: _activeSection == 'Sales Summary',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    context.go('/analytics/sales');
                  },
                ),
                SizedBox(height: 8),

                // Separator
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Container(
                    height: 1,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.08)
                        : AppColors.gray300.withOpacity(0.5),
                  ),
                ),

                // Section: Accounting
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(
                    'ACCOUNTING',
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.4)
                          : AppColors.gray600.withOpacity(0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                _buildModernMenuItem(
                  label: 'GST Reports',
                  icon: Icons.receipt_long_rounded,
                  isActive: _activeSection == 'GST',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    context.go('/analytics/gst');
                  },
                ),
                SizedBox(height: 4),
                _buildModernMenuItem(
                  label: 'Service Fees',
                  icon: Icons.account_balance_wallet_rounded,
                  isActive: _activeSection == 'Service Fees',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    context.go('/analytics/service-fees');
                  },
                ),
                SizedBox(height: 8),

                // Separator
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Container(
                    height: 1,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.08)
                        : AppColors.gray300.withOpacity(0.5),
                  ),
                ),

                // Section: Payments
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(
                    'PAYMENTS',
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.4)
                          : AppColors.gray600.withOpacity(0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                _buildModernMenuItem(
                  label: 'Balances',
                  icon: Icons.account_balance_rounded,
                  isActive: _activeSection == 'Balances',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    context.go('/analytics/balances');
                  },
                ),
                SizedBox(height: 4),
                _buildModernMenuItem(
                  label: 'Activity',
                  icon: Icons.history_rounded,
                  isActive: _activeSection == 'Activity',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    context.go('/analytics/activity');
                  },
                ),
                SizedBox(height: 4),
                _buildModernMenuItem(
                  label: 'Transfer Settings',
                  icon: Icons.settings_rounded,
                  isActive: _activeSection == 'Transfer Settings',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    context.go('/analytics/transfer-settings');
                  },
                ),
              ],
            ),
          ),

          // Bottom shortcuts with theme toggle
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.08)
                      : AppColors.gray300.withOpacity(0.5),
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.08)
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                        border: isDarkMode
                            ? null
                            : Border.all(
                                color: AppColors.gray300.withOpacity(0.5),
                              ),
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.7)
                            : AppColors.gray900,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Notifications',
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.7)
                              : AppColors.gray900,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Modern minimal theme toggle icon
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          ref.read(themeModeProvider.notifier).toggleTheme();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return RotationTransition(
                                turns: animation,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  ),
                                ),
                              );
                            },
                            child: Icon(
                              isDarkMode
                                  ? Icons.dark_mode_rounded
                                  : Icons.light_mode_rounded,
                              key: ValueKey(isDarkMode),
                              size: 20,
                              color: isDarkMode
                                  ? Color(0xFFFFA500)
                                  : Color(0xFFFFB74D),
                              shadows: [
                                Shadow(
                                  color: isDarkMode
                                      ? Color(0xFFFFA500).withOpacity(0.5)
                                      : Color(0xFFFFB74D).withOpacity(0.5),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build menu group with expand/collapse
  Widget _buildMenuGroup(String title, IconData icon, List<_MenuRow> items) {
    final isExpanded = _expandedGroup == title;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _expandedGroup = isExpanded ? null : title;
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 10,
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.gray700),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray900,
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                  color: AppColors.gray600,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...items.map((item) => _buildSubMenuItem(item)),
        SizedBox(height: AppSpacing.xs),
      ],
    );
  }

  /// Build sub-menu item (no icon)
  Widget _buildSubMenuItem(_MenuRow item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: EdgeInsets.only(left: AppSpacing.md),
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
        decoration: BoxDecoration(
          color: item.isActive
              ? AppColors.gray900.withOpacity(0.87)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          item.label,
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 13,
            fontWeight: item.isActive ? FontWeight.w600 : FontWeight.w500,
            color: item.isActive ? AppColors.white : AppColors.gray700,
          ),
        ),
      ),
    );
  }

  /// Build individual menu item
  Widget _buildMenuItem(_MenuRow item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
        decoration: BoxDecoration(
          color: item.isActive
              ? AppColors.gray900.withOpacity(0.87)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.home_outlined,
              size: 18,
              color: item.isActive ? AppColors.white : AppColors.gray700,
            ),
            SizedBox(width: AppSpacing.sm),
            Text(
              item.label,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 14,
                fontWeight: item.isActive ? FontWeight.w600 : FontWeight.w500,
                color: item.isActive ? AppColors.white : AppColors.gray700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build modern menu item with luxury design
  Widget _buildModernMenuItem({
    required String label,
    required IconData icon,
    required bool isActive,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: isActive
              ? (isDarkMode
                    ? Colors.white.withOpacity(0.12)
                    : AppColors.gray900.withOpacity(0.05))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive
                ? (isDarkMode
                      ? Colors.white.withOpacity(0.15)
                      : AppColors.gray300)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isActive
                    ? Color(0xFF007AFF).withOpacity(0.2)
                    : (isDarkMode
                          ? Colors.white.withOpacity(0.06)
                          : AppColors.gray100),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isActive
                    ? Color(0xFF007AFF)
                    : (isDarkMode
                          ? Colors.white.withOpacity(0.7)
                          : AppColors.gray600),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? (isDarkMode ? Colors.white : AppColors.gray900)
                      : (isDarkMode
                            ? Colors.white.withOpacity(0.85)
                            : AppColors.gray700),
                  letterSpacing: -0.2,
                ),
              ),
            ),
            if (isActive)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Color(0xFF007AFF),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF007AFF).withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build main content area
  Widget _buildMainContent(AnalyticsState state) {
    print('📄 Building main content - activeSection: $_activeSection');
    final isDarkMode = ref.watch(themeModeProvider);

    // Show different content based on active section
    if (_activeSection == 'Sales Summary') {
      print('📊 Rendering SalesSummaryContentV2 (NEW VERSION)');
      return Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: SalesSummaryContentV2(),
          ),
          // Dashboard quick access button (bottom right)
          _buildDashboardQuickAccess(context, isDarkMode),
        ],
      );
    }

    if (_activeSection == 'GST') {
      print('🧾 Rendering GST Page');
      return Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                _buildSectionHeaderWithBackButton(
                  'GST Reports',
                  'Tax reporting and compliance',
                  isDarkMode,
                ),
                Expanded(child: GSTPage()),
              ],
            ),
          ),
          _buildDashboardQuickAccess(context, isDarkMode),
        ],
      );
    }

    if (_activeSection == 'Service Fees') {
      print('💳 Rendering Service Fees Page');
      return Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                _buildSectionHeaderWithBackButton(
                  'Service Fees',
                  'Processing fees and transaction costs',
                  isDarkMode,
                ),
                Expanded(child: ServiceFeesPage()),
              ],
            ),
          ),
          _buildDashboardQuickAccess(context, isDarkMode),
        ],
      );
    }

    if (_activeSection == 'Balances') {
      print('💰 Rendering Balances Page');
      return Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: isDarkMode ? Color(0xFF1A1A1A) : Colors.grey.shade50,
            child: Column(
              children: [
                _buildSectionHeaderWithBackButton(
                  'Balances',
                  'View and manage your account balance',
                  isDarkMode,
                ),
                Expanded(child: BalancesContent()),
              ],
            ),
          ),
          _buildDashboardQuickAccess(context, isDarkMode),
        ],
      );
    }

    if (_activeSection == 'Activity') {
      print('📋 Rendering Activity Page');
      return Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: isDarkMode ? Color(0xFF1A1A1A) : Colors.grey.shade50,
            child: Column(
              children: [
                _buildSectionHeaderWithBackButton(
                  'Activity',
                  'View transfer history and export reports',
                  isDarkMode,
                ),
                Expanded(child: ActivityContent()),
              ],
            ),
          ),
          _buildDashboardQuickAccess(context, isDarkMode),
        ],
      );
    }

    if (_activeSection == 'Transfer Settings') {
      print('⚙️ Rendering Transfer Settings Page');
      return Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: isDarkMode ? Color(0xFF1A1A1A) : Colors.grey.shade50,
            child: Column(
              children: [
                _buildSectionHeaderWithBackButton(
                  'Transfer Settings',
                  'Configure instant transfers and bank accounts',
                  isDarkMode,
                ),
                Expanded(child: TransferSettingsScreen()),
              ],
            ),
          ),
          _buildDashboardQuickAccess(context, isDarkMode),
        ],
      );
    }

    // Default: Show Sales Summary (new home)
    print('🏠 Defaulting to Sales Summary as home');
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: SalesSummaryContentV2(),
        ),
        _buildDashboardQuickAccess(context, isDarkMode),
      ],
    );
  }

  /// Build section header with luxury back button
  Widget _buildSectionHeaderWithBackButton(
    String title,
    String subtitle,
    bool isDarkMode,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2A2A2A) : AppColors.white,
        border: Border(
          bottom: BorderSide(
            color: isDarkMode
                ? Colors.white.withOpacity(0.08)
                : AppColors.gray300.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          // Luxury back button
          LuxuryBackButton(
            onPressed: () {
              context.go('/analytics/sales');
            },
            isDarkMode: isDarkMode,
            showLabel: true,
            label: 'Sales Overview',
          ),

          const SizedBox(width: 20),

          // Section title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.h1.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.6)
                        : AppColors.gray600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build dashboard quick access floating button
  Widget _buildDashboardQuickAccess(BuildContext context, bool isDarkMode) {
    return Positioned(
      bottom: 12,
      right: 24,
      child: DashboardSlideAccess(
        onUnlocked: () {
          // Navigate to dashboard when slide-and-hold completes
          context.go('/dashboard');
        },
        isDarkMode: isDarkMode,
      ),
    );
  }

  /// Build section header for Payouts screens
  Widget _buildSectionHeader(String title, String subtitle) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2A2A2A) : AppColors.white,
        border: Border(
          bottom: BorderSide(
            color: isDarkMode
                ? Colors.white.withOpacity(0.08)
                : AppColors.gray300.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.h1.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.6)
                        : AppColors.gray600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build performance card with KPIs
  Widget _buildPerformanceCard(AnalyticsState state) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray300.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Performance',
                      style: AppTypography.h2.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: AppColors.gray600,
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),

                // Filter pills
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _buildFilterPill(
                      label:
                          'Date | ${DateFormat('d MMM').format(state.selectedDate)}',
                      onTap: () => _showDatePicker(state.selectedDate),
                    ),
                    _buildFilterPill(
                      label: state.compareMode.label,
                      onTap: () => _showCompareModeSelector(state.compareMode),
                    ),
                    _buildFilterPill(
                      label: state.billStatus.label,
                      onTap: () => _showBillStatusSelector(state.billStatus),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1, color: AppColors.gray300.withOpacity(0.5)),

          // Main metrics area (no scrolling, fits in one view)
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Net sales row
                  Row(
                    children: [
                      Text(
                        'Net sales',
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 13,
                          color: AppColors.gray700,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        '\$${state.values.netSales.toStringAsFixed(2)}',
                        style: AppTypography.h1.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      _buildDeltaChip(state.values.netSalesDelta ?? 'N/A'),
                    ],
                  ),

                  SizedBox(height: 12),

                  // Empty state / Chart area
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'No data available for selected timeframe',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.gray600,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Timeline axis
                        _buildTimeline(state),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // KPI Grid
                  Expanded(child: _buildKPIGrid(state.values)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build filter pill button
  Widget _buildFilterPill({
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 36,
          padding: EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.gray300.withOpacity(0.8)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray900,
                ),
              ),
              SizedBox(width: 6),
              Icon(Icons.expand_more, size: 16, color: AppColors.gray700),
            ],
          ),
        ),
      ),
    );
  }

  /// Build delta chip
  Widget _buildDeltaChip(String delta) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.gray300.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('▲', style: TextStyle(fontSize: 10, color: AppColors.gray700)),
          SizedBox(width: 4),
          Text(
            delta,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.gray700,
            ),
          ),
        ],
      ),
    );
  }

  /// Build timeline axis
  Widget _buildTimeline(AnalyticsState state) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    return Column(
      children: [
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.blue,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6),
            Text(
              'Today',
              style: AppTypography.bodySmall.copyWith(
                fontSize: 12,
                color: AppColors.gray700,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.gray400,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6),
            Text(
              '${DateFormat('E, d MMM y').format(yesterday)}',
              style: AppTypography.bodySmall.copyWith(
                fontSize: 12,
                color: AppColors.gray700,
              ),
            ),
          ],
        ),

        SizedBox(height: AppSpacing.md),

        // Time labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['8am', '9am', '10am', '11am', '12pm', '1pm', '2pm'].map((
            time,
          ) {
            return Text(
              time,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 11,
                color: AppColors.gray600,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Build KPI grid
  Widget _buildKPIGrid(AnalyticsValues values) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildKPIRow(
                'Gross sales',
                '\$${values.grossSales.toStringAsFixed(2)}',
                values.grossSalesDelta ?? 'N/A',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildKPIRow(
                'Transactions',
                '${values.transactions}',
                values.transactionsDelta ?? 'N/A',
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildKPIRow(
                'Labour % of net sales',
                '${values.labourPercent.toStringAsFixed(2)}%',
                values.labourPercentDelta ?? 'N/A',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildKPIRow(
                'Average sale',
                '\$${values.avgSale.toStringAsFixed(2)}',
                values.avgSaleDelta ?? 'N/A',
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildKPIRow(
                'Comps & discounts',
                '\$${values.compsDiscounts.toStringAsFixed(2)}',
                values.compsDiscountsDelta ?? 'N/A',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildKPIRow(
                'Tips',
                '\$${values.tips.toStringAsFixed(2)}',
                values.tipsDelta ?? 'N/A',
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build individual KPI row
  Widget _buildKPIRow(String label, String value, String delta) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gray300.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: AppColors.gray600,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  value,
                  style: AppTypography.bodyLarge.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray900,
                  ),
                ),
              ],
            ),
          ),
          _buildDeltaChip(delta),
        ],
      ),
    );
  }

  /// Show date picker
  void _showDatePicker(DateTime currentDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      ref.read(analyticsProvider.notifier).setDate(picked);
    }
  }

  /// Show compare mode selector
  void _showCompareModeSelector(CompareMode current) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: CompareMode.values.map((mode) {
            return ListTile(
              title: Text(mode.label),
              selected: mode == current,
              onTap: () {
                ref.read(analyticsProvider.notifier).setCompareMode(mode);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  /// Show bill status selector
  void _showBillStatusSelector(BillStatus current) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: BillStatus.values.map((status) {
            return ListTile(
              title: Text(status.label),
              selected: status == current,
              onTap: () {
                ref.read(analyticsProvider.notifier).setBillStatus(status);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}

/// Menu row data class
class _MenuRow {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  _MenuRow({required this.label, this.isActive = false, this.onTap});
}
