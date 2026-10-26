import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../providers/menu_provider.dart';
import '../../providers/sales_provider.dart';
import '../../kiosk/template_selector_screen.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/status_card.dart';
import 'widgets/launch_kiosk_card.dart';
import 'widgets/metrics_overview.dart';
import 'widgets/admin_action_grid.dart';

/// Nexus Command Dashboard - Merchant Control Center
/// Enterprise-grade dashboard for kiosk management
class MerchantDashboardScreen extends ConsumerStatefulWidget {
  const MerchantDashboardScreen({super.key});

  @override
  ConsumerState<MerchantDashboardScreen> createState() =>
      _MerchantDashboardScreenState();
}

class _MerchantDashboardScreenState
    extends ConsumerState<MerchantDashboardScreen>
    with WidgetsBindingObserver {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Ensure demo data is loaded and fetch latest sales
    Future.microtask(() {
      final menuState = ref.read(menuProvider);
      if (menuState.categories.isEmpty) {
        ref.read(menuProvider.notifier).seedDemoMenu('cafe');
      }

      // Immediately fetch sales data when dashboard loads
      ref.read(salesProvider.notifier).refresh();

      // Start auto-refresh for sales data every 10 seconds
      _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
        ref.read(salesProvider.notifier).refresh();
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Refresh data when app resumes
    if (state == AppLifecycleState.resumed) {
      ref.read(salesProvider.notifier).refresh();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    final maxWidth = isLandscape ? 1400.0 : 800.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      AppSpacing.xl,
                      AppSpacing.xl,
                      AppSpacing.lg,
                    ),
                    child: const DashboardHeader(),
                  ),
                ),

                // Main Content Grid
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  sliver: SliverToBoxAdapter(
                    child: _buildResponsiveGrid(context, isLandscape),
                  ),
                ),

                // Bottom Spacing
                SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveGrid(BuildContext context, bool isLandscape) {
    if (isLandscape) {
      return _buildLandscapeLayout(context);
    } else {
      return _buildPortraitLayout(context);
    }
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row: Status + Launch
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: StatusCard(
                onViewDetails: () => _showSystemDetails(context),
              ),
            ),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              flex: 1,
              child: LaunchKioskCard(onLaunch: () => _launchKioskMode(context)),
            ),
          ],
        ),

        SizedBox(height: AppSpacing.lg),

        // Metrics Overview
        const MetricsOverview(),

        SizedBox(height: AppSpacing.lg),

        // Admin Actions Grid
        AdminActionGrid(
          onNavigate: (route) => _handleNavigation(context, route),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Launch Button (Priority in Portrait)
        LaunchKioskCard(onLaunch: () => _launchKioskMode(context)),

        SizedBox(height: AppSpacing.lg),

        // Status
        StatusCard(onViewDetails: () => _showSystemDetails(context)),

        SizedBox(height: AppSpacing.lg),

        // Metrics
        const MetricsOverview(),

        SizedBox(height: AppSpacing.lg),

        // Admin Actions
        AdminActionGrid(
          onNavigate: (route) => _handleNavigation(context, route),
        ),
      ],
    );
  }

  void _launchKioskMode(BuildContext context) {
    // Navigate to kiosk mode
    context.go('/kiosk');
  }

  void _handleNavigation(BuildContext context, String route) {
    switch (route) {
      case 'menu':
        context.push('/menu-management');
        break;
      case 'settings':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const TemplateSelectorScreen(fromDashboard: true),
          ),
        );
        break;
      case 'orders':
        context.go('/kitchen');
        break;
      case 'devices':
        _showComingSoon(context, 'Device Management');
        break;
      case 'branding':
        context.go('/branding');
        break;
      case 'analytics':
        context.go('/analytics/sales');
        break;
    }
  }

  void _showSystemDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('System Status', style: AppTypography.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusRow('Kiosk Connection', 'Active', Colors.green),
            SizedBox(height: AppSpacing.sm),
            _buildStatusRow('Payment Gateway', 'Connected', Colors.green),
            SizedBox(height: AppSpacing.sm),
            _buildStatusRow('Menu Sync', 'Up to date', Colors.green),
            SizedBox(height: AppSpacing.sm),
            _buildStatusRow('Last Updated', 'Just now', AppColors.gray600),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyMedium),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: AppSpacing.xs),
            Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
