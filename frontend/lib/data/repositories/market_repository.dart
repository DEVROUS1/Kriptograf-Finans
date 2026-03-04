import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/app_config.dart';
import '../models/market_summary_model.dart';
import '../models/technical_indicator_model.dart';

final dioProvider = Provider((ref) => Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)));

final marketRepositoryProvider = Provider((ref) => MarketRepository(ref.watch(dioProvider)));

class MarketRepository {
  final Dio _dio;

  MarketRepository(this._dio);

  Future<List<MarketSummaryModel>> getMarketSummary() async {
    try {
      final response = await _dio.get('/market/summary');
      if (response.statusCode == 200 && response.data != null) {
        final dataList = response.data['data'] as List;
        return dataList.map((e) => MarketSummaryModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load market summary: $e');
    }
  }

  Future<TechnicalIndicatorModel?> getTechnicalIndicators(String symbol, String interval) async {
    try {
      final response = await _dio.get('/market/indicators', queryParameters: {
        'symbol': symbol,
        'interval': interval,
      });
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];
        return TechnicalIndicatorModel.fromJson(data);
      }
      return null;
    } catch (e) {
      // Return null rather than failing the whole screen
      return null;
    }
  }
}
