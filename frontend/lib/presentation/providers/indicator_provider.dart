import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/technical_indicator_model.dart';
import '../../data/repositories/market_repository.dart';
import 'selected_coin_provider.dart';

part 'indicator_provider.g.dart';

@riverpod
Future<TechnicalIndicatorModel?> technicalIndicator(TechnicalIndicatorRef ref, {required String symbol, required String interval}) async {
  final repo = ref.watch(marketRepositoryProvider);
  return repo.getTechnicalIndicators(symbol, interval);
}
