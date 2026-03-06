import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/websocket_service.dart';
import '../providers/kline_provider.dart';

class LivePriceWidget extends ConsumerWidget {
  const LivePriceWidget({super.key, required this.symbol, required this.interval});
  final String symbol;
  final String interval;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final klineState = ref.watch(klineNotifierProvider(symbol, interval));
    final kline = klineState.latestKline;
    final connState = klineState.connectionState;

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 500;

    return Padding(
      padding: EdgeInsets.all(isSmall ? 10 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HEADER ──
          Row(
            children: [
              Text(
                symbol.toUpperCase(),
                style: TextStyle(
                  color: Colors.white, fontSize: isSmall ? 14 : 18, fontWeight: FontWeight.w900, letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 10),
              _ConnectionDot(state: connState),
              const Spacer(),
              if (kline != null && !isSmall) _buildMiniStats(kline),
            ],
          ),
          SizedBox(height: isSmall ? 8 : 12),

          // ── MAIN PRICE ──
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: kline == null
                ? _buildLoadingPlaceholder()
                : _buildPriceRow(kline, isSmall),
          ),
          SizedBox(height: isSmall ? 8 : 12),

          // ── OHLCV BAR ──
          if (kline != null) ...[
            Container(
              width: double.infinity, // Ensure it spans full width
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF21262D)),
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 10,
                spacing: 12,
                children: [
                  _OhlcItem(label: 'ACILIS', value: _fmt(kline.open), color: Colors.white70),
                  _OhlcItem(label: 'EN YUKSEK', value: _fmt(kline.high), color: const Color(0xFF00E676)),
                  _OhlcItem(label: 'EN DUSUK', value: _fmt(kline.low), color: const Color(0xFFF23645)),
                  _OhlcItem(label: 'HACIM', value: _fmtVol(kline.volume), color: const Color(0xFF58A6FF)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),

          // ── REAL-TIME CHART ──
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF21262D).withOpacity(0.5)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildChart(klineState),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(dynamic klineState) {
    final history = klineState.klineHistory as List;
    final latest = klineState.latestKline;

    // Collect close prices
    final List<double> prices = [];
    for (final k in history) {
      prices.add(k.closeAsDouble);
    }
    if (latest != null) {
      prices.add(latest.closeAsDouble);
    }

    if (prices.length < 2) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF58A6FF)),
            const SizedBox(height: 12),
            Text('Grafik verileri yukleniyor...', style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12)),
          ],
        ),
      );
    }

    final isUp = prices.last >= prices.first;
    final chartColor = isUp ? const Color(0xFF00E676) : const Color(0xFFF23645);

    return CustomPaint(
      painter: _PriceChartPainter(prices: prices, color: chartColor),
      size: Size.infinite,
    );
  }

  Widget _buildPriceRow(dynamic kline, bool isSmall) {
    final close = kline.closeAsDouble;
    final open = kline.openAsDouble;
    final isPositive = close >= open;
    final pct = open != 0 ? ((close - open) / open * 100) : 0.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      key: ValueKey(kline.eventTime),
      children: [
        Text(
          '\$${close.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isSmall ? 24 : 36,
            fontWeight: FontWeight.w900,
            color: isPositive ? const Color(0xFF00E676) : const Color(0xFFF23645),
            fontFeatures: const [FontFeature.tabularFigures()],
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: (isPositive ? const Color(0xFF00E676) : const Color(0xFFF23645)).withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${isPositive ? "▲" : "▼"} ${pct.abs().toStringAsFixed(2)}%',
            style: TextStyle(
              color: isPositive ? const Color(0xFF00E676) : const Color(0xFFF23645),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStats(dynamic kline) {
    final close = kline.closeAsDouble;
    final open = kline.openAsDouble;
    final diff = close - open;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF161B22),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${diff >= 0 ? "+" : ""}${diff.toStringAsFixed(2)}',
            style: TextStyle(
              color: diff >= 0 ? const Color(0xFF00E676) : const Color(0xFFF23645),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      height: 40,
      width: 250,
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  String _fmt(String v) {
    final d = double.tryParse(v);
    if (d == null) return v;
    if (d >= 1000) return d.toStringAsFixed(2);
    if (d >= 1) return d.toStringAsFixed(4);
    return d.toStringAsFixed(6);
  }

  String _fmtVol(String v) {
    final d = double.tryParse(v);
    if (d == null) return v;
    if (d >= 1000000) return '${(d / 1000000).toStringAsFixed(2)}M';
    if (d >= 1000) return '${(d / 1000).toStringAsFixed(2)}K';
    return d.toStringAsFixed(2);
  }
}

class _ConnectionDot extends StatelessWidget {
  const _ConnectionDot({required this.state});
  final WsConnectionState state;
  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (state) {
      WsConnectionState.connected => (const Color(0xFF00E676), 'CANLI'),
      WsConnectionState.connecting => (Colors.orange, 'BAGLANIYOR'),
      WsConnectionState.disconnected => (Colors.red, 'BAGLI DEGIL'),
      WsConnectionState.error => (Colors.red, 'HATA'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _OhlcItem extends StatelessWidget {
  const _OhlcItem({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF8B949E), fontSize: 9, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold, fontFeatures: const [FontFeature.tabularFigures()])),
      ],
    );
  }
}

/// Real-time price area chart painter
class _PriceChartPainter extends CustomPainter {
  _PriceChartPainter({required this.prices, required this.color});
  final List<double> prices;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (prices.length < 2 || size.width <= 0 || size.height <= 0) return;

    final double minPrice = prices.reduce((a, b) => a < b ? a : b);
    final double maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final double range = maxPrice - minPrice;
    final double padding = range * 0.05;
    final double effectiveMin = minPrice - padding;
    final double effectiveMax = maxPrice + padding;
    final double effectiveRange = effectiveMax - effectiveMin;

    if (effectiveRange == 0) return;

    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFF21262D).withOpacity(0.4)
      ..strokeWidth = 0.5;

    for (int i = 0; i < 5; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);

      // Price labels
      final priceAtLine = effectiveMax - (effectiveRange * i / 4);
      final tp = TextPainter(
        text: TextSpan(
          text: priceAtLine >= 1000
              ? priceAtLine.toStringAsFixed(0)
              : priceAtLine.toStringAsFixed(2),
          style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 9),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(size.width - tp.width - 4, y + 2));
    }

    // Build path
    final path = Path();
    final linePath = Path();
    final stepX = size.width / (prices.length - 1);

    for (int i = 0; i < prices.length; i++) {
      final x = i * stepX;
      final y = size.height - ((prices[i] - effectiveMin) / effectiveRange * size.height);

      if (i == 0) {
        path.moveTo(x, y);
        linePath.moveTo(x, y);
      } else {
        path.lineTo(x, y);
        linePath.lineTo(x, y);
      }
    }

    // Area fill (gradient below line)
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [color.withOpacity(0.25), color.withOpacity(0.0)],
    );
    canvas.drawPath(
      fillPath,
      Paint()..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Line stroke
    canvas.drawPath(
      linePath,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );

    // Current price dot
    final lastX = (prices.length - 1) * stepX;
    final lastY = size.height - ((prices.last - effectiveMin) / effectiveRange * size.height);
    canvas.drawCircle(
      Offset(lastX, lastY),
      4,
      Paint()..color = color,
    );
    canvas.drawCircle(
      Offset(lastX, lastY),
      6,
      Paint()
        ..color = color.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Current price label
    final priceTp = TextPainter(
      text: TextSpan(
        text: prices.last >= 1000
            ? '\$${prices.last.toStringAsFixed(2)}'
            : '\$${prices.last.toStringAsFixed(4)}',
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final labelX = lastX - priceTp.width - 10;
    priceTp.paint(canvas, Offset(labelX > 0 ? labelX : lastX + 10, lastY - 14));
  }

  @override
  bool shouldRepaint(covariant _PriceChartPainter oldDelegate) {
    return oldDelegate.prices.length != prices.length ||
        (prices.isNotEmpty && oldDelegate.prices.isNotEmpty && oldDelegate.prices.last != prices.last);
  }
}