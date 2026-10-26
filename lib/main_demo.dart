import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'demo/demo_app.dart';
import 'demo/demo_config.dart';

/// Entry point of the browser demo embedded in the project website.
/// Build: flutter build web -t lib/main_demo.dart
void main() {
  DemoConfig.enabled = true;
  runApp(ProviderScope(overrides: demoOverrides(), child: const DemoApp()));
}
