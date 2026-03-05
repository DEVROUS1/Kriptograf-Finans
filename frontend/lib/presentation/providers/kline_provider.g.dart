// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kline_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$webSocketServiceHash() => r'c44e534c0412e34604acf44e70a9b59a4f7a4833';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Her sembol+interval kombinasyonu için izole bir WS servisi oluşturur.
/// Riverpod family parametresi → aynı provider farklı argumanlarla birden fazla
/// instance oluşturabilir. AutoDispose → kullanılmadığında otomatik temizlenir.
///
/// Copied from [webSocketService].
@ProviderFor(webSocketService)
const webSocketServiceProvider = WebSocketServiceFamily();

/// Her sembol+interval kombinasyonu için izole bir WS servisi oluşturur.
/// Riverpod family parametresi → aynı provider farklı argumanlarla birden fazla
/// instance oluşturabilir. AutoDispose → kullanılmadığında otomatik temizlenir.
///
/// Copied from [webSocketService].
class WebSocketServiceFamily extends Family<WebSocketService> {
  /// Her sembol+interval kombinasyonu için izole bir WS servisi oluşturur.
  /// Riverpod family parametresi → aynı provider farklı argumanlarla birden fazla
  /// instance oluşturabilir. AutoDispose → kullanılmadığında otomatik temizlenir.
  ///
  /// Copied from [webSocketService].
  const WebSocketServiceFamily();

  /// Her sembol+interval kombinasyonu için izole bir WS servisi oluşturur.
  /// Riverpod family parametresi → aynı provider farklı argumanlarla birden fazla
  /// instance oluşturabilir. AutoDispose → kullanılmadığında otomatik temizlenir.
  ///
  /// Copied from [webSocketService].
  WebSocketServiceProvider call(
    String symbol,
    String interval,
  ) {
    return WebSocketServiceProvider(
      symbol,
      interval,
    );
  }

  @override
  WebSocketServiceProvider getProviderOverride(
    covariant WebSocketServiceProvider provider,
  ) {
    return call(
      provider.symbol,
      provider.interval,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'webSocketServiceProvider';
}

/// Her sembol+interval kombinasyonu için izole bir WS servisi oluşturur.
/// Riverpod family parametresi → aynı provider farklı argumanlarla birden fazla
/// instance oluşturabilir. AutoDispose → kullanılmadığında otomatik temizlenir.
///
/// Copied from [webSocketService].
class WebSocketServiceProvider extends AutoDisposeProvider<WebSocketService> {
  /// Her sembol+interval kombinasyonu için izole bir WS servisi oluşturur.
  /// Riverpod family parametresi → aynı provider farklı argumanlarla birden fazla
  /// instance oluşturabilir. AutoDispose → kullanılmadığında otomatik temizlenir.
  ///
  /// Copied from [webSocketService].
  WebSocketServiceProvider(
    String symbol,
    String interval,
  ) : this._internal(
          (ref) => webSocketService(
            ref as WebSocketServiceRef,
            symbol,
            interval,
          ),
          from: webSocketServiceProvider,
          name: r'webSocketServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$webSocketServiceHash,
          dependencies: WebSocketServiceFamily._dependencies,
          allTransitiveDependencies:
              WebSocketServiceFamily._allTransitiveDependencies,
          symbol: symbol,
          interval: interval,
        );

  WebSocketServiceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.symbol,
    required this.interval,
  }) : super.internal();

  final String symbol;
  final String interval;

  @override
  Override overrideWith(
    WebSocketService Function(WebSocketServiceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WebSocketServiceProvider._internal(
        (ref) => create(ref as WebSocketServiceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        symbol: symbol,
        interval: interval,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<WebSocketService> createElement() {
    return _WebSocketServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WebSocketServiceProvider &&
        other.symbol == symbol &&
        other.interval == interval;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, symbol.hashCode);
    hash = _SystemHash.combine(hash, interval.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WebSocketServiceRef on AutoDisposeProviderRef<WebSocketService> {
  /// The parameter `symbol` of this provider.
  String get symbol;

  /// The parameter `interval` of this provider.
  String get interval;
}

class _WebSocketServiceProviderElement
    extends AutoDisposeProviderElement<WebSocketService>
    with WebSocketServiceRef {
  _WebSocketServiceProviderElement(super.provider);

  @override
  String get symbol => (origin as WebSocketServiceProvider).symbol;
  @override
  String get interval => (origin as WebSocketServiceProvider).interval;
}

String _$latestClosePriceHash() => r'264614991470b5155bff0c009668c8bd955936c9';

/// Sadece son close fiyatını dinleyen provider.
/// Widget bu provider'ı kullanırsa, yalnızca fiyat değiştiğinde rebuild olur.
///
/// Copied from [latestClosePrice].
@ProviderFor(latestClosePrice)
const latestClosePriceProvider = LatestClosePriceFamily();

/// Sadece son close fiyatını dinleyen provider.
/// Widget bu provider'ı kullanırsa, yalnızca fiyat değiştiğinde rebuild olur.
///
/// Copied from [latestClosePrice].
class LatestClosePriceFamily extends Family<double?> {
  /// Sadece son close fiyatını dinleyen provider.
  /// Widget bu provider'ı kullanırsa, yalnızca fiyat değiştiğinde rebuild olur.
  ///
  /// Copied from [latestClosePrice].
  const LatestClosePriceFamily();

  /// Sadece son close fiyatını dinleyen provider.
  /// Widget bu provider'ı kullanırsa, yalnızca fiyat değiştiğinde rebuild olur.
  ///
  /// Copied from [latestClosePrice].
  LatestClosePriceProvider call(
    String symbol,
    String interval,
  ) {
    return LatestClosePriceProvider(
      symbol,
      interval,
    );
  }

  @override
  LatestClosePriceProvider getProviderOverride(
    covariant LatestClosePriceProvider provider,
  ) {
    return call(
      provider.symbol,
      provider.interval,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'latestClosePriceProvider';
}

/// Sadece son close fiyatını dinleyen provider.
/// Widget bu provider'ı kullanırsa, yalnızca fiyat değiştiğinde rebuild olur.
///
/// Copied from [latestClosePrice].
class LatestClosePriceProvider extends AutoDisposeProvider<double?> {
  /// Sadece son close fiyatını dinleyen provider.
  /// Widget bu provider'ı kullanırsa, yalnızca fiyat değiştiğinde rebuild olur.
  ///
  /// Copied from [latestClosePrice].
  LatestClosePriceProvider(
    String symbol,
    String interval,
  ) : this._internal(
          (ref) => latestClosePrice(
            ref as LatestClosePriceRef,
            symbol,
            interval,
          ),
          from: latestClosePriceProvider,
          name: r'latestClosePriceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$latestClosePriceHash,
          dependencies: LatestClosePriceFamily._dependencies,
          allTransitiveDependencies:
              LatestClosePriceFamily._allTransitiveDependencies,
          symbol: symbol,
          interval: interval,
        );

  LatestClosePriceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.symbol,
    required this.interval,
  }) : super.internal();

  final String symbol;
  final String interval;

  @override
  Override overrideWith(
    double? Function(LatestClosePriceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LatestClosePriceProvider._internal(
        (ref) => create(ref as LatestClosePriceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        symbol: symbol,
        interval: interval,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<double?> createElement() {
    return _LatestClosePriceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LatestClosePriceProvider &&
        other.symbol == symbol &&
        other.interval == interval;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, symbol.hashCode);
    hash = _SystemHash.combine(hash, interval.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LatestClosePriceRef on AutoDisposeProviderRef<double?> {
  /// The parameter `symbol` of this provider.
  String get symbol;

  /// The parameter `interval` of this provider.
  String get interval;
}

class _LatestClosePriceProviderElement
    extends AutoDisposeProviderElement<double?> with LatestClosePriceRef {
  _LatestClosePriceProviderElement(super.provider);

  @override
  String get symbol => (origin as LatestClosePriceProvider).symbol;
  @override
  String get interval => (origin as LatestClosePriceProvider).interval;
}

String _$klineConnectionStateHash() =>
    r'569468c5a14992ea92a7c56b5d23ce6346ca4ec0';

/// Bağlantı durumunu ayrı izleyen provider.
///
/// Copied from [klineConnectionState].
@ProviderFor(klineConnectionState)
const klineConnectionStateProvider = KlineConnectionStateFamily();

/// Bağlantı durumunu ayrı izleyen provider.
///
/// Copied from [klineConnectionState].
class KlineConnectionStateFamily extends Family<WsConnectionState> {
  /// Bağlantı durumunu ayrı izleyen provider.
  ///
  /// Copied from [klineConnectionState].
  const KlineConnectionStateFamily();

  /// Bağlantı durumunu ayrı izleyen provider.
  ///
  /// Copied from [klineConnectionState].
  KlineConnectionStateProvider call(
    String symbol,
    String interval,
  ) {
    return KlineConnectionStateProvider(
      symbol,
      interval,
    );
  }

  @override
  KlineConnectionStateProvider getProviderOverride(
    covariant KlineConnectionStateProvider provider,
  ) {
    return call(
      provider.symbol,
      provider.interval,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'klineConnectionStateProvider';
}

/// Bağlantı durumunu ayrı izleyen provider.
///
/// Copied from [klineConnectionState].
class KlineConnectionStateProvider
    extends AutoDisposeProvider<WsConnectionState> {
  /// Bağlantı durumunu ayrı izleyen provider.
  ///
  /// Copied from [klineConnectionState].
  KlineConnectionStateProvider(
    String symbol,
    String interval,
  ) : this._internal(
          (ref) => klineConnectionState(
            ref as KlineConnectionStateRef,
            symbol,
            interval,
          ),
          from: klineConnectionStateProvider,
          name: r'klineConnectionStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$klineConnectionStateHash,
          dependencies: KlineConnectionStateFamily._dependencies,
          allTransitiveDependencies:
              KlineConnectionStateFamily._allTransitiveDependencies,
          symbol: symbol,
          interval: interval,
        );

  KlineConnectionStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.symbol,
    required this.interval,
  }) : super.internal();

  final String symbol;
  final String interval;

  @override
  Override overrideWith(
    WsConnectionState Function(KlineConnectionStateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: KlineConnectionStateProvider._internal(
        (ref) => create(ref as KlineConnectionStateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        symbol: symbol,
        interval: interval,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<WsConnectionState> createElement() {
    return _KlineConnectionStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is KlineConnectionStateProvider &&
        other.symbol == symbol &&
        other.interval == interval;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, symbol.hashCode);
    hash = _SystemHash.combine(hash, interval.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin KlineConnectionStateRef on AutoDisposeProviderRef<WsConnectionState> {
  /// The parameter `symbol` of this provider.
  String get symbol;

  /// The parameter `interval` of this provider.
  String get interval;
}

class _KlineConnectionStateProviderElement
    extends AutoDisposeProviderElement<WsConnectionState>
    with KlineConnectionStateRef {
  _KlineConnectionStateProviderElement(super.provider);

  @override
  String get symbol => (origin as KlineConnectionStateProvider).symbol;
  @override
  String get interval => (origin as KlineConnectionStateProvider).interval;
}

String _$klineNotifierHash() => r'ad9b6b1a28f601acf831eee3087f73f650c64381';

abstract class _$KlineNotifier
    extends BuildlessAutoDisposeNotifier<KlineState> {
  late final String symbol;
  late final String interval;

  KlineState build(
    String symbol,
    String interval,
  );
}

/// KlineNotifier: WebSocket mesajlarını tüketir, state'i günceller.
///
/// Riverpod @riverpod annotation ile otomatik kod üretimi:
/// → klineNotifierProvider(symbol, interval) şeklinde kullanılır
///
/// Copied from [KlineNotifier].
@ProviderFor(KlineNotifier)
const klineNotifierProvider = KlineNotifierFamily();

/// KlineNotifier: WebSocket mesajlarını tüketir, state'i günceller.
///
/// Riverpod @riverpod annotation ile otomatik kod üretimi:
/// → klineNotifierProvider(symbol, interval) şeklinde kullanılır
///
/// Copied from [KlineNotifier].
class KlineNotifierFamily extends Family<KlineState> {
  /// KlineNotifier: WebSocket mesajlarını tüketir, state'i günceller.
  ///
  /// Riverpod @riverpod annotation ile otomatik kod üretimi:
  /// → klineNotifierProvider(symbol, interval) şeklinde kullanılır
  ///
  /// Copied from [KlineNotifier].
  const KlineNotifierFamily();

  /// KlineNotifier: WebSocket mesajlarını tüketir, state'i günceller.
  ///
  /// Riverpod @riverpod annotation ile otomatik kod üretimi:
  /// → klineNotifierProvider(symbol, interval) şeklinde kullanılır
  ///
  /// Copied from [KlineNotifier].
  KlineNotifierProvider call(
    String symbol,
    String interval,
  ) {
    return KlineNotifierProvider(
      symbol,
      interval,
    );
  }

  @override
  KlineNotifierProvider getProviderOverride(
    covariant KlineNotifierProvider provider,
  ) {
    return call(
      provider.symbol,
      provider.interval,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'klineNotifierProvider';
}

/// KlineNotifier: WebSocket mesajlarını tüketir, state'i günceller.
///
/// Riverpod @riverpod annotation ile otomatik kod üretimi:
/// → klineNotifierProvider(symbol, interval) şeklinde kullanılır
///
/// Copied from [KlineNotifier].
class KlineNotifierProvider
    extends AutoDisposeNotifierProviderImpl<KlineNotifier, KlineState> {
  /// KlineNotifier: WebSocket mesajlarını tüketir, state'i günceller.
  ///
  /// Riverpod @riverpod annotation ile otomatik kod üretimi:
  /// → klineNotifierProvider(symbol, interval) şeklinde kullanılır
  ///
  /// Copied from [KlineNotifier].
  KlineNotifierProvider(
    String symbol,
    String interval,
  ) : this._internal(
          () => KlineNotifier()
            ..symbol = symbol
            ..interval = interval,
          from: klineNotifierProvider,
          name: r'klineNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$klineNotifierHash,
          dependencies: KlineNotifierFamily._dependencies,
          allTransitiveDependencies:
              KlineNotifierFamily._allTransitiveDependencies,
          symbol: symbol,
          interval: interval,
        );

  KlineNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.symbol,
    required this.interval,
  }) : super.internal();

  final String symbol;
  final String interval;

  @override
  KlineState runNotifierBuild(
    covariant KlineNotifier notifier,
  ) {
    return notifier.build(
      symbol,
      interval,
    );
  }

  @override
  Override overrideWith(KlineNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: KlineNotifierProvider._internal(
        () => create()
          ..symbol = symbol
          ..interval = interval,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        symbol: symbol,
        interval: interval,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<KlineNotifier, KlineState>
      createElement() {
    return _KlineNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is KlineNotifierProvider &&
        other.symbol == symbol &&
        other.interval == interval;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, symbol.hashCode);
    hash = _SystemHash.combine(hash, interval.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin KlineNotifierRef on AutoDisposeNotifierProviderRef<KlineState> {
  /// The parameter `symbol` of this provider.
  String get symbol;

  /// The parameter `interval` of this provider.
  String get interval;
}

class _KlineNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<KlineNotifier, KlineState>
    with KlineNotifierRef {
  _KlineNotifierProviderElement(super.provider);

  @override
  String get symbol => (origin as KlineNotifierProvider).symbol;
  @override
  String get interval => (origin as KlineNotifierProvider).interval;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
