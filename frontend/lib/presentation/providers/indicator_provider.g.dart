// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'indicator_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$technicalIndicatorHash() =>
    r'6eaea11e5a6066a231894a575b9d54e37b277f73';

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

/// See also [technicalIndicator].
@ProviderFor(technicalIndicator)
const technicalIndicatorProvider = TechnicalIndicatorFamily();

/// See also [technicalIndicator].
class TechnicalIndicatorFamily
    extends Family<AsyncValue<TechnicalIndicatorModel?>> {
  /// See also [technicalIndicator].
  const TechnicalIndicatorFamily();

  /// See also [technicalIndicator].
  TechnicalIndicatorProvider call({
    required String symbol,
    required String interval,
  }) {
    return TechnicalIndicatorProvider(
      symbol: symbol,
      interval: interval,
    );
  }

  @override
  TechnicalIndicatorProvider getProviderOverride(
    covariant TechnicalIndicatorProvider provider,
  ) {
    return call(
      symbol: provider.symbol,
      interval: provider.interval,
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
  String? get name => r'technicalIndicatorProvider';
}

/// See also [technicalIndicator].
class TechnicalIndicatorProvider
    extends AutoDisposeFutureProvider<TechnicalIndicatorModel?> {
  /// See also [technicalIndicator].
  TechnicalIndicatorProvider({
    required String symbol,
    required String interval,
  }) : this._internal(
          (ref) => technicalIndicator(
            ref as TechnicalIndicatorRef,
            symbol: symbol,
            interval: interval,
          ),
          from: technicalIndicatorProvider,
          name: r'technicalIndicatorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$technicalIndicatorHash,
          dependencies: TechnicalIndicatorFamily._dependencies,
          allTransitiveDependencies:
              TechnicalIndicatorFamily._allTransitiveDependencies,
          symbol: symbol,
          interval: interval,
        );

  TechnicalIndicatorProvider._internal(
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
    FutureOr<TechnicalIndicatorModel?> Function(TechnicalIndicatorRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TechnicalIndicatorProvider._internal(
        (ref) => create(ref as TechnicalIndicatorRef),
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
  AutoDisposeFutureProviderElement<TechnicalIndicatorModel?> createElement() {
    return _TechnicalIndicatorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TechnicalIndicatorProvider &&
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

mixin TechnicalIndicatorRef
    on AutoDisposeFutureProviderRef<TechnicalIndicatorModel?> {
  /// The parameter `symbol` of this provider.
  String get symbol;

  /// The parameter `interval` of this provider.
  String get interval;
}

class _TechnicalIndicatorProviderElement
    extends AutoDisposeFutureProviderElement<TechnicalIndicatorModel?>
    with TechnicalIndicatorRef {
  _TechnicalIndicatorProviderElement(super.provider);

  @override
  String get symbol => (origin as TechnicalIndicatorProvider).symbol;
  @override
  String get interval => (origin as TechnicalIndicatorProvider).interval;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
