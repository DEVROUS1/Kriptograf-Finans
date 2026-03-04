// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarketSummaryModelImpl _$$MarketSummaryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MarketSummaryModelImpl(
      symbol: json['symbol'] as String,
      lastPrice: json['lastPrice'] as String,
      priceChange: json['priceChange'] as String,
      priceChangePercent: json['priceChangePercent'] as String,
      volume: json['volume'] as String?,
    );

Map<String, dynamic> _$$MarketSummaryModelImplToJson(
        _$MarketSummaryModelImpl instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'lastPrice': instance.lastPrice,
      'priceChange': instance.priceChange,
      'priceChangePercent': instance.priceChangePercent,
      'volume': instance.volume,
    };
