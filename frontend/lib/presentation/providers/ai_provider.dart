import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/config/app_config.dart';

part 'ai_provider.g.dart';

@riverpod
Future<String> aiAnalysis(AiAnalysisRef ref, String symbol) async {
  final dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));
  try {
    final response = await dio.get('/market/ai-analysis', queryParameters: {'symbol': symbol});
    if (response.statusCode == 200 && response.data != null) {
      return response.data['data'] as String;
    }
    return 'Analiz verisi alinmadi.';
  } catch (e) {
    return 'AI Analiz hatasi: $e';
  }
}
