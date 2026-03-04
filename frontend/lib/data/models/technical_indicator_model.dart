import 'package:freezed_annotation/freezed_annotation.dart';

part 'technical_indicator_model.freezed.dart';
part 'technical_indicator_model.g.dart';

@freezed
class IndicatorValues with _$IndicatorValues {
  const factory IndicatorValues({
    // Momentum
    double? rsi,
    @JsonKey(name: 'stoch_rsi') double? stochRsi,
    @JsonKey(name: 'stoch_k') double? stochK,
    @JsonKey(name: 'stoch_d') double? stochD,
    double? cci,
    @JsonKey(name: 'williams_r') double? williamsR,
    double? roc,
    @JsonKey(name: 'awesome_osc') double? awesomeOsc,
    @JsonKey(name: 'ultimate_osc') double? ultimateOsc,
    double? mfi,
    // Trend
    double? macd,
    @JsonKey(name: 'macd_signal') double? macdSignal,
    @JsonKey(name: 'macd_hist') double? macdHist,
    double? adx,
    @JsonKey(name: 'plus_di') double? plusDi,
    @JsonKey(name: 'minus_di') double? minusDi,
    // Moving Averages
    @JsonKey(name: 'ema_9') double? ema9,
    @JsonKey(name: 'ema_20') double? ema20,
    @JsonKey(name: 'ema_50') double? ema50,
    @JsonKey(name: 'sma_10') double? sma10,
    @JsonKey(name: 'sma_20') double? sma20,
    @JsonKey(name: 'sma_50') double? sma50,
    // Ichimoku
    double? tenkan,
    double? kijun,
    // Volatility
    @JsonKey(name: 'bb_upper') double? bbUpper,
    @JsonKey(name: 'bb_middle') double? bbMiddle,
    @JsonKey(name: 'bb_lower') double? bbLower,
    @JsonKey(name: 'bb_width') double? bbWidth,
    double? atr,
    // Volume
    double? obv,
    double? vwap,
    // Price
    double? price,
  }) = _IndicatorValues;

  factory IndicatorValues.fromJson(Map<String, dynamic> json) =>
      _$IndicatorValuesFromJson(json);
}

@freezed
class SupportResistance with _$SupportResistance {
  const factory SupportResistance({
    double? pivot,
    double? s1,
    double? s2,
    double? s3,
    double? r1,
    double? r2,
    double? r3,
  }) = _SupportResistance;

  factory SupportResistance.fromJson(Map<String, dynamic> json) =>
      _$SupportResistanceFromJson(json);
}

@freezed
class TechnicalIndicatorModel with _$TechnicalIndicatorModel {
  const factory TechnicalIndicatorModel({
    required int score,
    required String action,
    required IndicatorValues indicators,
    @JsonKey(name: 'support_resistance') SupportResistance? supportResistance,
  }) = _TechnicalIndicatorModel;

  factory TechnicalIndicatorModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicalIndicatorModelFromJson(json);
}
