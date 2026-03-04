import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/indicator_provider.dart';

class TechnicalGaugeWidget extends ConsumerWidget {
  final String symbol;

  const TechnicalGaugeWidget({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We request indicators for a 15m interval to have a reasonable gauge
    final indicatorAsync = ref.watch(technicalIndicatorProvider(symbol: symbol, interval: '15m'));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E222D),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2E39)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Teknik Analiz Motoru (15D)',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          indicatorAsync.when(
            data: (data) {
              if (data == null) {
                return const Center(child: Text("Veri alınamadı", style: TextStyle(color: Colors.white54)));
              }

              // Color determination
              Color gaugeColor;
              if (data.action == 'Buy') {
                gaugeColor = const Color(0xFF089981); // Green
              } else if (data.action == 'Sell') {
                gaugeColor = const Color(0xFFF23645); // Red
              } else {
                gaugeColor = Colors.orange; // Neutral
              }

              return Column(
                children: [
                  // Gauge Chart
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 100, // half-circle height
                      child: CustomPaint(
                        painter: _GaugePainter(score: data.score.toDouble(), color: gaugeColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Score text
                  Text(
                    data.action.toUpperCase(),
                    style: TextStyle(
                      color: gaugeColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Indicator Details
                  _buildIndicatorRow('RSI (14)', data.indicators.rsi?.toStringAsFixed(2) ?? '-'),
                  _buildIndicatorRow('MACD', data.indicators.macd?.toStringAsFixed(2) ?? '-'),
                  _buildIndicatorRow('EMA (20)', data.indicators.ema20?.toStringAsFixed(2) ?? '-'),
                  _buildIndicatorRow('SMA (50)', data.indicators.sma50?.toStringAsFixed(2) ?? '-'),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text("Hata: $err", style: const TextStyle(color: Colors.red))),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double score; // 0 to 100
  final Color color;

  _GaugePainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the background arc (grey)
    final bgPaint = Paint()
      ..color = const Color(0xFF2A2E39)
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    canvas.drawArc(rect, pi, pi, false, bgPaint);

    // Draw the actual score arc
    final fgPaint = Paint()
      ..color = color
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // The angle depends on the score. Score ranges from 0 to 100.
    // Length of the arc should be from 0 to pi (180 degrees).
    final sweepAngle = (score / 100) * pi;
    canvas.drawArc(rect, pi, sweepAngle, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.color != color;
  }
}
