import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;

import '../../config/app_config.dart';

/// WebSocket bağlantı durumu
enum WsConnectionState { connecting, connected, disconnected, error }

/// WebSocket'i yöneten düşük seviyeli servis.
///
/// Özellikler:
/// - Otomatik yeniden bağlanma (sınırsız, exponential backoff max 30s)
/// - Keepalive ping her 15 saniyede (Render free tier timeout'u önlemek için)
/// - Stream broadcast: birden fazla listener destekler
/// - dispose() ile temiz kaynak serbest bırakma
class WebSocketService {
  WebSocketService({
    required this.symbol,
    required this.interval,
  }) : _url = '${AppConfig.wsBaseUrl}/ws/kline/$symbol/$interval';

  final String symbol;
  final String interval;
  final String _url;

  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  StreamSubscription? _subscription;

  // Dışarıya açık broadcast stream
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _stateController = StreamController<WsConnectionState>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<WsConnectionState> get connectionStateStream => _stateController.stream;

  int _retryCount = 0;
  // Sınırsız yeniden deneme — asla pes etme
  static const Duration _initialBackoff = Duration(seconds: 1);
  static const int _maxBackoffSeconds = 30;

  bool _isDisposed = false;

  /// Bağlantıyı başlat. Provider init'te çağrılır.
  Future<void> connect() async {
    if (_isDisposed) return;
    _emitState(WsConnectionState.connecting);

    try {
      _channel = WebSocketChannel.connect(Uri.parse(_url));
      await _channel!.ready; // Bağlantı hazır olana kadar bekle

      _emitState(WsConnectionState.connected);
      _retryCount = 0; // Başarılı bağlantıda sayacı sıfırla
      debugPrint('✅ WS Bağlı: $_url');

      _subscription = _channel!.stream.listen(
        (data) => _onMessage(data),
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );

      // Keepalive ping'i her 15 saniyede bir gönder (Render free tier timeout önleme)
      _startKeepalive();
    } catch (e) {
      debugPrint('❌ WS bağlantı hatası: $e');
      _emitState(WsConnectionState.error);
      _scheduleReconnect();
    }
  }

  void _onMessage(dynamic rawMessage) {
    try {
      if (rawMessage is String) {
        if (rawMessage == 'pong') return;
        final data = json.decode(rawMessage) as Map<String, dynamic>;

        // Keepalive mesajlarını filtrele
        if (data['type'] == 'keepalive') return;

        _messageController.add(data);
      }
    } catch (e) {
      debugPrint('⚠️ WS mesaj parse hatası: $e');
    }
  }

  void _onError(Object error) {
    debugPrint('❌ WS stream hatası: $error');
    _emitState(WsConnectionState.error);
  }

  void _onDone() {
    if (_isDisposed) return;
    debugPrint('🔌 WS bağlantısı kapandı. Yeniden bağlanılıyor...');
    _emitState(WsConnectionState.disconnected);
    _scheduleReconnect();
  }

  Timer? _keepaliveTimer;

  void _startKeepalive() {
    _keepaliveTimer?.cancel();
    _keepaliveTimer = Timer.periodic(
      const Duration(seconds: 15), // 25s → 15s (daha agresif keepalive)
      (_) {
        try {
          _channel?.sink.add('ping');
        } catch (_) {
          // Sink kapalıysa sessizce geç
        }
      },
    );
  }

  void _scheduleReconnect() {
    if (_isDisposed) return;

    // Exponential backoff: 1s, 2s, 4s, 8s, ... max 30s — ASLA PES ETME
    final delaySec = (_initialBackoff.inSeconds * (1 << _retryCount.clamp(0, 5)))
        .clamp(1, _maxBackoffSeconds);
    final delay = Duration(seconds: delaySec);
    _retryCount++;

    debugPrint('🔄 $_retryCount. yeniden deneme ${delay.inSeconds}s sonra...');

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () async {
      // Eski bağlantıyı temizle
      await _subscription?.cancel();
      _subscription = null;
      try {
        await _channel?.sink.close(ws_status.goingAway);
      } catch (_) {}
      _channel = null;
      // Yeniden bağlan
      connect();
    });
  }

  void _emitState(WsConnectionState state) {
    if (!_stateController.isClosed) {
      _stateController.add(state);
    }
  }

  /// Temiz kaynak serbest bırakma.
  Future<void> dispose() async {
    _isDisposed = true;
    _keepaliveTimer?.cancel();
    _reconnectTimer?.cancel();
    await _subscription?.cancel();
    try {
      await _channel?.sink.close(ws_status.goingAway);
    } catch (_) {}
    await _messageController.close();
    await _stateController.close();
    debugPrint('🗑️ WebSocketService dispose edildi: $_url');
  }
}