/// Dart-define ile inject edilen env değerleri.
/// Build komutu: flutter run --dart-define=WS_BASE_URL=wss://your-server.com
///
/// Uzaktan erişim için otomatik URL algılama:
/// - localhost'ta çalışırken → localhost:8000
/// - Uzaktan erişimde → aynı host üzerinden /api ve /ws yolları kullanılır
abstract final class AppConfig {
  static String get wsBaseUrl {
    const envUrl = String.fromEnvironment('WS_BASE_URL', defaultValue: '');
    if (envUrl.isNotEmpty) return envUrl;

    final uri = Uri.base;
    final host = uri.host;

    if (host.isEmpty || host == 'localhost' || host == '127.0.0.1') {
      return 'ws://localhost:8000';
    }

    // Uzaktan erişim: Render Backend WebSocket URL'si
    return 'wss://kriptograf-finans.onrender.com';
  }

  static String get apiBaseUrl {
    const envUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (envUrl.isNotEmpty) return envUrl;

    final uri = Uri.base;
    final host = uri.host;

    if (host.isEmpty || host == 'localhost' || host == '127.0.0.1') {
      return 'http://localhost:8000/api/v1';
    }

    // Uzaktan erişim: Render Backend API URL'si
    return 'https://kriptograf-finans.onrender.com/api/v1';
  }
}