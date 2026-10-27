import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Preserve the merchant tools' tablet canvas without shrinking touch targets.
/// The customer ordering flow uses its responsive phone layout directly.
class DemoViewport extends StatefulWidget {
  final Widget child;
  final GoRouter router;

  const DemoViewport({super.key, required this.child, required this.router});

  @override
  State<DemoViewport> createState() => _DemoViewportState();
}

class _DemoViewportState extends State<DemoViewport> {
  final _horizontal = ScrollController();
  final _vertical = ScrollController();

  @override
  void dispose() {
    _horizontal.dispose();
    _vertical.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.router.routeInformationProvider,
      builder: (context, _) {
        final path = widget.router.routeInformationProvider.value.uri.path;
        final tablet = path.startsWith('/demo/scan') ||
            path.startsWith('/demo/templates') ||
            path.startsWith('/demo/preview') ||
            path.startsWith('/branding') ||
            path.startsWith('/analytics') ||
            path.startsWith('/payouts');
        return LayoutBuilder(builder: (context, constraints) {
          if (!tablet || constraints.maxWidth >= 1024) return widget.child;
          return ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: Scrollbar(
              controller: _horizontal,
              thumbVisibility: true,
              interactive: true,
              thickness: 10,
              notificationPredicate: (n) => n.metrics.axis == Axis.horizontal,
              child: SingleChildScrollView(
                controller: _horizontal,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 1024,
                  height: constraints.maxHeight,
                  child: Scrollbar(
                    controller: _vertical,
                    thumbVisibility: true,
                    interactive: true,
                    child: SingleChildScrollView(
                      controller: _vertical,
                      child: SizedBox(
                        height: constraints.maxHeight < 712 ? 712 : constraints.maxHeight,
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                            size: Size(1024, constraints.maxHeight < 712 ? 712 : constraints.maxHeight),
                          ),
                          child: widget.child,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
