import 'package:freezed_annotation/freezed_annotation.dart';

part 'kline_model.freezed.dart';
part 'kline_model.g.dart';

/// Backend'den gelen WebSocket payload'ını temsil eden immutable model.
/// freezed: copyWith, equality, toString otomatik üretilir.
/// json_serializable: toJson/fromJson otomatik üretilir.
@freezed
class KlineModel with _$KlineModel {
  const factory KlineModel({
    /// Sembol: "BTCUSDT"
    @JsonKey(name: 's') required String symbol,

    /// Interval: "1m", "5m" vb.
    @JsonKey(name: 'i') required String interval,

    /// Mum açılış zamanı (Unix ms)
    @JsonKey(name: 't') required int openTime,

    /// Fiyatlar String olarak gelir (Decimal precision korunur)
    @JsonKey(name: 'o') required String open,
    @JsonKey(name: 'h') required String high,
    @JsonKey(name: 'l') required String low,
    @JsonKey(name: 'c') required String close,
    @JsonKey(name: 'v') required String volume,

    /// Mum kapandı mı?
    @JsonKey(name: 'x') required bool isClosed,

    /// Event zamanı (Unix ms)
    @JsonKey(name: 'E') required int eventTime,

    /// Cache'den mi geldi? (UI'da staleness göstergesi için)
    @JsonKey(name: '_cached') @Default(false) bool isCached,
  }) = _KlineModel;

  factory KlineModel.fromJson(Map<String, dynamic> json) =>
      _$KlineModelFromJson(json);

  const KlineModel._();

  /// Fiyatı double olarak döndür (chart kütüphaneleri için)
  double get closeAsDouble => double.tryParse(close) ?? 0.0;
  double get openAsDouble => double.tryParse(open) ?? 0.0;
  double get highAsDouble => double.tryParse(high) ?? 0.0;
  double get lowAsDouble => double.tryParse(low) ?? 0.0;
}