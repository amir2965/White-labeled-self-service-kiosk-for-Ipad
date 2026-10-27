import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/router.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../presentation/branding/models/branding_settings.dart';
import '../presentation/branding/models/welcome_template_config.dart';
import '../presentation/branding/providers/branding_provider.dart';
import '../presentation/kiosk/menu_template_config.dart';
import '../presentation/kiosk/template_preview_screen.dart';
import '../presentation/onboarding/steps/template_selection_step.dart';
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

Page<void> _page(GoRouterState state, Widget child) =>
    NoTransitionPage(key: state.pageKey, child: child);

final demoRouter = GoRouter(
  initialLocation: '/demo/order',
  routes: [
    GoRoute(
      path: '/demo/order',
      pageBuilder: (context, state) => _page(
        state,
        _Seeded(
          child: const SizedBox.shrink(),
          onReady: (context) => context.go('/kiosk'),
        ),
      ),
    ),
    GoRoute(
      path: '/demo/scan',
      pageBuilder: (context, state) =>
          _page(state, const MenuScanDemoScreen()),
    ),
    GoRoute(
      path: '/demo/templates',
      pageBuilder: (context, state) =>
          _page(state, const _Seeded(child: _TemplatePicker())),
    ),
    // Opens a single layout directly (used for automated checks)
    GoRoute(
      path: '/demo/preview/:name',
      pageBuilder: (context, state) {
        final template = MenuDisplayTemplate.values.firstWhere(
          (t) => t.name == state.pathParameters['name'],
          orElse: () => MenuDisplayTemplate.categorySidebar,
        );
        return _page(
          state,
          _Seeded(
            child: TemplatePreviewScreen(
              template: template,
              templateName: template.name,
              isOnboarding: true,
            ),
          ),
        );
      },
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
      builder: (context, child) => _AdaptiveCursor(child: child!),
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

/// Template list with the same layouts as the app's onboarding step.
class _TemplatePicker extends StatelessWidget {
  const _TemplatePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: TemplateSelectionStep(
          selectedTemplateId: null,
          onSelected: (_, __) {},
        ),
      ),
    );
  }
}

/// Resets the cart and loads the sample menu before showing [child].
class _Seeded extends ConsumerStatefulWidget {
  final Widget child;
  final void Function(BuildContext context)? onReady;

  const _Seeded({required this.child, this.onReady});

  @override
  ConsumerState<_Seeded> createState() => _SeededState();
}

class _SeededState extends ConsumerState<_Seeded> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      ref.read(cartProvider.notifier).clear();
      await ref.read(menuProvider.notifier).seedDemoMenu('cafe');
      if (!mounted) return;
      setState(() => _ready = true);
      widget.onReady?.call(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        backgroundColor: AppColors.white,
        body: Center(child: CircularProgressIndicator(color: AppColors.blue)),
      );
    }
    return widget.child;
  }
}

/// Mouse cursor that follows what is under the pointer: a pointing hand over
/// anything tappable, an open/closed hand over scrollable content.
class _AdaptiveCursor extends StatefulWidget {
  final Widget child;

  const _AdaptiveCursor({required this.child});

  @override
  State<_AdaptiveCursor> createState() => _AdaptiveCursorState();
}

class _AdaptiveCursorState extends State<_AdaptiveCursor> {
  MouseCursor _cursor = MouseCursor.defer;
  bool _down = false;

  void _update(Offset position) {
    final result = HitTestResult();
    WidgetsBinding.instance.hitTestInView(
      result,
      position,
      View.of(context).viewId,
    );
    var tappable = false;
    var scrollable = false;
    for (final entry in result.path) {
      final target = entry.target;
      if (target is RenderSemanticsGestureHandler && target.onTap != null) {
        tappable = true;
      } else if (target is RenderAbstractViewport) {
        scrollable = true;
      }
    }
    final next = tappable
        ? SystemMouseCursors.click
        : scrollable
        ? (_down ? SystemMouseCursors.grabbing : SystemMouseCursors.grab)
        : MouseCursor.defer;
    if (next != _cursor) setState(() => _cursor = next);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) {
        _down = true;
        _update(e.position);
      },
      onPointerUp: (e) {
        _down = false;
        _update(e.position);
      },
      child: MouseRegion(
        cursor: _cursor,
        onHover: (e) => _update(e.position),
        child: widget.child,
      ),
    );
  }
}

List<Override> demoOverrides() => [
  brandingSettingsProvider.overrideWith(
    (ref) => BrandingSettingsNotifier(demoBranding()),
  ),
];
