/// API Keys Configuration
///
/// Never commit real API keys. The optional AI menu scanning feature reads
/// its key at build time:
///   flutter run --dart-define=GEMINI_API_KEY=your_key
/// Free key: https://ai.google.dev. Without a key the feature is disabled.

class ApiKeys {
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

  static bool get isGeminiConfigured => geminiApiKey.isNotEmpty;
}
