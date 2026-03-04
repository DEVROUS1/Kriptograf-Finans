// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'technical_indicator_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IndicatorValues _$IndicatorValuesFromJson(Map<String, dynamic> json) {
  return _IndicatorValues.fromJson(json);
}

/// @nodoc
mixin _$IndicatorValues {
// Momentum
  double? get rsi => throw _privateConstructorUsedError;
  @JsonKey(name: 'stoch_rsi')
  double? get stochRsi => throw _privateConstructorUsedError;
  @JsonKey(name: 'stoch_k')
  double? get stochK => throw _privateConstructorUsedError;
  @JsonKey(name: 'stoch_d')
  double? get stochD => throw _privateConstructorUsedError;
  double? get cci => throw _privateConstructorUsedError;
  @JsonKey(name: 'williams_r')
  double? get williamsR => throw _privateConstructorUsedError;
  double? get roc => throw _privateConstructorUsedError;
  @JsonKey(name: 'awesome_osc')
  double? get awesomeOsc => throw _privateConstructorUsedError;
  @JsonKey(name: 'ultimate_osc')
  double? get ultimateOsc => throw _privateConstructorUsedError;
  double? get mfi => throw _privateConstructorUsedError; // Trend
  double? get macd => throw _privateConstructorUsedError;
  @JsonKey(name: 'macd_signal')
  double? get macdSignal => throw _privateConstructorUsedError;
  @JsonKey(name: 'macd_hist')
  double? get macdHist => throw _privateConstructorUsedError;
  double? get adx => throw _privateConstructorUsedError;
  @JsonKey(name: 'plus_di')
  double? get plusDi => throw _privateConstructorUsedError;
  @JsonKey(name: 'minus_di')
  double? get minusDi => throw _privateConstructorUsedError; // Moving Averages
  @JsonKey(name: 'ema_9')
  double? get ema9 => throw _privateConstructorUsedError;
  @JsonKey(name: 'ema_20')
  double? get ema20 => throw _privateConstructorUsedError;
  @JsonKey(name: 'ema_50')
  double? get ema50 => throw _privateConstructorUsedError;
  @JsonKey(name: 'sma_10')
  double? get sma10 => throw _privateConstructorUsedError;
  @JsonKey(name: 'sma_20')
  double? get sma20 => throw _privateConstructorUsedError;
  @JsonKey(name: 'sma_50')
  double? get sma50 => throw _privateConstructorUsedError; // Ichimoku
  double? get tenkan => throw _privateConstructorUsedError;
  double? get kijun => throw _privateConstructorUsedError; // Volatility
  @JsonKey(name: 'bb_upper')
  double? get bbUpper => throw _privateConstructorUsedError;
  @JsonKey(name: 'bb_middle')
  double? get bbMiddle => throw _privateConstructorUsedError;
  @JsonKey(name: 'bb_lower')
  double? get bbLower => throw _privateConstructorUsedError;
  @JsonKey(name: 'bb_width')
  double? get bbWidth => throw _privateConstructorUsedError;
  double? get atr => throw _privateConstructorUsedError; // Volume
  double? get obv => throw _privateConstructorUsedError;
  double? get vwap => throw _privateConstructorUsedError; // Price
  double? get price => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IndicatorValuesCopyWith<IndicatorValues> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IndicatorValuesCopyWith<$Res> {
  factory $IndicatorValuesCopyWith(
          IndicatorValues value, $Res Function(IndicatorValues) then) =
      _$IndicatorValuesCopyWithImpl<$Res, IndicatorValues>;
  @useResult
  $Res call(
      {double? rsi,
      @JsonKey(name: 'stoch_rsi') double? stochRsi,
      @JsonKey(name: 'stoch_k') double? stochK,
      @JsonKey(name: 'stoch_d') double? stochD,
      double? cci,
      @JsonKey(name: 'williams_r') double? williamsR,
      double? roc,
      @JsonKey(name: 'awesome_osc') double? awesomeOsc,
      @JsonKey(name: 'ultimate_osc') double? ultimateOsc,
      double? mfi,
      double? macd,
      @JsonKey(name: 'macd_signal') double? macdSignal,
      @JsonKey(name: 'macd_hist') double? macdHist,
      double? adx,
      @JsonKey(name: 'plus_di') double? plusDi,
      @JsonKey(name: 'minus_di') double? minusDi,
      @JsonKey(name: 'ema_9') double? ema9,
      @JsonKey(name: 'ema_20') double? ema20,
      @JsonKey(name: 'ema_50') double? ema50,
      @JsonKey(name: 'sma_10') double? sma10,
      @JsonKey(name: 'sma_20') double? sma20,
      @JsonKey(name: 'sma_50') double? sma50,
      double? tenkan,
      double? kijun,
      @JsonKey(name: 'bb_upper') double? bbUpper,
      @JsonKey(name: 'bb_middle') double? bbMiddle,
      @JsonKey(name: 'bb_lower') double? bbLower,
      @JsonKey(name: 'bb_width') double? bbWidth,
      double? atr,
      double? obv,
      double? vwap,
      double? price});
}

/// @nodoc
class _$IndicatorValuesCopyWithImpl<$Res, $Val extends IndicatorValues>
    implements $IndicatorValuesCopyWith<$Res> {
  _$IndicatorValuesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rsi = freezed,
    Object? stochRsi = freezed,
    Object? stochK = freezed,
    Object? stochD = freezed,
    Object? cci = freezed,
    Object? williamsR = freezed,
    Object? roc = freezed,
    Object? awesomeOsc = freezed,
    Object? ultimateOsc = freezed,
    Object? mfi = freezed,
    Object? macd = freezed,
    Object? macdSignal = freezed,
    Object? macdHist = freezed,
    Object? adx = freezed,
    Object? plusDi = freezed,
    Object? minusDi = freezed,
    Object? ema9 = freezed,
    Object? ema20 = freezed,
    Object? ema50 = freezed,
    Object? sma10 = freezed,
    Object? sma20 = freezed,
    Object? sma50 = freezed,
    Object? tenkan = freezed,
    Object? kijun = freezed,
    Object? bbUpper = freezed,
    Object? bbMiddle = freezed,
    Object? bbLower = freezed,
    Object? bbWidth = freezed,
    Object? atr = freezed,
    Object? obv = freezed,
    Object? vwap = freezed,
    Object? price = freezed,
  }) {
    return _then(_value.copyWith(
      rsi: freezed == rsi
          ? _value.rsi
          : rsi // ignore: cast_nullable_to_non_nullable
              as double?,
      stochRsi: freezed == stochRsi
          ? _value.stochRsi
          : stochRsi // ignore: cast_nullable_to_non_nullable
              as double?,
      stochK: freezed == stochK
          ? _value.stochK
          : stochK // ignore: cast_nullable_to_non_nullable
              as double?,
      stochD: freezed == stochD
          ? _value.stochD
          : stochD // ignore: cast_nullable_to_non_nullable
              as double?,
      cci: freezed == cci
          ? _value.cci
          : cci // ignore: cast_nullable_to_non_nullable
              as double?,
      williamsR: freezed == williamsR
          ? _value.williamsR
          : williamsR // ignore: cast_nullable_to_non_nullable
              as double?,
      roc: freezed == roc
          ? _value.roc
          : roc // ignore: cast_nullable_to_non_nullable
              as double?,
      awesomeOsc: freezed == awesomeOsc
          ? _value.awesomeOsc
          : awesomeOsc // ignore: cast_nullable_to_non_nullable
              as double?,
      ultimateOsc: freezed == ultimateOsc
          ? _value.ultimateOsc
          : ultimateOsc // ignore: cast_nullable_to_non_nullable
              as double?,
      mfi: freezed == mfi
          ? _value.mfi
          : mfi // ignore: cast_nullable_to_non_nullable
              as double?,
      macd: freezed == macd
          ? _value.macd
          : macd // ignore: cast_nullable_to_non_nullable
              as double?,
      macdSignal: freezed == macdSignal
          ? _value.macdSignal
          : macdSignal // ignore: cast_nullable_to_non_nullable
              as double?,
      macdHist: freezed == macdHist
          ? _value.macdHist
          : macdHist // ignore: cast_nullable_to_non_nullable
              as double?,
      adx: freezed == adx
          ? _value.adx
          : adx // ignore: cast_nullable_to_non_nullable
              as double?,
      plusDi: freezed == plusDi
          ? _value.plusDi
          : plusDi // ignore: cast_nullable_to_non_nullable
              as double?,
      minusDi: freezed == minusDi
          ? _value.minusDi
          : minusDi // ignore: cast_nullable_to_non_nullable
              as double?,
      ema9: freezed == ema9
          ? _value.ema9
          : ema9 // ignore: cast_nullable_to_non_nullable
              as double?,
      ema20: freezed == ema20
          ? _value.ema20
          : ema20 // ignore: cast_nullable_to_non_nullable
              as double?,
      ema50: freezed == ema50
          ? _value.ema50
          : ema50 // ignore: cast_nullable_to_non_nullable
              as double?,
      sma10: freezed == sma10
          ? _value.sma10
          : sma10 // ignore: cast_nullable_to_non_nullable
              as double?,
      sma20: freezed == sma20
          ? _value.sma20
          : sma20 // ignore: cast_nullable_to_non_nullable
              as double?,
      sma50: freezed == sma50
          ? _value.sma50
          : sma50 // ignore: cast_nullable_to_non_nullable
              as double?,
      tenkan: freezed == tenkan
          ? _value.tenkan
          : tenkan // ignore: cast_nullable_to_non_nullable
              as double?,
      kijun: freezed == kijun
          ? _value.kijun
          : kijun // ignore: cast_nullable_to_non_nullable
              as double?,
      bbUpper: freezed == bbUpper
          ? _value.bbUpper
          : bbUpper // ignore: cast_nullable_to_non_nullable
              as double?,
      bbMiddle: freezed == bbMiddle
          ? _value.bbMiddle
          : bbMiddle // ignore: cast_nullable_to_non_nullable
              as double?,
      bbLower: freezed == bbLower
          ? _value.bbLower
          : bbLower // ignore: cast_nullable_to_non_nullable
              as double?,
      bbWidth: freezed == bbWidth
          ? _value.bbWidth
          : bbWidth // ignore: cast_nullable_to_non_nullable
              as double?,
      atr: freezed == atr
          ? _value.atr
          : atr // ignore: cast_nullable_to_non_nullable
              as double?,
      obv: freezed == obv
          ? _value.obv
          : obv // ignore: cast_nullable_to_non_nullable
              as double?,
      vwap: freezed == vwap
          ? _value.vwap
          : vwap // ignore: cast_nullable_to_non_nullable
              as double?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IndicatorValuesImplCopyWith<$Res>
    implements $IndicatorValuesCopyWith<$Res> {
  factory _$$IndicatorValuesImplCopyWith(_$IndicatorValuesImpl value,
          $Res Function(_$IndicatorValuesImpl) then) =
      __$$IndicatorValuesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? rsi,
      @JsonKey(name: 'stoch_rsi') double? stochRsi,
      @JsonKey(name: 'stoch_k') double? stochK,
      @JsonKey(name: 'stoch_d') double? stochD,
      double? cci,
      @JsonKey(name: 'williams_r') double? williamsR,
      double? roc,
      @JsonKey(name: 'awesome_osc') double? awesomeOsc,
      @JsonKey(name: 'ultimate_osc') double? ultimateOsc,
      double? mfi,
      double? macd,
      @JsonKey(name: 'macd_signal') double? macdSignal,
      @JsonKey(name: 'macd_hist') double? macdHist,
      double? adx,
      @JsonKey(name: 'plus_di') double? plusDi,
      @JsonKey(name: 'minus_di') double? minusDi,
      @JsonKey(name: 'ema_9') double? ema9,
      @JsonKey(name: 'ema_20') double? ema20,
      @JsonKey(name: 'ema_50') double? ema50,
      @JsonKey(name: 'sma_10') double? sma10,
      @JsonKey(name: 'sma_20') double? sma20,
      @JsonKey(name: 'sma_50') double? sma50,
      double? tenkan,
      double? kijun,
      @JsonKey(name: 'bb_upper') double? bbUpper,
      @JsonKey(name: 'bb_middle') double? bbMiddle,
      @JsonKey(name: 'bb_lower') double? bbLower,
      @JsonKey(name: 'bb_width') double? bbWidth,
      double? atr,
      double? obv,
      double? vwap,
      double? price});
}

/// @nodoc
class __$$IndicatorValuesImplCopyWithImpl<$Res>
    extends _$IndicatorValuesCopyWithImpl<$Res, _$IndicatorValuesImpl>
    implements _$$IndicatorValuesImplCopyWith<$Res> {
  __$$IndicatorValuesImplCopyWithImpl(
      _$IndicatorValuesImpl _value, $Res Function(_$IndicatorValuesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rsi = freezed,
    Object? stochRsi = freezed,
    Object? stochK = freezed,
    Object? stochD = freezed,
    Object? cci = freezed,
    Object? williamsR = freezed,
    Object? roc = freezed,
    Object? awesomeOsc = freezed,
    Object? ultimateOsc = freezed,
    Object? mfi = freezed,
    Object? macd = freezed,
    Object? macdSignal = freezed,
    Object? macdHist = freezed,
    Object? adx = freezed,
    Object? plusDi = freezed,
    Object? minusDi = freezed,
    Object? ema9 = freezed,
    Object? ema20 = freezed,
    Object? ema50 = freezed,
    Object? sma10 = freezed,
    Object? sma20 = freezed,
    Object? sma50 = freezed,
    Object? tenkan = freezed,
    Object? kijun = freezed,
    Object? bbUpper = freezed,
    Object? bbMiddle = freezed,
    Object? bbLower = freezed,
    Object? bbWidth = freezed,
    Object? atr = freezed,
    Object? obv = freezed,
    Object? vwap = freezed,
    Object? price = freezed,
  }) {
    return _then(_$IndicatorValuesImpl(
      rsi: freezed == rsi
          ? _value.rsi
          : rsi // ignore: cast_nullable_to_non_nullable
              as double?,
      stochRsi: freezed == stochRsi
          ? _value.stochRsi
          : stochRsi // ignore: cast_nullable_to_non_nullable
              as double?,
      stochK: freezed == stochK
          ? _value.stochK
          : stochK // ignore: cast_nullable_to_non_nullable
              as double?,
      stochD: freezed == stochD
          ? _value.stochD
          : stochD // ignore: cast_nullable_to_non_nullable
              as double?,
      cci: freezed == cci
          ? _value.cci
          : cci // ignore: cast_nullable_to_non_nullable
              as double?,
      williamsR: freezed == williamsR
          ? _value.williamsR
          : williamsR // ignore: cast_nullable_to_non_nullable
              as double?,
      roc: freezed == roc
          ? _value.roc
          : roc // ignore: cast_nullable_to_non_nullable
              as double?,
      awesomeOsc: freezed == awesomeOsc
          ? _value.awesomeOsc
          : awesomeOsc // ignore: cast_nullable_to_non_nullable
              as double?,
      ultimateOsc: freezed == ultimateOsc
          ? _value.ultimateOsc
          : ultimateOsc // ignore: cast_nullable_to_non_nullable
              as double?,
      mfi: freezed == mfi
          ? _value.mfi
          : mfi // ignore: cast_nullable_to_non_nullable
              as double?,
      macd: freezed == macd
          ? _value.macd
          : macd // ignore: cast_nullable_to_non_nullable
              as double?,
      macdSignal: freezed == macdSignal
          ? _value.macdSignal
          : macdSignal // ignore: cast_nullable_to_non_nullable
              as double?,
      macdHist: freezed == macdHist
          ? _value.macdHist
          : macdHist // ignore: cast_nullable_to_non_nullable
              as double?,
      adx: freezed == adx
          ? _value.adx
          : adx // ignore: cast_nullable_to_non_nullable
              as double?,
      plusDi: freezed == plusDi
          ? _value.plusDi
          : plusDi // ignore: cast_nullable_to_non_nullable
              as double?,
      minusDi: freezed == minusDi
          ? _value.minusDi
          : minusDi // ignore: cast_nullable_to_non_nullable
              as double?,
      ema9: freezed == ema9
          ? _value.ema9
          : ema9 // ignore: cast_nullable_to_non_nullable
              as double?,
      ema20: freezed == ema20
          ? _value.ema20
          : ema20 // ignore: cast_nullable_to_non_nullable
              as double?,
      ema50: freezed == ema50
          ? _value.ema50
          : ema50 // ignore: cast_nullable_to_non_nullable
              as double?,
      sma10: freezed == sma10
          ? _value.sma10
          : sma10 // ignore: cast_nullable_to_non_nullable
              as double?,
      sma20: freezed == sma20
          ? _value.sma20
          : sma20 // ignore: cast_nullable_to_non_nullable
              as double?,
      sma50: freezed == sma50
          ? _value.sma50
          : sma50 // ignore: cast_nullable_to_non_nullable
              as double?,
      tenkan: freezed == tenkan
          ? _value.tenkan
          : tenkan // ignore: cast_nullable_to_non_nullable
              as double?,
      kijun: freezed == kijun
          ? _value.kijun
          : kijun // ignore: cast_nullable_to_non_nullable
              as double?,
      bbUpper: freezed == bbUpper
          ? _value.bbUpper
          : bbUpper // ignore: cast_nullable_to_non_nullable
              as double?,
      bbMiddle: freezed == bbMiddle
          ? _value.bbMiddle
          : bbMiddle // ignore: cast_nullable_to_non_nullable
              as double?,
      bbLower: freezed == bbLower
          ? _value.bbLower
          : bbLower // ignore: cast_nullable_to_non_nullable
              as double?,
      bbWidth: freezed == bbWidth
          ? _value.bbWidth
          : bbWidth // ignore: cast_nullable_to_non_nullable
              as double?,
      atr: freezed == atr
          ? _value.atr
          : atr // ignore: cast_nullable_to_non_nullable
              as double?,
      obv: freezed == obv
          ? _value.obv
          : obv // ignore: cast_nullable_to_non_nullable
              as double?,
      vwap: freezed == vwap
          ? _value.vwap
          : vwap // ignore: cast_nullable_to_non_nullable
              as double?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IndicatorValuesImpl implements _IndicatorValues {
  const _$IndicatorValuesImpl(
      {this.rsi,
      @JsonKey(name: 'stoch_rsi') this.stochRsi,
      @JsonKey(name: 'stoch_k') this.stochK,
      @JsonKey(name: 'stoch_d') this.stochD,
      this.cci,
      @JsonKey(name: 'williams_r') this.williamsR,
      this.roc,
      @JsonKey(name: 'awesome_osc') this.awesomeOsc,
      @JsonKey(name: 'ultimate_osc') this.ultimateOsc,
      this.mfi,
      this.macd,
      @JsonKey(name: 'macd_signal') this.macdSignal,
      @JsonKey(name: 'macd_hist') this.macdHist,
      this.adx,
      @JsonKey(name: 'plus_di') this.plusDi,
      @JsonKey(name: 'minus_di') this.minusDi,
      @JsonKey(name: 'ema_9') this.ema9,
      @JsonKey(name: 'ema_20') this.ema20,
      @JsonKey(name: 'ema_50') this.ema50,
      @JsonKey(name: 'sma_10') this.sma10,
      @JsonKey(name: 'sma_20') this.sma20,
      @JsonKey(name: 'sma_50') this.sma50,
      this.tenkan,
      this.kijun,
      @JsonKey(name: 'bb_upper') this.bbUpper,
      @JsonKey(name: 'bb_middle') this.bbMiddle,
      @JsonKey(name: 'bb_lower') this.bbLower,
      @JsonKey(name: 'bb_width') this.bbWidth,
      this.atr,
      this.obv,
      this.vwap,
      this.price});

  factory _$IndicatorValuesImpl.fromJson(Map<String, dynamic> json) =>
      _$$IndicatorValuesImplFromJson(json);

// Momentum
  @override
  final double? rsi;
  @override
  @JsonKey(name: 'stoch_rsi')
  final double? stochRsi;
  @override
  @JsonKey(name: 'stoch_k')
  final double? stochK;
  @override
  @JsonKey(name: 'stoch_d')
  final double? stochD;
  @override
  final double? cci;
  @override
  @JsonKey(name: 'williams_r')
  final double? williamsR;
  @override
  final double? roc;
  @override
  @JsonKey(name: 'awesome_osc')
  final double? awesomeOsc;
  @override
  @JsonKey(name: 'ultimate_osc')
  final double? ultimateOsc;
  @override
  final double? mfi;
// Trend
  @override
  final double? macd;
  @override
  @JsonKey(name: 'macd_signal')
  final double? macdSignal;
  @override
  @JsonKey(name: 'macd_hist')
  final double? macdHist;
  @override
  final double? adx;
  @override
  @JsonKey(name: 'plus_di')
  final double? plusDi;
  @override
  @JsonKey(name: 'minus_di')
  final double? minusDi;
// Moving Averages
  @override
  @JsonKey(name: 'ema_9')
  final double? ema9;
  @override
  @JsonKey(name: 'ema_20')
  final double? ema20;
  @override
  @JsonKey(name: 'ema_50')
  final double? ema50;
  @override
  @JsonKey(name: 'sma_10')
  final double? sma10;
  @override
  @JsonKey(name: 'sma_20')
  final double? sma20;
  @override
  @JsonKey(name: 'sma_50')
  final double? sma50;
// Ichimoku
  @override
  final double? tenkan;
  @override
  final double? kijun;
// Volatility
  @override
  @JsonKey(name: 'bb_upper')
  final double? bbUpper;
  @override
  @JsonKey(name: 'bb_middle')
  final double? bbMiddle;
  @override
  @JsonKey(name: 'bb_lower')
  final double? bbLower;
  @override
  @JsonKey(name: 'bb_width')
  final double? bbWidth;
  @override
  final double? atr;
// Volume
  @override
  final double? obv;
  @override
  final double? vwap;
// Price
  @override
  final double? price;

  @override
  String toString() {
    return 'IndicatorValues(rsi: $rsi, stochRsi: $stochRsi, stochK: $stochK, stochD: $stochD, cci: $cci, williamsR: $williamsR, roc: $roc, awesomeOsc: $awesomeOsc, ultimateOsc: $ultimateOsc, mfi: $mfi, macd: $macd, macdSignal: $macdSignal, macdHist: $macdHist, adx: $adx, plusDi: $plusDi, minusDi: $minusDi, ema9: $ema9, ema20: $ema20, ema50: $ema50, sma10: $sma10, sma20: $sma20, sma50: $sma50, tenkan: $tenkan, kijun: $kijun, bbUpper: $bbUpper, bbMiddle: $bbMiddle, bbLower: $bbLower, bbWidth: $bbWidth, atr: $atr, obv: $obv, vwap: $vwap, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IndicatorValuesImpl &&
            (identical(other.rsi, rsi) || other.rsi == rsi) &&
            (identical(other.stochRsi, stochRsi) ||
                other.stochRsi == stochRsi) &&
            (identical(other.stochK, stochK) || other.stochK == stochK) &&
            (identical(other.stochD, stochD) || other.stochD == stochD) &&
            (identical(other.cci, cci) || other.cci == cci) &&
            (identical(other.williamsR, williamsR) ||
                other.williamsR == williamsR) &&
            (identical(other.roc, roc) || other.roc == roc) &&
            (identical(other.awesomeOsc, awesomeOsc) ||
                other.awesomeOsc == awesomeOsc) &&
            (identical(other.ultimateOsc, ultimateOsc) ||
                other.ultimateOsc == ultimateOsc) &&
            (identical(other.mfi, mfi) || other.mfi == mfi) &&
            (identical(other.macd, macd) || other.macd == macd) &&
            (identical(other.macdSignal, macdSignal) ||
                other.macdSignal == macdSignal) &&
            (identical(other.macdHist, macdHist) ||
                other.macdHist == macdHist) &&
            (identical(other.adx, adx) || other.adx == adx) &&
            (identical(other.plusDi, plusDi) || other.plusDi == plusDi) &&
            (identical(other.minusDi, minusDi) || other.minusDi == minusDi) &&
            (identical(other.ema9, ema9) || other.ema9 == ema9) &&
            (identical(other.ema20, ema20) || other.ema20 == ema20) &&
            (identical(other.ema50, ema50) || other.ema50 == ema50) &&
            (identical(other.sma10, sma10) || other.sma10 == sma10) &&
            (identical(other.sma20, sma20) || other.sma20 == sma20) &&
            (identical(other.sma50, sma50) || other.sma50 == sma50) &&
            (identical(other.tenkan, tenkan) || other.tenkan == tenkan) &&
            (identical(other.kijun, kijun) || other.kijun == kijun) &&
            (identical(other.bbUpper, bbUpper) || other.bbUpper == bbUpper) &&
            (identical(other.bbMiddle, bbMiddle) ||
                other.bbMiddle == bbMiddle) &&
            (identical(other.bbLower, bbLower) || other.bbLower == bbLower) &&
            (identical(other.bbWidth, bbWidth) || other.bbWidth == bbWidth) &&
            (identical(other.atr, atr) || other.atr == atr) &&
            (identical(other.obv, obv) || other.obv == obv) &&
            (identical(other.vwap, vwap) || other.vwap == vwap) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        rsi,
        stochRsi,
        stochK,
        stochD,
        cci,
        williamsR,
        roc,
        awesomeOsc,
        ultimateOsc,
        mfi,
        macd,
        macdSignal,
        macdHist,
        adx,
        plusDi,
        minusDi,
        ema9,
        ema20,
        ema50,
        sma10,
        sma20,
        sma50,
        tenkan,
        kijun,
        bbUpper,
        bbMiddle,
        bbLower,
        bbWidth,
        atr,
        obv,
        vwap,
        price
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IndicatorValuesImplCopyWith<_$IndicatorValuesImpl> get copyWith =>
      __$$IndicatorValuesImplCopyWithImpl<_$IndicatorValuesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IndicatorValuesImplToJson(
      this,
    );
  }
}

abstract class _IndicatorValues implements IndicatorValues {
  const factory _IndicatorValues(
      {final double? rsi,
      @JsonKey(name: 'stoch_rsi') final double? stochRsi,
      @JsonKey(name: 'stoch_k') final double? stochK,
      @JsonKey(name: 'stoch_d') final double? stochD,
      final double? cci,
      @JsonKey(name: 'williams_r') final double? williamsR,
      final double? roc,
      @JsonKey(name: 'awesome_osc') final double? awesomeOsc,
      @JsonKey(name: 'ultimate_osc') final double? ultimateOsc,
      final double? mfi,
      final double? macd,
      @JsonKey(name: 'macd_signal') final double? macdSignal,
      @JsonKey(name: 'macd_hist') final double? macdHist,
      final double? adx,
      @JsonKey(name: 'plus_di') final double? plusDi,
      @JsonKey(name: 'minus_di') final double? minusDi,
      @JsonKey(name: 'ema_9') final double? ema9,
      @JsonKey(name: 'ema_20') final double? ema20,
      @JsonKey(name: 'ema_50') final double? ema50,
      @JsonKey(name: 'sma_10') final double? sma10,
      @JsonKey(name: 'sma_20') final double? sma20,
      @JsonKey(name: 'sma_50') final double? sma50,
      final double? tenkan,
      final double? kijun,
      @JsonKey(name: 'bb_upper') final double? bbUpper,
      @JsonKey(name: 'bb_middle') final double? bbMiddle,
      @JsonKey(name: 'bb_lower') final double? bbLower,
      @JsonKey(name: 'bb_width') final double? bbWidth,
      final double? atr,
      final double? obv,
      final double? vwap,
      final double? price}) = _$IndicatorValuesImpl;

  factory _IndicatorValues.fromJson(Map<String, dynamic> json) =
      _$IndicatorValuesImpl.fromJson;

  @override // Momentum
  double? get rsi;
  @override
  @JsonKey(name: 'stoch_rsi')
  double? get stochRsi;
  @override
  @JsonKey(name: 'stoch_k')
  double? get stochK;
  @override
  @JsonKey(name: 'stoch_d')
  double? get stochD;
  @override
  double? get cci;
  @override
  @JsonKey(name: 'williams_r')
  double? get williamsR;
  @override
  double? get roc;
  @override
  @JsonKey(name: 'awesome_osc')
  double? get awesomeOsc;
  @override
  @JsonKey(name: 'ultimate_osc')
  double? get ultimateOsc;
  @override
  double? get mfi;
  @override // Trend
  double? get macd;
  @override
  @JsonKey(name: 'macd_signal')
  double? get macdSignal;
  @override
  @JsonKey(name: 'macd_hist')
  double? get macdHist;
  @override
  double? get adx;
  @override
  @JsonKey(name: 'plus_di')
  double? get plusDi;
  @override
  @JsonKey(name: 'minus_di')
  double? get minusDi;
  @override // Moving Averages
  @JsonKey(name: 'ema_9')
  double? get ema9;
  @override
  @JsonKey(name: 'ema_20')
  double? get ema20;
  @override
  @JsonKey(name: 'ema_50')
  double? get ema50;
  @override
  @JsonKey(name: 'sma_10')
  double? get sma10;
  @override
  @JsonKey(name: 'sma_20')
  double? get sma20;
  @override
  @JsonKey(name: 'sma_50')
  double? get sma50;
  @override // Ichimoku
  double? get tenkan;
  @override
  double? get kijun;
  @override // Volatility
  @JsonKey(name: 'bb_upper')
  double? get bbUpper;
  @override
  @JsonKey(name: 'bb_middle')
  double? get bbMiddle;
  @override
  @JsonKey(name: 'bb_lower')
  double? get bbLower;
  @override
  @JsonKey(name: 'bb_width')
  double? get bbWidth;
  @override
  double? get atr;
  @override // Volume
  double? get obv;
  @override
  double? get vwap;
  @override // Price
  double? get price;
  @override
  @JsonKey(ignore: true)
  _$$IndicatorValuesImplCopyWith<_$IndicatorValuesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SupportResistance _$SupportResistanceFromJson(Map<String, dynamic> json) {
  return _SupportResistance.fromJson(json);
}

/// @nodoc
mixin _$SupportResistance {
  double? get pivot => throw _privateConstructorUsedError;
  double? get s1 => throw _privateConstructorUsedError;
  double? get s2 => throw _privateConstructorUsedError;
  double? get s3 => throw _privateConstructorUsedError;
  double? get r1 => throw _privateConstructorUsedError;
  double? get r2 => throw _privateConstructorUsedError;
  double? get r3 => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SupportResistanceCopyWith<SupportResistance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupportResistanceCopyWith<$Res> {
  factory $SupportResistanceCopyWith(
          SupportResistance value, $Res Function(SupportResistance) then) =
      _$SupportResistanceCopyWithImpl<$Res, SupportResistance>;
  @useResult
  $Res call(
      {double? pivot,
      double? s1,
      double? s2,
      double? s3,
      double? r1,
      double? r2,
      double? r3});
}

/// @nodoc
class _$SupportResistanceCopyWithImpl<$Res, $Val extends SupportResistance>
    implements $SupportResistanceCopyWith<$Res> {
  _$SupportResistanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pivot = freezed,
    Object? s1 = freezed,
    Object? s2 = freezed,
    Object? s3 = freezed,
    Object? r1 = freezed,
    Object? r2 = freezed,
    Object? r3 = freezed,
  }) {
    return _then(_value.copyWith(
      pivot: freezed == pivot
          ? _value.pivot
          : pivot // ignore: cast_nullable_to_non_nullable
              as double?,
      s1: freezed == s1
          ? _value.s1
          : s1 // ignore: cast_nullable_to_non_nullable
              as double?,
      s2: freezed == s2
          ? _value.s2
          : s2 // ignore: cast_nullable_to_non_nullable
              as double?,
      s3: freezed == s3
          ? _value.s3
          : s3 // ignore: cast_nullable_to_non_nullable
              as double?,
      r1: freezed == r1
          ? _value.r1
          : r1 // ignore: cast_nullable_to_non_nullable
              as double?,
      r2: freezed == r2
          ? _value.r2
          : r2 // ignore: cast_nullable_to_non_nullable
              as double?,
      r3: freezed == r3
          ? _value.r3
          : r3 // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SupportResistanceImplCopyWith<$Res>
    implements $SupportResistanceCopyWith<$Res> {
  factory _$$SupportResistanceImplCopyWith(_$SupportResistanceImpl value,
          $Res Function(_$SupportResistanceImpl) then) =
      __$$SupportResistanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? pivot,
      double? s1,
      double? s2,
      double? s3,
      double? r1,
      double? r2,
      double? r3});
}

/// @nodoc
class __$$SupportResistanceImplCopyWithImpl<$Res>
    extends _$SupportResistanceCopyWithImpl<$Res, _$SupportResistanceImpl>
    implements _$$SupportResistanceImplCopyWith<$Res> {
  __$$SupportResistanceImplCopyWithImpl(_$SupportResistanceImpl _value,
      $Res Function(_$SupportResistanceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pivot = freezed,
    Object? s1 = freezed,
    Object? s2 = freezed,
    Object? s3 = freezed,
    Object? r1 = freezed,
    Object? r2 = freezed,
    Object? r3 = freezed,
  }) {
    return _then(_$SupportResistanceImpl(
      pivot: freezed == pivot
          ? _value.pivot
          : pivot // ignore: cast_nullable_to_non_nullable
              as double?,
      s1: freezed == s1
          ? _value.s1
          : s1 // ignore: cast_nullable_to_non_nullable
              as double?,
      s2: freezed == s2
          ? _value.s2
          : s2 // ignore: cast_nullable_to_non_nullable
              as double?,
      s3: freezed == s3
          ? _value.s3
          : s3 // ignore: cast_nullable_to_non_nullable
              as double?,
      r1: freezed == r1
          ? _value.r1
          : r1 // ignore: cast_nullable_to_non_nullable
              as double?,
      r2: freezed == r2
          ? _value.r2
          : r2 // ignore: cast_nullable_to_non_nullable
              as double?,
      r3: freezed == r3
          ? _value.r3
          : r3 // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SupportResistanceImpl implements _SupportResistance {
  const _$SupportResistanceImpl(
      {this.pivot, this.s1, this.s2, this.s3, this.r1, this.r2, this.r3});

  factory _$SupportResistanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupportResistanceImplFromJson(json);

  @override
  final double? pivot;
  @override
  final double? s1;
  @override
  final double? s2;
  @override
  final double? s3;
  @override
  final double? r1;
  @override
  final double? r2;
  @override
  final double? r3;

  @override
  String toString() {
    return 'SupportResistance(pivot: $pivot, s1: $s1, s2: $s2, s3: $s3, r1: $r1, r2: $r2, r3: $r3)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupportResistanceImpl &&
            (identical(other.pivot, pivot) || other.pivot == pivot) &&
            (identical(other.s1, s1) || other.s1 == s1) &&
            (identical(other.s2, s2) || other.s2 == s2) &&
            (identical(other.s3, s3) || other.s3 == s3) &&
            (identical(other.r1, r1) || other.r1 == r1) &&
            (identical(other.r2, r2) || other.r2 == r2) &&
            (identical(other.r3, r3) || other.r3 == r3));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, pivot, s1, s2, s3, r1, r2, r3);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SupportResistanceImplCopyWith<_$SupportResistanceImpl> get copyWith =>
      __$$SupportResistanceImplCopyWithImpl<_$SupportResistanceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SupportResistanceImplToJson(
      this,
    );
  }
}

abstract class _SupportResistance implements SupportResistance {
  const factory _SupportResistance(
      {final double? pivot,
      final double? s1,
      final double? s2,
      final double? s3,
      final double? r1,
      final double? r2,
      final double? r3}) = _$SupportResistanceImpl;

  factory _SupportResistance.fromJson(Map<String, dynamic> json) =
      _$SupportResistanceImpl.fromJson;

  @override
  double? get pivot;
  @override
  double? get s1;
  @override
  double? get s2;
  @override
  double? get s3;
  @override
  double? get r1;
  @override
  double? get r2;
  @override
  double? get r3;
  @override
  @JsonKey(ignore: true)
  _$$SupportResistanceImplCopyWith<_$SupportResistanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TechnicalIndicatorModel _$TechnicalIndicatorModelFromJson(
    Map<String, dynamic> json) {
  return _TechnicalIndicatorModel.fromJson(json);
}

/// @nodoc
mixin _$TechnicalIndicatorModel {
  int get score => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  IndicatorValues get indicators => throw _privateConstructorUsedError;
  @JsonKey(name: 'support_resistance')
  SupportResistance? get supportResistance =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TechnicalIndicatorModelCopyWith<TechnicalIndicatorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TechnicalIndicatorModelCopyWith<$Res> {
  factory $TechnicalIndicatorModelCopyWith(TechnicalIndicatorModel value,
          $Res Function(TechnicalIndicatorModel) then) =
      _$TechnicalIndicatorModelCopyWithImpl<$Res, TechnicalIndicatorModel>;
  @useResult
  $Res call(
      {int score,
      String action,
      IndicatorValues indicators,
      @JsonKey(name: 'support_resistance')
      SupportResistance? supportResistance});

  $IndicatorValuesCopyWith<$Res> get indicators;
  $SupportResistanceCopyWith<$Res>? get supportResistance;
}

/// @nodoc
class _$TechnicalIndicatorModelCopyWithImpl<$Res,
        $Val extends TechnicalIndicatorModel>
    implements $TechnicalIndicatorModelCopyWith<$Res> {
  _$TechnicalIndicatorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? action = null,
    Object? indicators = null,
    Object? supportResistance = freezed,
  }) {
    return _then(_value.copyWith(
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      indicators: null == indicators
          ? _value.indicators
          : indicators // ignore: cast_nullable_to_non_nullable
              as IndicatorValues,
      supportResistance: freezed == supportResistance
          ? _value.supportResistance
          : supportResistance // ignore: cast_nullable_to_non_nullable
              as SupportResistance?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $IndicatorValuesCopyWith<$Res> get indicators {
    return $IndicatorValuesCopyWith<$Res>(_value.indicators, (value) {
      return _then(_value.copyWith(indicators: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SupportResistanceCopyWith<$Res>? get supportResistance {
    if (_value.supportResistance == null) {
      return null;
    }

    return $SupportResistanceCopyWith<$Res>(_value.supportResistance!, (value) {
      return _then(_value.copyWith(supportResistance: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TechnicalIndicatorModelImplCopyWith<$Res>
    implements $TechnicalIndicatorModelCopyWith<$Res> {
  factory _$$TechnicalIndicatorModelImplCopyWith(
          _$TechnicalIndicatorModelImpl value,
          $Res Function(_$TechnicalIndicatorModelImpl) then) =
      __$$TechnicalIndicatorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int score,
      String action,
      IndicatorValues indicators,
      @JsonKey(name: 'support_resistance')
      SupportResistance? supportResistance});

  @override
  $IndicatorValuesCopyWith<$Res> get indicators;
  @override
  $SupportResistanceCopyWith<$Res>? get supportResistance;
}

/// @nodoc
class __$$TechnicalIndicatorModelImplCopyWithImpl<$Res>
    extends _$TechnicalIndicatorModelCopyWithImpl<$Res,
        _$TechnicalIndicatorModelImpl>
    implements _$$TechnicalIndicatorModelImplCopyWith<$Res> {
  __$$TechnicalIndicatorModelImplCopyWithImpl(
      _$TechnicalIndicatorModelImpl _value,
      $Res Function(_$TechnicalIndicatorModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? action = null,
    Object? indicators = null,
    Object? supportResistance = freezed,
  }) {
    return _then(_$TechnicalIndicatorModelImpl(
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      indicators: null == indicators
          ? _value.indicators
          : indicators // ignore: cast_nullable_to_non_nullable
              as IndicatorValues,
      supportResistance: freezed == supportResistance
          ? _value.supportResistance
          : supportResistance // ignore: cast_nullable_to_non_nullable
              as SupportResistance?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TechnicalIndicatorModelImpl implements _TechnicalIndicatorModel {
  const _$TechnicalIndicatorModelImpl(
      {required this.score,
      required this.action,
      required this.indicators,
      @JsonKey(name: 'support_resistance') this.supportResistance});

  factory _$TechnicalIndicatorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TechnicalIndicatorModelImplFromJson(json);

  @override
  final int score;
  @override
  final String action;
  @override
  final IndicatorValues indicators;
  @override
  @JsonKey(name: 'support_resistance')
  final SupportResistance? supportResistance;

  @override
  String toString() {
    return 'TechnicalIndicatorModel(score: $score, action: $action, indicators: $indicators, supportResistance: $supportResistance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TechnicalIndicatorModelImpl &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.indicators, indicators) ||
                other.indicators == indicators) &&
            (identical(other.supportResistance, supportResistance) ||
                other.supportResistance == supportResistance));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, score, action, indicators, supportResistance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TechnicalIndicatorModelImplCopyWith<_$TechnicalIndicatorModelImpl>
      get copyWith => __$$TechnicalIndicatorModelImplCopyWithImpl<
          _$TechnicalIndicatorModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TechnicalIndicatorModelImplToJson(
      this,
    );
  }
}

abstract class _TechnicalIndicatorModel implements TechnicalIndicatorModel {
  const factory _TechnicalIndicatorModel(
          {required final int score,
          required final String action,
          required final IndicatorValues indicators,
          @JsonKey(name: 'support_resistance')
          final SupportResistance? supportResistance}) =
      _$TechnicalIndicatorModelImpl;

  factory _TechnicalIndicatorModel.fromJson(Map<String, dynamic> json) =
      _$TechnicalIndicatorModelImpl.fromJson;

  @override
  int get score;
  @override
  String get action;
  @override
  IndicatorValues get indicators;
  @override
  @JsonKey(name: 'support_resistance')
  SupportResistance? get supportResistance;
  @override
  @JsonKey(ignore: true)
  _$$TechnicalIndicatorModelImplCopyWith<_$TechnicalIndicatorModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
