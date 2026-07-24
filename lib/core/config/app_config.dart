abstract final class AppConfig {
  // Defaults to the deployed backend. The `/api` suffix is required: every
  // ApiConstants path is relative to it (e.g. `/chat/threads` -> `.../api/chat/
  // threads`), and SignalR derives its origin from this too.
  //
  // Override per environment with --dart-define=API_BASE_URL=... For local dev
  // against the PC's backend use the LAN IP from a physical device
  // (http://192.168.1.4:5283/api) or the emulator alias
  // (http://10.0.2.2:5283/api); both are already allow-listed for cleartext in
  // network_security_config.xml.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://khdma.runasp.net/api',
  );

  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  static String get origin => Uri.parse(baseUrl).origin;
}
