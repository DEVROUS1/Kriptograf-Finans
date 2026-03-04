// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kline_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

KlineModel _$KlineModelFromJson(Map<String, dynamic> json) {
  return _KlineModel.fromJson(json);
}

/// @nodoc
mixin _$KlineModel {
  /// Sembol: "BTCUSDT"
  @JsonKey(name: 's')
  String get symbol => throw _privateConstructorUsedError;

  /// Interval: "1m", "5m" vb.
  @JsonKey(name: 'i')
  String get interval => throw _privateConstructorUsedError;

  /// Mum açılış zamanı (Unix ms)
  @JsonKey(name: 't')
  int get openTime => throw _privateConstructorUsedError;

  /// Fiyatlar String olarak gelir (Decimal precision korunur)
  @JsonKey(name: 'o')
  String get open => throw _privateConstructorUsedError;
  @JsonKey(name: 'h')
  String get high => throw _privateConstructorUsedError;
  @JsonKey(name: 'l')
  String get low => throw _privateConstructorUsedError;
  @JsonKey(name: 'c')
  String get close => throw _privateConstructorUsedError;
  @JsonKey(name: 'v')
  String get volume => throw _privateConstructorUsedError;

  /// Mum kapandı mı?
  @JsonKey(name: 'x')
  bool get isClosed => throw _privateConstructorUsedError;

  /// Event zamanı (Unix ms)
  @JsonKey(name: 'E')
  int get eventTime => throw _privateConstructorUsedError;

  /// Cache'den mi geldi? (UI'da staleness göstergesi için)
  @JsonKey(name: '_cached')
  bool get isCached => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $KlineModelCopyWith<KlineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KlineModelCopyWith<$Res> {
  factory $KlineModelCopyWith(
          KlineModel value, $Res Function(KlineModel) then) =
      _$KlineModelCopyWithImpl<$Res, KlineModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 's') String symbol,
      @JsonKey(name: 'i') String interval,
      @JsonKey(name: 't') int openTime,
      @JsonKey(name: 'o') String open,
      @JsonKey(name: 'h') String high,
      @JsonKey(name: 'l') String low,
      @JsonKey(name: 'c') String close,
      @JsonKey(name: 'v') String volume,
      @JsonKey(name: 'x') bool isClosed,
      @JsonKey(name: 'E') int eventTime,
      @JsonKey(name: '_cached') bool isCached});
}

/// @nodoc
class _$KlineModelCopyWithImpl<$Res, $Val extends KlineModel>
    implements $KlineModelCopyWith<$Res> {
  _$KlineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? interval = null,
    Object? openTime = null,
    Object? open = null,
    Object? high = null,
    Object? low = null,
    Object? close = null,
    Object? volume = null,
    Object? isClosed = null,
    Object? eventTime = null,
    Object? isCached = null,
  }) {
    return _then(_value.copyWith(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as String,
      openTime: null == openTime
          ? _value.openTime
          : openTime // ignore: cast_nullable_to_non_nullable
              as int,
      open: null == open
          ? _value.open
          : open // ignore: cast_nullable_to_non_nullable
              as String,
      high: null == high
          ? _value.high
          : high // ignore: cast_nullable_to_non_nullable
              as String,
      low: null == low
          ? _value.low
          : low // ignore: cast_nullable_to_non_nullable
              as String,
      close: null == close
          ? _value.close
          : close // ignore: cast_nullable_to_non_nullable
              as String,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String,
      isClosed: null == isClosed
          ? _value.isClosed
          : isClosed // ignore: cast_nullable_to_non_nullable
              as bool,
      eventTime: null == eventTime
          ? _value.eventTime
          : eventTime // ignore: cast_nullable_to_non_nullable
              as int,
      isCached: null == isCached
          ? _value.isCached
          : isCached // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KlineModelImplCopyWith<$Res>
    implements $KlineModelCopyWith<$Res> {
  factory _$$KlineModelImplCopyWith(
          _$KlineModelImpl value, $Res Function(_$KlineModelImpl) then) =
      __$$KlineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 's') String symbol,
      @JsonKey(name: 'i') String interval,
      @JsonKey(name: 't') int openTime,
      @JsonKey(name: 'o') String open,
      @JsonKey(name: 'h') String high,
      @JsonKey(name: 'l') String low,
      @JsonKey(name: 'c') String close,
      @JsonKey(name: 'v') String volume,
      @JsonKey(name: 'x') bool isClosed,
      @JsonKey(name: 'E') int eventTime,
      @JsonKey(name: '_cached') bool isCached});
}

/// @nodoc
class __$$KlineModelImplCopyWithImpl<$Res>
    extends _$KlineModelCopyWithImpl<$Res, _$KlineModelImpl>
    implements _$$KlineModelImplCopyWith<$Res> {
  __$$KlineModelImplCopyWithImpl(
      _$KlineModelImpl _value, $Res Function(_$KlineModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? interval = null,
    Object? openTime = null,
    Object? open = null,
    Object? high = null,
    Object? low = null,
    Object? close = null,
    Object? volume = null,
    Object? isClosed = null,
    Object? eventTime = null,
    Object? isCached = null,
  }) {
    return _then(_$KlineModelImpl(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as String,
      openTime: null == openTime
          ? _value.openTime
          : openTime // ignore: cast_nullable_to_non_nullable
              as int,
      open: null == open
          ? _value.open
          : open // ignore: cast_nullable_to_non_nullable
              as String,
      high: null == high
          ? _value.high
          : high // ignore: cast_nullable_to_non_nullable
              as String,
      low: null == low
          ? _value.low
          : low // ignore: cast_nullable_to_non_nullable
              as String,
      close: null == close
          ? _value.close
          : close // ignore: cast_nullable_to_non_nullable
              as String,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String,
      isClosed: null == isClosed
          ? _value.isClosed
          : isClosed // ignore: cast_nullable_to_non_nullable
              as bool,
      eventTime: null == eventTime
          ? _value.eventTime
          : eventTime // ignore: cast_nullable_to_non_nullable
              as int,
      isCached: null == isCached
          ? _value.isCached
          : isCached // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KlineModelImpl extends _KlineModel {
  const _$KlineModelImpl(
      {@JsonKey(name: 's') required this.symbol,
      @JsonKey(name: 'i') required this.interval,
      @JsonKey(name: 't') required this.openTime,
      @JsonKey(name: 'o') required this.open,
      @JsonKey(name: 'h') required this.high,
      @JsonKey(name: 'l') required this.low,
      @JsonKey(name: 'c') required this.close,
      @JsonKey(name: 'v') required this.volume,
      @JsonKey(name: 'x') required this.isClosed,
      @JsonKey(name: 'E') required this.eventTime,
      @JsonKey(name: '_cached') this.isCached = false})
      : super._();

  factory _$KlineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$KlineModelImplFromJson(json);

  /// Sembol: "BTCUSDT"
  @override
  @JsonKey(name: 's')
  final String symbol;

  /// Interval: "1m", "5m" vb.
  @override
  @JsonKey(name: 'i')
  final String interval;

  /// Mum açılış zamanı (Unix ms)
  @override
  @JsonKey(name: 't')
  final int openTime;

  /// Fiyatlar String olarak gelir (Decimal precision korunur)
  @override
  @JsonKey(name: 'o')
  final String open;
  @override
  @JsonKey(name: 'h')
  final String high;
  @override
  @JsonKey(name: 'l')
  final String low;
  @override
  @JsonKey(name: 'c')
  final String close;
  @override
  @JsonKey(name: 'v')
  final String volume;

  /// Mum kapandı mı?
  @override
  @JsonKey(name: 'x')
  final bool isClosed;

  /// Event zamanı (Unix ms)
  @override
  @JsonKey(name: 'E')
  final int eventTime;

  /// Cache'den mi geldi? (UI'da staleness göstergesi için)
  @override
  @JsonKey(name: '_cached')
  final bool isCached;

  @override
  String toString() {
    return 'KlineModel(symbol: $symbol, interval: $interval, openTime: $openTime, open: $open, high: $high, low: $low, close: $close, volume: $volume, isClosed: $isClosed, eventTime: $eventTime, isCached: $isCached)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KlineModelImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.openTime, openTime) ||
                other.openTime == openTime) &&
            (identical(other.open, open) || other.open == open) &&
            (identical(other.high, high) || other.high == high) &&
            (identical(other.low, low) || other.low == low) &&
            (identical(other.close, close) || other.close == close) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.isClosed, isClosed) ||
                other.isClosed == isClosed) &&
            (identical(other.eventTime, eventTime) ||
                other.eventTime == eventTime) &&
            (identical(other.isCached, isCached) ||
                other.isCached == isCached));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, symbol, interval, openTime, open,
      high, low, close, volume, isClosed, eventTime, isCached);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$KlineModelImplCopyWith<_$KlineModelImpl> get copyWith =>
      __$$KlineModelImplCopyWithImpl<_$KlineModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KlineModelImplToJson(
      this,
    );
  }
}

abstract class _KlineModel extends KlineModel {
  const factory _KlineModel(
      {@JsonKey(name: 's') required final String symbol,
      @JsonKey(name: 'i') required final String interval,
      @JsonKey(name: 't') required final int openTime,
      @JsonKey(name: 'o') required final String open,
      @JsonKey(name: 'h') required final String high,
      @JsonKey(name: 'l') required final String low,
      @JsonKey(name: 'c') required final String close,
      @JsonKey(name: 'v') required final String volume,
      @JsonKey(name: 'x') required final bool isClosed,
      @JsonKey(name: 'E') required final int eventTime,
      @JsonKey(name: '_cached') final bool isCached}) = _$KlineModelImpl;
  const _KlineModel._() : super._();

  factory _KlineModel.fromJson(Map<String, dynamic> json) =
      _$KlineModelImpl.fromJson;

  @override

  /// Sembol: "BTCUSDT"
  @JsonKey(name: 's')
  String get symbol;
  @override

  /// Interval: "1m", "5m" vb.
  @JsonKey(name: 'i')
  String get interval;
  @override

  /// Mum açılış zamanı (Unix ms)
  @JsonKey(name: 't')
  int get openTime;
  @override

  /// Fiyatlar String olarak gelir (Decimal precision korunur)
  @JsonKey(name: 'o')
  String get open;
  @override
  @JsonKey(name: 'h')
  String get high;
  @override
  @JsonKey(name: 'l')
  String get low;
  @override
  @JsonKey(name: 'c')
  String get close;
  @override
  @JsonKey(name: 'v')
  String get volume;
  @override

  /// Mum kapandı mı?
  @JsonKey(name: 'x')
  bool get isClosed;
  @override

  /// Event zamanı (Unix ms)
  @JsonKey(name: 'E')
  int get eventTime;
  @override

  /// Cache'den mi geldi? (UI'da staleness göstergesi için)
  @JsonKey(name: '_cached')
  bool get isCached;
  @override
  @JsonKey(ignore: true)
  _$$KlineModelImplCopyWith<_$KlineModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
