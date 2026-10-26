import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/router.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../presentation/branding/models/branding_settings.dart';
import '../presentation/branding/models/welcome_template_config.dart';
import '../presentation/branding/providers/branding_provider.dart';
import '../presentation/providers/cart_provider.dart';
import '../presentation/providers/menu_provider.dart';
import 'demo_config.dart';
import 'menu_scan_demo_screen.dart';

/// Branding used by the demo kiosk (the app itself starts with a blank brand).
BrandingSettings demoBranding() => BrandingSettings(
  welcomeTemplate: WelcomePageTemplate.fullScreenImage,
  businessName: 'Demo Café',
  tagline: 'Fresh coffee, no queue.',
  logoUrl: DemoConfig.assetUrl('demo/logo.png'),
  backgroundImageUrl: DemoConfig.assetUrl('demo/terrace.jpg'),
  logoSize: 120,
);

final demoRouter = GoRouter(
  initialLocation: '/demo/order',
  routes: [
    GoRoute(
      path: '/demo/order',
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: const _OrderEntry()),
    ),
    GoRoute(
      path: '/demo/scan',
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const MenuScanDemoScreen(),
      ),
    ),
    ...appRoutes,
  ],
);

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Self-Service Kiosk demo',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: demoRouter,
      // Mouse and trackpad drag-scroll like a touch screen.
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
        },
      ),
    );
  }
}

/// Resets the sample menu and cart, then opens the customer start screen.
class _OrderEntry extends ConsumerStatefulWidget {
  const _OrderEntry();

  @override
  ConsumerState<_OrderEntry> createState() => _OrderEntryState();
}

class _OrderEntryState extends ConsumerState<_OrderEntry> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      ref.read(cartProvider.notifier).clear();
      await ref.read(menuProvider.notifier).seedDemoMenu('cafe');
      if (mounted) context.go('/kiosk');
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: AppColors.white,
    body: Center(child: CircularProgressIndicator(color: AppColors.blue)),
  );
}

List<Override> demoOverrides() => [
  brandingSettingsProvider.overrideWith(
    (ref) => BrandingSettingsNotifier(demoBranding()),
  ),
];
