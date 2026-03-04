// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kline_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KlineModelImpl _$$KlineModelImplFromJson(Map<String, dynamic> json) =>
    _$KlineModelImpl(
      symbol: json['s'] as String,
      interval: json['i'] as String,
      openTime: (json['t'] as num).toInt(),
      open: json['o'] as String,
      high: json['h'] as String,
      low: json['l'] as String,
      close: json['c'] as String,
      volume: json['v'] as String,
      isClosed: json['x'] as bool,
      eventTime: (json['E'] as num).toInt(),
      isCached: json['_cached'] as bool? ?? false,
    );

Map<String, dynamic> _$$KlineModelImplToJson(_$KlineModelImpl instance) =>
    <String, dynamic>{
      's': instance.symbol,
      'i': instance.interval,
      't': instance.openTime,
      'o': instance.open,
      'h': instance.high,
      'l': instance.low,
      'c': instance.close,
      'v': instance.volume,
      'x': instance.isClosed,
      'E': instance.eventTime,
      '_cached': instance.isCached,
    };
