import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/market_summary_model.dart';
import '../../data/repositories/market_repository.dart';

part 'market_provider.g.dart';

@riverpod
Future<List<MarketSummaryModel>> marketSummary(MarketSummaryRef ref) async {
  final repo = ref.watch(marketRepositoryProvider);
  return repo.getMarketSummary();
}
