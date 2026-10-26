/// Runtime switches for the browser demo build (see lib/main_demo.dart).
///
/// The production app never sets [enabled], so behaviour there is unchanged.
class DemoConfig {
  DemoConfig._();

  static bool enabled = false;

  /// URL of a file shipped next to the web build (web/demo/...).
  static String assetUrl(String path) => Uri.base.resolve(path).toString();
}
