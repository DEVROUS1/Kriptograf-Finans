import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/market_summary_model.dart';
import '../../data/repositories/market_repository.dart';

part 'market_provider.g.dart';

/// Auto-refreshing market summary provider.
/// Her 5 saniyede bir otomatik güncellenir — sol panel her zaman güncel kalır.
@riverpod
Future<List<MarketSummaryModel>> marketSummary(MarketSummaryRef ref) async {
  final repo = ref.watch(marketRepositoryProvider);

  // 5 saniye sonra kendini invalidate et → otomatik yeniden fetch
  final timer = Timer(const Duration(seconds: 5), () {
    ref.invalidateSelf();
  });

  // Provider dispose olduğunda timer'ı temizle
  ref.onDispose(timer.cancel);

  return repo.getMarketSummary();
}
