import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/kline_model.dart';
import '../../core/network/websocket_service.dart';

part 'kline_provider.g.dart';

// ──────────────────────────────────────────────
// 1) WebSocketService Provider (family ile parametrik)
// ──────────────────────────────────────────────

/// Her sembol+interval kombinasyonu için izole bir WS servisi oluşturur.
/// Riverpod family parametresi → aynı provider farklı argumanlarla birden fazla
/// instance oluşturabilir. AutoDispose → kullanılmadığında otomatik temizlenir.
@riverpod
WebSocketService webSocketService(
  Ref ref,
  String symbol,
  String interval,
) {
  final service = WebSocketService(symbol: symbol, interval: interval);

  // Bağlantıyı başlat (fire-and-forget, error handling içeride)
  service.connect();

  // Provider dispose edildiğinde WebSocket temiz kapatılır
  ref.onDispose(service.dispose);

  return service;
}

// ──────────────────────────────────────────────
// 2) KlineState — UI'ın tükettiği immutable state
// ──────────────────────────────────────────────

/// Kline stream'inin anlık durumunu temsil eder.
/// sealed class yerine basit class kullandık (Dart 3 uyumlu)
class KlineState {
  const KlineState({
    this.latestKline,
    this.klineHistory = const [],
    this.connectionState = WsConnectionState.connecting,
    this.error,
  });

  final KlineModel? latestKline;
  final List<KlineModel> klineHistory;
  final WsConnectionState connectionState;
  final String? error;

  /// Son N mumu tutar (bellek baskısını önlemek için)
  static const int maxHistorySize = 500;

  KlineState copyWith({
    KlineModel? latestKline,
    List<KlineModel>? klineHistory,
    WsConnectionState? connectionState,
    String? error,
  }) {
    return KlineState(
      latestKline: latestKline ?? this.latestKline,
      klineHistory: klineHistory ?? this.klineHistory,
      connectionState: connectionState ?? this.connectionState,
      error: error,
    );
  }
}

// ──────────────────────────────────────────────
// 3) KlineNotifier — İş Mantığı Katmanı
// ──────────────────────────────────────────────

/// KlineNotifier: WebSocket mesajlarını tüketir, state'i günceller.
///
/// Riverpod @riverpod annotation ile otomatik kod üretimi:
/// → klineNotifierProvider(symbol, interval) şeklinde kullanılır
@riverpod
class KlineNotifier extends _$KlineNotifier {
  StreamSubscription<Map<String, dynamic>>? _messageSub;
  StreamSubscription<WsConnectionState>? _stateSub;

  @override
  KlineState build(String symbol, String interval) {
    // WebSocketService'i al (family provider)
    final wsService = ref.watch(
      webSocketServiceProvider(symbol, interval),
    );

    // Mesaj stream'ine subscribe ol
    _messageSub = wsService.messageStream.listen(
      _onKlineMessage,
      onError: (e) => state = state.copyWith(error: e.toString()),
    );

    // Bağlantı durumu stream'ine subscribe ol
    _stateSub = wsService.connectionStateStream.listen(
      (connState) => state = state.copyWith(connectionState: connState),
    );

    // Subscription'ları temizle
    ref.onDispose(() {
      _messageSub?.cancel();
      _stateSub?.cancel();
    });

    // Geçmiş verileri çek (arka planda)
    _fetchHistory(symbol, interval);

    return const KlineState();
  }

  Future<void> _fetchHistory(String symbol, String interval) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.binance.com/api/v3/klines',
        queryParameters: {
          'symbol': symbol.toUpperCase(),
          'interval': interval,
          'limit': 100,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final history = data.map<KlineModel>((item) {
          // Binance klines format: [OpenTime, Open, High, Low, Close, Volume, CloseTime, ...]
          return KlineModel(
            eventTime: item[0],
            openTime: item[0],
            symbol: symbol,
            interval: interval,
            open: item[1].toString(),
            high: item[2].toString(),
            low: item[3].toString(),
            close: item[4].toString(),
            volume: item[5].toString(),
            isClosed: true,
          );
        }).toList();

        state = state.copyWith(klineHistory: history);
      }
    } catch (e) {
      print('Kline history fetch error: $e');
    }
  }

  void _onKlineMessage(Map<String, dynamic> rawData) {
    try {
      final kline = KlineModel.fromJson(rawData);
      final history = List<KlineModel>.from(state.klineHistory);

      if (kline.isClosed) {
        // Kapanan mum history'e eklenir
        history.add(kline);
        // Bellek baskısını önle
        if (history.length > KlineState.maxHistorySize) {
          history.removeAt(0);
        }
      }

      state = state.copyWith(
        latestKline: kline,
        klineHistory: history,
        connectionState: WsConnectionState.connected,
        error: null,
      );
    } catch (e) {
      // Parse hatası state'i bozmaz, sadece log
      assert(false, 'Kline parse hatası: $e');
    }
  }
}

// ──────────────────────────────────────────────
// 4) Derived (select) Providers — Fine-grained rebuild
// ──────────────────────────────────────────────

/// Sadece son close fiyatını dinleyen provider.
/// Widget bu provider'ı kullanırsa, yalnızca fiyat değiştiğinde rebuild olur.
@riverpod
double? latestClosePrice(Ref ref, String symbol, String interval) {
  return ref
      .watch(klineNotifierProvider(symbol, interval))
      .latestKline
      ?.closeAsDouble;
}

/// Bağlantı durumunu ayrı izleyen provider.
@riverpod
WsConnectionState klineConnectionState(Ref ref, String symbol, String interval) {
  return ref
      .watch(klineNotifierProvider(symbol, interval))
      .connectionState;
}