// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiAnalysisHash() => r'c43e7aa669aafbf3882bb0940263920eac3a7011';

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

/// See also [aiAnalysis].
@ProviderFor(aiAnalysis)
const aiAnalysisProvider = AiAnalysisFamily();

/// See also [aiAnalysis].
class AiAnalysisFamily extends Family<AsyncValue<String>> {
  /// See also [aiAnalysis].
  const AiAnalysisFamily();

  /// See also [aiAnalysis].
  AiAnalysisProvider call(
    String symbol,
  ) {
    return AiAnalysisProvider(
      symbol,
    );
  }

  @override
  AiAnalysisProvider getProviderOverride(
    covariant AiAnalysisProvider provider,
  ) {
    return call(
      provider.symbol,
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
  String? get name => r'aiAnalysisProvider';
}

/// See also [aiAnalysis].
class AiAnalysisProvider extends AutoDisposeFutureProvider<String> {
  /// See also [aiAnalysis].
  AiAnalysisProvider(
    String symbol,
  ) : this._internal(
          (ref) => aiAnalysis(
            ref as AiAnalysisRef,
            symbol,
          ),
          from: aiAnalysisProvider,
          name: r'aiAnalysisProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$aiAnalysisHash,
          dependencies: AiAnalysisFamily._dependencies,
          allTransitiveDependencies:
              AiAnalysisFamily._allTransitiveDependencies,
          symbol: symbol,
        );

  AiAnalysisProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.symbol,
  }) : super.internal();

  final String symbol;

  @override
  Override overrideWith(
    FutureOr<String> Function(AiAnalysisRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AiAnalysisProvider._internal(
        (ref) => create(ref as AiAnalysisRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        symbol: symbol,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _AiAnalysisProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AiAnalysisProvider && other.symbol == symbol;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, symbol.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AiAnalysisRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `symbol` of this provider.
  String get symbol;
}

class _AiAnalysisProviderElement
    extends AutoDisposeFutureProviderElement<String> with AiAnalysisRef {
  _AiAnalysisProviderElement(super.provider);

  @override
  String get symbol => (origin as AiAnalysisProvider).symbol;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
