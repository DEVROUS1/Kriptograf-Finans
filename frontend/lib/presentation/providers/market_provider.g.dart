// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$marketSummaryHash() => r'bbadcd0a7869d9448d6fc06e0802ee5f8c748768';

/// Auto-refreshing market summary provider.
/// Her 5 saniyede bir otomatik güncellenir — sol panel her zaman güncel kalır.
///
/// Copied from [marketSummary].
@ProviderFor(marketSummary)
final marketSummaryProvider =
    AutoDisposeFutureProvider<List<MarketSummaryModel>>.internal(
  marketSummary,
  name: r'marketSummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$marketSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MarketSummaryRef
    = AutoDisposeFutureProviderRef<List<MarketSummaryModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
