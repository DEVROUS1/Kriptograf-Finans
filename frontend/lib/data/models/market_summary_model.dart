import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_summary_model.freezed.dart';
part 'market_summary_model.g.dart';

@freezed
class MarketSummaryModel with _$MarketSummaryModel {
  const factory MarketSummaryModel({
    required String symbol,
    required String lastPrice,
    required String priceChange,
    required String priceChangePercent,
    String? volume,
  }) = _MarketSummaryModel;

  factory MarketSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$MarketSummaryModelFromJson(json);
}
