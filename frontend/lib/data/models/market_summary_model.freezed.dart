// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MarketSummaryModel _$MarketSummaryModelFromJson(Map<String, dynamic> json) {
  return _MarketSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$MarketSummaryModel {
  String get symbol => throw _privateConstructorUsedError;
  String get lastPrice => throw _privateConstructorUsedError;
  String get priceChange => throw _privateConstructorUsedError;
  String get priceChangePercent => throw _privateConstructorUsedError;
  String? get volume => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MarketSummaryModelCopyWith<MarketSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketSummaryModelCopyWith<$Res> {
  factory $MarketSummaryModelCopyWith(
          MarketSummaryModel value, $Res Function(MarketSummaryModel) then) =
      _$MarketSummaryModelCopyWithImpl<$Res, MarketSummaryModel>;
  @useResult
  $Res call(
      {String symbol,
      String lastPrice,
      String priceChange,
      String priceChangePercent,
      String? volume});
}

/// @nodoc
class _$MarketSummaryModelCopyWithImpl<$Res, $Val extends MarketSummaryModel>
    implements $MarketSummaryModelCopyWith<$Res> {
  _$MarketSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? lastPrice = null,
    Object? priceChange = null,
    Object? priceChangePercent = null,
    Object? volume = freezed,
  }) {
    return _then(_value.copyWith(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      lastPrice: null == lastPrice
          ? _value.lastPrice
          : lastPrice // ignore: cast_nullable_to_non_nullable
              as String,
      priceChange: null == priceChange
          ? _value.priceChange
          : priceChange // ignore: cast_nullable_to_non_nullable
              as String,
      priceChangePercent: null == priceChangePercent
          ? _value.priceChangePercent
          : priceChangePercent // ignore: cast_nullable_to_non_nullable
              as String,
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MarketSummaryModelImplCopyWith<$Res>
    implements $MarketSummaryModelCopyWith<$Res> {
  factory _$$MarketSummaryModelImplCopyWith(_$MarketSummaryModelImpl value,
          $Res Function(_$MarketSummaryModelImpl) then) =
      __$$MarketSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String symbol,
      String lastPrice,
      String priceChange,
      String priceChangePercent,
      String? volume});
}

/// @nodoc
class __$$MarketSummaryModelImplCopyWithImpl<$Res>
    extends _$MarketSummaryModelCopyWithImpl<$Res, _$MarketSummaryModelImpl>
    implements _$$MarketSummaryModelImplCopyWith<$Res> {
  __$$MarketSummaryModelImplCopyWithImpl(_$MarketSummaryModelImpl _value,
      $Res Function(_$MarketSummaryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? lastPrice = null,
    Object? priceChange = null,
    Object? priceChangePercent = null,
    Object? volume = freezed,
  }) {
    return _then(_$MarketSummaryModelImpl(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      lastPrice: null == lastPrice
          ? _value.lastPrice
          : lastPrice // ignore: cast_nullable_to_non_nullable
              as String,
      priceChange: null == priceChange
          ? _value.priceChange
          : priceChange // ignore: cast_nullable_to_non_nullable
              as String,
      priceChangePercent: null == priceChangePercent
          ? _value.priceChangePercent
          : priceChangePercent // ignore: cast_nullable_to_non_nullable
              as String,
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketSummaryModelImpl implements _MarketSummaryModel {
  const _$MarketSummaryModelImpl(
      {required this.symbol,
      required this.lastPrice,
      required this.priceChange,
      required this.priceChangePercent,
      this.volume});

  factory _$MarketSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketSummaryModelImplFromJson(json);

  @override
  final String symbol;
  @override
  final String lastPrice;
  @override
  final String priceChange;
  @override
  final String priceChangePercent;
  @override
  final String? volume;

  @override
  String toString() {
    return 'MarketSummaryModel(symbol: $symbol, lastPrice: $lastPrice, priceChange: $priceChange, priceChangePercent: $priceChangePercent, volume: $volume)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketSummaryModelImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.lastPrice, lastPrice) ||
                other.lastPrice == lastPrice) &&
            (identical(other.priceChange, priceChange) ||
                other.priceChange == priceChange) &&
            (identical(other.priceChangePercent, priceChangePercent) ||
                other.priceChangePercent == priceChangePercent) &&
            (identical(other.volume, volume) || other.volume == volume));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, symbol, lastPrice, priceChange, priceChangePercent, volume);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketSummaryModelImplCopyWith<_$MarketSummaryModelImpl> get copyWith =>
      __$$MarketSummaryModelImplCopyWithImpl<_$MarketSummaryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketSummaryModelImplToJson(
      this,
    );
  }
}

abstract class _MarketSummaryModel implements MarketSummaryModel {
  const factory _MarketSummaryModel(
      {required final String symbol,
      required final String lastPrice,
      required final String priceChange,
      required final String priceChangePercent,
      final String? volume}) = _$MarketSummaryModelImpl;

  factory _MarketSummaryModel.fromJson(Map<String, dynamic> json) =
      _$MarketSummaryModelImpl.fromJson;

  @override
  String get symbol;
  @override
  String get lastPrice;
  @override
  String get priceChange;
  @override
  String get priceChangePercent;
  @override
  String? get volume;
  @override
  @JsonKey(ignore: true)
  _$$MarketSummaryModelImplCopyWith<_$MarketSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
