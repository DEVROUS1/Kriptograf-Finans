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

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HEADER ──
          Row(
            children: [
              Text(
                symbol.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 10),
              _ConnectionDot(state: connState),
              const Spacer(),
              if (kline != null) _buildMiniStats(kline),
            ],
          ),
          const SizedBox(height: 12),

          // ── MAIN PRICE ──
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: kline == null
                ? _buildLoadingPlaceholder()
                : _buildPriceRow(kline),
          ),
          const SizedBox(height: 12),

          // ── OHLCV BAR ──
          if (kline != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF21262D)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _OhlcItem(label: '📈 AÇILIŞ', value: _fmt(kline.open), color: Colors.white70),
                  _OhlcItem(label: '🔺 EN YÜKSEK', value: _fmt(kline.high), color: const Color(0xFF00E676)),
                  _OhlcItem(label: '🔻 EN DÜŞÜK', value: _fmt(kline.low), color: const Color(0xFFF23645)),
                  _OhlcItem(label: '📊 HACİM', value: _fmtVol(kline.volume), color: const Color(0xFF58A6FF)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceRow(dynamic kline) {
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
            fontSize: 36,
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
      WsConnectionState.connected => (const Color(0xFF00E676), '🟢 CANLI'),
      WsConnectionState.connecting => (Colors.orange, '🟡 BAĞLANIYOR'),
      WsConnectionState.disconnected => (Colors.red, '🔴 BAĞLI DEĞİL'),
      WsConnectionState.error => (Colors.red, '❌ HATA'),
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