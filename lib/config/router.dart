import 'package:go_router/go_router.dart';
import '../presentation/auth/welcome_screen.dart';
import '../presentation/auth/signup_screen.dart';
import '../presentation/onboarding/onboarding_screen.dart';
import '../presentation/kiosk/kiosk_welcome_screen.dart';
import '../presentation/kiosk/kiosk_menu_screen.dart';
import '../presentation/kiosk/menu_template_config.dart';
import '../presentation/merchant/dashboard/merchant_dashboard_screen.dart';
import '../presentation/kiosk/template_selector_screen.dart';
import '../presentation/menu_management/menu_management_screen.dart';
import '../presentation/branding/branding_management_screen.dart';
import '../presentation/analytics/analytics_page.dart';
import '../presentation/kitchen/kitchen_display_screen.dart';
import '../features/payouts/presentation/screens/balances_screen.dart';
import '../features/payouts/presentation/screens/activity_screen.dart';
import '../features/payouts/presentation/screens/transfer_settings_screen.dart';
import '../features/payouts/presentation/screens/settlement_details_screen.dart';

/// Application route table (shared by the production router and the web demo)
final List<RouteBase> appRoutes = [
    // Auth routes
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: WelcomeScreen()),
    ),
    GoRoute(
      path: '/signup',
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: SignupScreen()),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: OnboardingScreen()),
    ),

    // Dashboard / Overview
    GoRoute(
      path: '/dashboard',
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const MerchantDashboardScreen(),
      ),
    ),
    GoRoute(
      path: '/overview',
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const MerchantDashboardScreen(),
      ),
    ),

    // Template and Menu Management
    GoRoute(
      path: '/template-selector',
      pageBuilder: (context, state) {
        final fromDashboard = state.extra as bool? ?? false;
        return NoTransitionPage(
          key: state.pageKey,
          child: TemplateSelectorScreen(fromDashboard: fromDashboard),
        );
      },
    ),
    GoRoute(
      path: '/menu-management',
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const MenuManagementScreen(),
      ),
    ),
    GoRoute(
      path: '/branding',
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const BrandingManagementScreen(),
      ),
    ),

    // Analytics routes
    GoRoute(
      path: '/analytics',
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const AnalyticsPage(section: 'Sales Summary'),
      ),
    ),
    GoRoute(
      path: '/analytics/sales',
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const AnalyticsPage(section: 'Sales Summary'),
      ),
    ),
    GoRoute(
      path: '/analytics/gst',
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const AnalyticsPage(section: 'GST'),
      ),
    ),
    GoRoute(
      path: '/analytics/service-fees',
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const AnalyticsPage(section: 'Service Fees'),
      ),
    ),
    GoRoute(
      path: '/analytics/balances',
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const AnalyticsPage(section: 'Balances'),
      ),
    ),
    GoRoute(
      path: '/analytics/activity',
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const AnalyticsPage(section: 'Activity'),
      ),
    ),
    GoRoute(
      path: '/analytics/transfer-settings',
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const AnalyticsPage(section: 'Transfer Settings'),
      ),
    ),

    // Kiosk routes
    GoRoute(
      path: '/kiosk',
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const KioskWelcomeScreen(),
      ),
    ),
    GoRoute(
      path: '/menu',
      pageBuilder: (context, state) {
        final template =
            state.extra as MenuDisplayTemplate? ??
            MenuDisplayTemplate.categorySidebar;
        return NoTransitionPage(
          key: state.pageKey,
          child: KioskMenuScreen(template: template),
        );
      },
    ),

    // Payouts routes
    GoRoute(
      path: '/payouts/balances',
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: const BalancesScreen()),
    ),
    GoRoute(
      path: '/payouts/activity',
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: const ActivityScreen()),
    ),
    GoRoute(
      path: '/payouts/settings',
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const TransferSettingsScreen(),
      ),
    ),
    GoRoute(
      path: '/payouts/settlement/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoTransitionPage(
          key: state.pageKey,
          child: SettlementDetailsScreen(settlementId: id),
        );
      },
    ),

    // Kitchen Display System
    GoRoute(
      path: '/kitchen',
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const KitchenDisplayScreen(),
      ),
    ),
];

/// Application router configuration
final appRouter = GoRouter(initialLocation: '/dashboard', routes: appRoutes);
