// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technical_indicator_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IndicatorValuesImpl _$$IndicatorValuesImplFromJson(
        Map<String, dynamic> json) =>
    _$IndicatorValuesImpl(
      rsi: (json['rsi'] as num?)?.toDouble(),
      stochRsi: (json['stoch_rsi'] as num?)?.toDouble(),
      stochK: (json['stoch_k'] as num?)?.toDouble(),
      stochD: (json['stoch_d'] as num?)?.toDouble(),
      cci: (json['cci'] as num?)?.toDouble(),
      williamsR: (json['williams_r'] as num?)?.toDouble(),
      roc: (json['roc'] as num?)?.toDouble(),
      awesomeOsc: (json['awesome_osc'] as num?)?.toDouble(),
      ultimateOsc: (json['ultimate_osc'] as num?)?.toDouble(),
      mfi: (json['mfi'] as num?)?.toDouble(),
      macd: (json['macd'] as num?)?.toDouble(),
      macdSignal: (json['macd_signal'] as num?)?.toDouble(),
      macdHist: (json['macd_hist'] as num?)?.toDouble(),
      adx: (json['adx'] as num?)?.toDouble(),
      plusDi: (json['plus_di'] as num?)?.toDouble(),
      minusDi: (json['minus_di'] as num?)?.toDouble(),
      ema9: (json['ema_9'] as num?)?.toDouble(),
      ema20: (json['ema_20'] as num?)?.toDouble(),
      ema50: (json['ema_50'] as num?)?.toDouble(),
      sma10: (json['sma_10'] as num?)?.toDouble(),
      sma20: (json['sma_20'] as num?)?.toDouble(),
      sma50: (json['sma_50'] as num?)?.toDouble(),
      tenkan: (json['tenkan'] as num?)?.toDouble(),
      kijun: (json['kijun'] as num?)?.toDouble(),
      bbUpper: (json['bb_upper'] as num?)?.toDouble(),
      bbMiddle: (json['bb_middle'] as num?)?.toDouble(),
      bbLower: (json['bb_lower'] as num?)?.toDouble(),
      bbWidth: (json['bb_width'] as num?)?.toDouble(),
      atr: (json['atr'] as num?)?.toDouble(),
      obv: (json['obv'] as num?)?.toDouble(),
      vwap: (json['vwap'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$IndicatorValuesImplToJson(
        _$IndicatorValuesImpl instance) =>
    <String, dynamic>{
      'rsi': instance.rsi,
      'stoch_rsi': instance.stochRsi,
      'stoch_k': instance.stochK,
      'stoch_d': instance.stochD,
      'cci': instance.cci,
      'williams_r': instance.williamsR,
      'roc': instance.roc,
      'awesome_osc': instance.awesomeOsc,
      'ultimate_osc': instance.ultimateOsc,
      'mfi': instance.mfi,
      'macd': instance.macd,
      'macd_signal': instance.macdSignal,
      'macd_hist': instance.macdHist,
      'adx': instance.adx,
      'plus_di': instance.plusDi,
      'minus_di': instance.minusDi,
      'ema_9': instance.ema9,
      'ema_20': instance.ema20,
      'ema_50': instance.ema50,
      'sma_10': instance.sma10,
      'sma_20': instance.sma20,
      'sma_50': instance.sma50,
      'tenkan': instance.tenkan,
      'kijun': instance.kijun,
      'bb_upper': instance.bbUpper,
      'bb_middle': instance.bbMiddle,
      'bb_lower': instance.bbLower,
      'bb_width': instance.bbWidth,
      'atr': instance.atr,
      'obv': instance.obv,
      'vwap': instance.vwap,
      'price': instance.price,
    };

_$SupportResistanceImpl _$$SupportResistanceImplFromJson(
        Map<String, dynamic> json) =>
    _$SupportResistanceImpl(
      pivot: (json['pivot'] as num?)?.toDouble(),
      s1: (json['s1'] as num?)?.toDouble(),
      s2: (json['s2'] as num?)?.toDouble(),
      s3: (json['s3'] as num?)?.toDouble(),
      r1: (json['r1'] as num?)?.toDouble(),
      r2: (json['r2'] as num?)?.toDouble(),
      r3: (json['r3'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$SupportResistanceImplToJson(
        _$SupportResistanceImpl instance) =>
    <String, dynamic>{
      'pivot': instance.pivot,
      's1': instance.s1,
      's2': instance.s2,
      's3': instance.s3,
      'r1': instance.r1,
      'r2': instance.r2,
      'r3': instance.r3,
    };

_$TechnicalIndicatorModelImpl _$$TechnicalIndicatorModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TechnicalIndicatorModelImpl(
      score: (json['score'] as num).toInt(),
      action: json['action'] as String,
      indicators:
          IndicatorValues.fromJson(json['indicators'] as Map<String, dynamic>),
      supportResistance: json['support_resistance'] == null
          ? null
          : SupportResistance.fromJson(
              json['support_resistance'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TechnicalIndicatorModelImplToJson(
        _$TechnicalIndicatorModelImpl instance) =>
    <String, dynamic>{
      'score': instance.score,
      'action': instance.action,
      'indicators': instance.indicators,
      'support_resistance': instance.supportResistance,
    };
