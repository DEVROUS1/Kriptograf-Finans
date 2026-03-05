import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../config/app_config.dart';
import '../../data/models/market_summary_model.dart';
import '../../data/models/technical_indicator_model.dart';
import '../providers/market_provider.dart';
import '../providers/selected_coin_provider.dart';
import '../providers/indicator_provider.dart';
import '../widgets/live_price_widget.dart';

// ══════════════════════════════════════════════════════════════════════
// KriptoGraf Finans - Ultimate Crypto Terminal Dashboard
// Her kripto yatırımcısının telefonunda olması gereken uygulama
// ══════════════════════════════════════════════════════════════════════

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with TickerProviderStateMixin {
  late TabController _bottomTabController;
  Timer? _refreshTimer;
  int _currentPage = 0; // 0=Dashboard, 1=Markets, 2=Derivatives, 3=Tools, 4=AI, 5=Alarms
  String _selectedInterval = '1s';
  Timer? _indicatorTimer;

  // Simulated live data for whale trades, liquidations, funding
  final List<Map<String, dynamic>> _whaleTrades = [];
  final List<Map<String, dynamic>> _liquidations = [];
  final List<Map<String, dynamic>> _fundingRates = [];
  final List<Map<String, dynamic>> _momentumCoins = [];
  // Stabilized liq summary values (prevent flickering)
  String _liq1h = '\$0M', _liq4h = '\$0M', _liq12h = '\$0M', _liq24h = '\$0M';
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _bottomTabController = TabController(length: 4, vsync: this);
    _startDataFetch();
    // Auto-refresh indicators every 15 seconds
    _indicatorTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      ref.invalidate(technicalIndicatorProvider);
    });
  }

  void _startDataFetch() {
    _fetchLiveData();
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchLiveData();
    });
  }

  Future<void> _fetchLiveData() async {
    try {
      final dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));

      // 1. Gerçek balina verisi (Binance aggTrades + Etherscan)
      try {
        final whaleResp = await dio.get('/market/whale-activity');
        if (whaleResp.statusCode == 200 && whaleResp.data != null) {
          final whaleData = whaleResp.data['data'];
          final trades = (whaleData['trades'] as List?) ?? [];
          final stats = whaleData['stats'] ?? {};
          
          if (mounted) {
            setState(() {
              _whaleTrades.clear();
              for (final t in trades.take(12)) {
                final usdVal = (t['usd_value'] as num?)?.toDouble() ?? 0;
                final level = t['level'] ?? 'WHALE';
                
                // $100M+ giga whale -> ses çal
                if (level == 'GIGA' && mounted) {
                  _audioPlayer.play(UrlSource('https://actions.google.com/sounds/v1/alarms/beep_short.ogg'));
                }
                
                _whaleTrades.add({
                  'symbol': '${t['symbol'] ?? 'BTC'}USDT',
                  'side': t['side'] ?? 'BUY',
                  'amount': (usdVal / 1000).toStringAsFixed(0),
                  'price': (t['price'] ?? 0).toString(),
                  'exchange': t['source'] ?? 'Binance',
                  'time': DateTime.fromMillisecondsSinceEpoch(t['timestamp'] ?? 0).toLocal().toString().substring(11, 19),
                  'level': level,
                });
              }
            });
          }
        }
      } catch (e) {
        debugPrint('Whale API fallback: $e');
      }

      // 2. Market summary (fiyatlar + momentum + funding simülasyonu)
      final summaryResp = await dio.get('/market/summary');
      if (summaryResp.statusCode == 200 && summaryResp.data != null) {
        final dataList = summaryResp.data['data'] as List;
        if (mounted) {
          setState(() {
            // Liquidation (simulated - gerçek liq API ayrıca eklenebilir)
            final rng = Random();
            _liquidations.clear();
            for (int i = 0; i < 6; i++) {
              final coin = dataList[rng.nextInt(dataList.length)];
              final isLong = rng.nextBool();
              _liquidations.add({
                'symbol': coin['symbol'] ?? 'BTCUSDT',
                'side': isLong ? 'LONG' : 'SHORT',
                'amount': '\$${(rng.nextDouble() * 2000 + 100).toStringAsFixed(0)}K',
                'price': coin['lastPrice'] ?? '0',
                'exchange': ['Binance', 'Bybit', 'OKX', 'Bitget'][rng.nextInt(4)],
                'timeframe': ['1h', '4h', '12h', '24h'][rng.nextInt(4)],
              });
            }

            // Funding rates (simulated - /funding-rate endpoint'i mevcut)
            _fundingRates.clear();
            for (final coin in dataList) {
              final rate = (rng.nextDouble() * 0.06 - 0.02);
              _fundingRates.add({
                'symbol': coin['symbol'] ?? 'BTCUSDT',
                'rate': rate.toStringAsFixed(4),
                'isPositive': rate >= 0,
                'exchange': ['Binance', 'Bybit', 'OKX'][rng.nextInt(3)],
              });
            }

            // Momentum data
            _momentumCoins.clear();
            for (final coin in dataList) {
              final change = double.tryParse(coin['priceChangePercent'] ?? '0') ?? 0;
              String momentum;
              Color momentumColor;
              if (change > 3) {
                momentum = 'YUKSEK';
                momentumColor = const Color(0xFF00E676);
              } else if (change < -3) {
                momentum = 'DUSUK';
                momentumColor = const Color(0xFFF23645);
              } else {
                momentum = 'NORMAL';
                momentumColor = Colors.orange;
              }
              _momentumCoins.add({
                'symbol': coin['symbol'] ?? 'BTCUSDT',
                'change': coin['priceChangePercent'] ?? '0',
                'momentum': momentum,
                'momentumColor': momentumColor,
                'volume': coin['volume'] ?? '0',
                'price': coin['lastPrice'] ?? '0',
              });
            }
            // Stabilized liq summary values
            final liqRng = Random();
            _liq1h = '\$${(liqRng.nextInt(50) + 10)}M';
            _liq4h = '\$${(liqRng.nextInt(200) + 50)}M';
            _liq12h = '\$${(liqRng.nextInt(500) + 100)}M';
            _liq24h = '\$${(liqRng.nextInt(1000) + 200)}M';
            _isConnected = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isConnected = false);
      }
      debugPrint('Veri cekme hatasi: $e');
    }
  }

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _bottomTabController.dispose();
    _refreshTimer?.cancel();
    _indicatorTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCoin = ref.watch(selectedCoinProvider);
    final marketSummaryAsync = ref.watch(marketSummaryProvider);
    final indicatorAsync = ref.watch(
      technicalIndicatorProvider(symbol: selectedCoin, interval: _selectedInterval == '1s' ? '1m' : _selectedInterval),
    );
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      body: Column(
        children: [
          // ════════════ CONNECTION BANNER ════════════
          if (!_isConnected)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              color: const Color(0xFFF23645).withOpacity(0.15),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1.5, color: Color(0xFFF23645))),
                  SizedBox(width: 8),
                  Text('Bağlantı yeniden kuruluyor...', style: TextStyle(color: Color(0xFFF23645), fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          // ════════════ TOP BAR ════════════
          _buildTopBar(selectedCoin),

          // ════════════ MAIN CONTENT ════════════
          Expanded(
            child: Row(
              children: [
                // ────── NAV SIDEBAR ──────
                _buildNavSidebar(),

                // ────── LEFT: Coin List ──────
                _buildCoinListPanel(marketSummaryAsync, selectedCoin, ref),

                // ────── CENTER: Main Area ──────
                Expanded(
                  flex: 3,
                  child: _buildPageContent(selectedCoin, indicatorAsync),
                ),

                // ────── RIGHT: Technical Gauge + Liquidation Summary ──────
                if (screenWidth > 900 && _currentPage == 0)
                  _buildRightPanel(selectedCoin, indicatorAsync),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Page content switcher based on sidebar navigation
  Widget _buildPageContent(String selectedCoin, AsyncValue<TechnicalIndicatorModel?> indicatorAsync) {
    switch (_currentPage) {
      case 0:
        return _buildDashboardPage(selectedCoin, indicatorAsync);
      case 1:
        return _buildMarketsPage();
      case 2:
        return _buildDerivativesPage();
      case 3:
        return _buildToolsPage(selectedCoin);
      case 4:
        return _buildAIPage(selectedCoin);
      case 5:
        return _buildAlarmsPage();
      default:
        return _buildDashboardPage(selectedCoin, indicatorAsync);
    }
  }

  /// Page 0: Main Dashboard
  Widget _buildDashboardPage(String selectedCoin, AsyncValue<TechnicalIndicatorModel?> indicatorAsync) {
    return Column(
      children: [
        _buildPriceHeader(selectedCoin, indicatorAsync),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1A1F2E).withOpacity(0.9),
                    const Color(0xFF0F1318).withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2A2E39).withOpacity(0.5)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LivePriceWidget(symbol: selectedCoin.toLowerCase(), interval: _selectedInterval),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildBottomTabs(),
          ),
        ),
      ],
    );
  }

  /// Page 1: Markets — Tüm coinlerin detaylı tablo görünümü
  Widget _buildMarketsPage() {
    final marketSummaryAsync = ref.watch(marketSummaryProvider);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text('Piyasalar', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          // Table header row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              border: Border.all(color: const Color(0xFF21262D)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 2, child: Text('COIN', style: TextStyle(color: Color(0xFF8B949E), fontSize: 11, fontWeight: FontWeight.w700))),
                Expanded(flex: 2, child: Text('FİYAT', style: TextStyle(color: Color(0xFF8B949E), fontSize: 11, fontWeight: FontWeight.w700), textAlign: TextAlign.right)),
                Expanded(flex: 1, child: Text('24H %', style: TextStyle(color: Color(0xFF8B949E), fontSize: 11, fontWeight: FontWeight.w700), textAlign: TextAlign.right)),
                Expanded(flex: 2, child: Text('HACİM', style: TextStyle(color: Color(0xFF8B949E), fontSize: 11, fontWeight: FontWeight.w700), textAlign: TextAlign.right)),
              ],
            ),
          ),
          Expanded(
            child: marketSummaryAsync.when(
              data: (coins) => ListView.builder(
                itemCount: coins.length,
                itemBuilder: (context, i) {
                  final coin = coins[i];
                  final change = double.tryParse(coin.priceChangePercent) ?? 0;
                  final isPos = change >= 0;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: const Color(0xFF21262D).withOpacity(0.5)))),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Row(children: [
                          Text(getCoinEmoji(coin.symbol.replaceAll('USDT', '')), style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Text(coin.symbol.replaceAll('USDT', ''), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                          Text('/USDT', style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10)),
                        ])),
                        Expanded(flex: 2, child: Text(_formatPrice(coin.lastPrice), style: const TextStyle(color: Colors.white, fontSize: 13), textAlign: TextAlign.right)),
                        Expanded(flex: 1, child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: (isPos ? const Color(0xFF089981) : const Color(0xFFF23645)).withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                          child: Text('${isPos ? "+" : ""}${change.toStringAsFixed(2)}%', style: TextStyle(color: isPos ? const Color(0xFF00E676) : const Color(0xFFF23645), fontSize: 11, fontWeight: FontWeight.w600), textAlign: TextAlign.right),
                        )),
                        Expanded(flex: 2, child: Text(coin.volume ?? '-', style: const TextStyle(color: Color(0xFF8B949E), fontSize: 11), textAlign: TextAlign.right)),
                      ],
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF58A6FF))),
              error: (e, _) => Center(child: Text('Hata: $e', style: const TextStyle(color: Colors.red))),
            ),
          ),
        ],
      ),
    );
  }

  /// Page 2: Derivatives — Likidasyon + Fonlama paneli
  Widget _buildDerivativesPage() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Turev Piyasalar', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(child: _buildBottomTabs()),
        ],
      ),
    );
  }

  /// Page 3: Tools — Hesaplayıcılar ve Analiz Araçları
  Widget _buildToolsPage(String selectedCoin) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Trader Araçları', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Pozisyon büyüklüğü, risk yönetimi ve istatistik', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
            const SizedBox(height: 20),
            _buildToolCard(
              icon: Icons.calculate_rounded,
              title: 'Pozisyon Hesaplayıcı',
              subtitle: 'Likidasyon fiyatı, risk/ödül, Kelly Criterion',
              color: const Color(0xFF58A6FF),
              child: _buildPositionCalculator(),
            ),
            const SizedBox(height: 16),
            _buildToolCard(
              icon: Icons.auto_graph,
              title: 'Risk Metrikleri',
              subtitle: 'Kelly Criterion, Expected Value formülleri',
              color: const Color(0xFF00E676),
              child: _buildRiskMetricsInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard({required IconData icon, required String title, required String subtitle, required Color color, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)),
            ]),
          ]),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildPositionCalculator() {
    return FutureBuilder(
      future: Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)).get('/market/calculator', queryParameters: {
        'capital': 1000, 'leverage': 10, 'entry_price': 50000, 'stop_loss_pct': 2.0, 'take_profit_pct': 6.0, 'win_rate': 55,
      }),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF58A6FF))));
        final data = snapshot.data?.data?['data'];
        if (data == null) return const Text('Veri yok', style: TextStyle(color: Colors.white24));
        return Column(children: [
          Row(children: [
            Expanded(child: _calcCard('Pozisyon', '\$${data['position_size']}', const Color(0xFF58A6FF))),
            const SizedBox(width: 8),
            Expanded(child: _calcCard('Liq Long', '\$${data['liquidation_long']}', const Color(0xFFF23645))),
            const SizedBox(width: 8),
            Expanded(child: _calcCard('Liq Short', '\$${data['liquidation_short']}', const Color(0xFF00E676))),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _calcCard('Risk', '\$${data['risk_amount']}', const Color(0xFFF23645))),
            const SizedBox(width: 8),
            Expanded(child: _calcCard('Ödül', '\$${data['reward_amount']}', const Color(0xFF00E676))),
            const SizedBox(width: 8),
            Expanded(child: _calcCard('R:R', '${data['risk_reward_ratio']}x', const Color(0xFFFF9800))),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _calcCard('Kelly', '${data['kelly_fraction']}%', const Color(0xFF7B2FF7))),
            const SizedBox(width: 8),
            Expanded(child: _calcCard('Kelly Bahis', '\$${data['kelly_bet']}', const Color(0xFF7B2FF7))),
            const SizedBox(width: 8),
            Expanded(child: _calcCard('EV', '\$${data['expected_value']}', (data['expected_value'] as num) > 0 ? const Color(0xFF00E676) : const Color(0xFFF23645))),
          ]),
        ]);
      },
    );
  }

  Widget _calcCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.15))),
      child: Column(children: [
        Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _buildRiskMetricsInfo() {
    return Column(children: [
      _riskInfoRow('Kelly Criterion', 'f* = (bp - q) / b — optimal pozisyon büyüklüğü', Icons.functions),
      _riskInfoRow('Expected Value', 'Her trade\'in ortalama beklenen kâr/zarar', Icons.trending_up),
      _riskInfoRow('Risk/Reward', 'Stop-loss vs take-profit oranı', Icons.compare_arrows),
      _riskInfoRow('Likidasyon Fiyatı', 'Pozisyonun zorla kapatılacağı seviye', Icons.warning_amber),
    ]);
  }

  Widget _riskInfoRow(String title, String desc, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Icon(icon, size: 16, color: const Color(0xFF00E676)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          Text(desc, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10)),
        ])),
      ]),
    );
  }

  /// Page 4: AI — Yapay Zeka Piyasa Analizi
  Widget _buildAIPage(String selectedCoin) {
    final aiIndicator = ref.watch(technicalIndicatorProvider(symbol: selectedCoin, interval: _selectedInterval == '1s' ? '1m' : _selectedInterval));
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF7B2FF7), Color(0xFF00D2FF)]), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('AI Piyasa Analizi', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Text('${selectedCoin.replaceAll("USDT", "")} / USDT', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
          ]),
        ]),
        const SizedBox(height: 20),
        Expanded(
          child: aiIndicator.when(
            data: (data) {
              if (data == null) return const Center(child: Text('Veri bekleniyor...', style: TextStyle(color: Colors.white24)));
              return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _buildAISummaryCard(data, selectedCoin),
                const SizedBox(height: 16),
                _buildAISignalsCard(data),
                const SizedBox(height: 16),
                _buildAISRCard(data),
              ]));
            },
            loading: () => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const CircularProgressIndicator(color: Color(0xFF7B2FF7)),
              const SizedBox(height: 16),
              Text('AI analiz ediliyor...', style: TextStyle(color: Colors.white.withOpacity(0.5))),
            ])),
            error: (_, __) => const Center(child: Text('AI yüklenemedi', style: TextStyle(color: Colors.red))),
          ),
        ),
      ]),
    );
  }

  Widget _buildAISummaryCard(TechnicalIndicatorModel data, String coin) {
    final coinName = coin.replaceAll('USDT', '');
    final score = data.score;
    final action = data.action;
    final rsi = data.indicators.rsi;
    final macd = data.indicators.macdHist;
    String summary; Color sColor;
    if (action == 'Buy') {
      summary = '$coinName icin teknik gostergeler ALIM sinyali veriyor (Skor: $score/100). ';
      if (rsi != null && rsi < 30) summary += 'RSI asiri satim bolgesinde (${rsi.toStringAsFixed(1)}). ';
      if (macd != null && macd > 0) summary += 'MACD histogram pozitif, momentum yukari yonlu.';
      sColor = const Color(0xFF00E676);
    } else if (action == 'Sell') {
      summary = '$coinName icin teknik gostergeler SATIM sinyali veriyor (Skor: $score/100). ';
      if (rsi != null && rsi > 70) summary += 'RSI asiri alim bolgesinde (${rsi.toStringAsFixed(1)}). ';
      if (macd != null && macd < 0) summary += 'MACD histogram negatif, momentum asagi yonlu.';
      sColor = const Color(0xFFF23645);
    } else {
      summary = '$coinName piyasada NOTR bolgede (Skor: $score/100). Belirgin yon yok.';
      sColor = Colors.orange;
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [sColor.withOpacity(0.08), Colors.transparent]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: sColor.withOpacity(0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(action == 'Buy' ? Icons.trending_up : action == 'Sell' ? Icons.trending_down : Icons.trending_flat, color: sColor, size: 24),
          const SizedBox(width: 8),
          Text('AI Yorum', style: TextStyle(color: sColor, fontSize: 14, fontWeight: FontWeight.bold)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: sColor.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
            child: Text(action == 'Buy' ? 'ALIS' : action == 'Sell' ? 'SATIS' : 'NOTR', style: TextStyle(color: sColor, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ]),
        const SizedBox(height: 12),
        Text(summary, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
        const SizedBox(height: 8),
        Text('Bu bir finansal tavsiye degildir.', style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 10, fontStyle: FontStyle.italic)),
      ]),
    );
  }

  Widget _buildAISignalsCard(TechnicalIndicatorModel data) {
    final ind = data.indicators;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF0D1117), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF21262D))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Sinyal Paneli', style: TextStyle(color: Color(0xFF58A6FF), fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _aiSignalRow('RSI (14)', ind.rsi, ind.rsi != null ? (ind.rsi! < 30 ? 'Asiri Satim' : ind.rsi! > 70 ? 'Asiri Alim' : 'Notr') : '-'),
        _aiSignalRow('MACD Hist', ind.macdHist, ind.macdHist != null ? (ind.macdHist! > 0 ? 'Yukari' : 'Asagi') : '-'),
        _aiSignalRow('ADX', ind.adx, ind.adx != null ? (ind.adx! > 25 ? 'Guclu Trend' : 'Zayif Trend') : '-'),
        _aiSignalRow('BB Width', ind.bbWidth, ind.bbWidth != null ? (ind.bbWidth! > 0.05 ? 'Volatil' : 'Dar Band') : '-'),
      ]),
    );
  }

  Widget _aiSignalRow(String name, double? value, String signal) {
    Color c = signal.contains('Sat') || signal.contains('Asagi') ? const Color(0xFFF23645) : signal.contains('Al') || signal.contains('Yuk') || signal.contains('Guc') ? const Color(0xFF00E676) : Colors.orange;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Expanded(flex: 2, child: Text(name, style: const TextStyle(color: Color(0xFF8B949E), fontSize: 12))),
        Expanded(flex: 1, child: Text(value?.toStringAsFixed(2) ?? '-', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))),
        Expanded(flex: 2, child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
          child: Text(signal, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        )),
      ]),
    );
  }

  Widget _buildAISRCard(TechnicalIndicatorModel data) {
    final sr = data.supportResistance;
    if (sr == null) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF0D1117), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF21262D))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Destek & Direnc', style: TextStyle(color: Color(0xFFFFD700), fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (sr.r3 != null) _srLevelRow('R3', sr.r3!, const Color(0xFFB71C1C)),
        if (sr.r2 != null) _srLevelRow('R2', sr.r2!, const Color(0xFFD32F2F)),
        if (sr.r1 != null) _srLevelRow('R1', sr.r1!, const Color(0xFFF23645)),
        if (sr.pivot != null) _srLevelRow('Pivot', sr.pivot!, const Color(0xFFFFD700)),
        if (sr.s1 != null) _srLevelRow('S1', sr.s1!, const Color(0xFF00E676)),
        if (sr.s2 != null) _srLevelRow('S2', sr.s2!, const Color(0xFF00C853)),
        if (sr.s3 != null) _srLevelRow('S3', sr.s3!, const Color(0xFF00897B)),
      ]),
    );
  }

  Widget _srLevelRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        const Spacer(),
        Text('\$${value.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  /// Page 5: Alarms — Kurulmuş alarmlar
  Widget _buildAlarmsPage() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Alarmlarim', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showAlarmDialog(context),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Yeni Alarm'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F6FEB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: const Color(0xFF8B949E).withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text('Henüz alarm kurulmadı', style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Yukarıdaki butona tıklayarak yeni bir alarm kurabilirsiniz.', style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // TOP APP BAR
  // ══════════════════════════════════════════════════════════════════
  Widget _buildTopBar(String selectedCoin) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D1117), Color(0xFF161B22)],
        ),
        border: Border(
          bottom: BorderSide(color: const Color(0xFF30363D).withOpacity(0.6)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00D2FF), Color(0xFF7B2FF7)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'KG',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'KriptoGraf Finans',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF00E676).withOpacity(0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'PRO',
              style: TextStyle(
                color: Color(0xFF00E676),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          // Exchange badges
          ..._buildExchangeBadges(),
          const SizedBox(width: 16),
          // Alarm button
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF8B949E)),
            onPressed: () => _showAlarmDialog(context),
            tooltip: 'Alarm Kur',
          ),
          const SizedBox(width: 8),
          // Refresh indicator
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF00E676),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Canlı',
            style: TextStyle(
              color: const Color(0xFF00E676).withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExchangeBadges() {
    final exchanges = [
      {'name': 'Binance', 'color': const Color(0xFFF3BA2F)},
      {'name': 'Bybit', 'color': const Color(0xFFFF6C2C)},
      {'name': 'OKX', 'color': Colors.white},
      {'name': 'Bitget', 'color': const Color(0xFF00E3C6)},
      {'name': 'MEXC', 'color': const Color(0xFF2B69E2)},
    ];
    return exchanges.map((e) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: (e['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: (e['color'] as Color).withOpacity(0.3)),
          ),
          child: Text(
            e['name'] as String,
            style: TextStyle(
              color: e['color'] as Color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }).toList();
  }

  // ══════════════════════════════════════════════════════════════════
  // NAV SIDEBAR
  // ══════════════════════════════════════════════════════════════════
  Widget _buildNavSidebar() {
    final navItems = [
      {'icon': Icons.dashboard_rounded, 'label': 'Panel', 'index': 0},
      {'icon': Icons.candlestick_chart_rounded, 'label': 'Piyasalar', 'index': 1},
      {'icon': Icons.bolt_rounded, 'label': 'Türevler', 'index': 2},
      {'icon': Icons.calculate_rounded, 'label': 'Araçlar', 'index': 3},
      {'icon': Icons.auto_awesome, 'label': 'AI', 'index': 4},
      {'icon': Icons.notifications_rounded, 'label': 'Alarmlar', 'index': 5},
    ];
    return Container(
      width: 72,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0E17), Color(0xFF060912)],
        ),
        border: Border(right: BorderSide(color: const Color(0xFF21262D).withOpacity(0.5))),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          ...navItems.map((item) {
            final isActive = _currentPage == (item['index'] as int);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() => _currentPage = item['index'] as int),
                  borderRadius: BorderRadius.circular(10),
                  hoverColor: const Color(0xFF1F6FEB).withOpacity(0.08),
                  splashColor: const Color(0xFF1F6FEB).withOpacity(0.15),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFF1F6FEB).withOpacity(0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: isActive ? Border.all(color: const Color(0xFF1F6FEB).withOpacity(0.4), width: 1) : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          size: 20,
                          color: isActive ? const Color(0xFF58A6FF) : const Color(0xFF8B949E),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['label'] as String,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                            color: isActive ? const Color(0xFF58A6FF) : const Color(0xFF8B949E),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          // Version badge at bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text('v2.0', style: TextStyle(color: Colors.white.withOpacity(0.15), fontSize: 9)),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // LEFT PANEL: Coin List
  // ══════════════════════════════════════════════════════════════════
  Widget _buildCoinListPanel(AsyncValue<List<MarketSummaryModel>> marketSummaryAsync, String selectedCoin, WidgetRef ref) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        border: Border(
          right: BorderSide(color: const Color(0xFF21262D).withOpacity(0.8)),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: const Color(0xFF21262D).withOpacity(0.8)),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.trending_up, color: Color(0xFF58A6FF), size: 18),
                const SizedBox(width: 8),
                const Text(
                  '',
                  style: TextStyle(fontSize: 14),
                ),
                const Text(
                  'Piyasa Özeti',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF238636).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '24H',
                    style: TextStyle(color: Color(0xFF3FB950), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // Coin list
          Expanded(
            child: marketSummaryAsync.when(
              data: (coins) {
                if (coins.isEmpty) {
                  return const Center(child: Text('Veri yok', style: TextStyle(color: Colors.white24)));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: coins.length,
                  itemBuilder: (context, index) {
                    final coin = coins[index];
                    final isSelected = selectedCoin == coin.symbol;
                    final priceChange = double.tryParse(coin.priceChangePercent) ?? 0.0;
                    final isPositive = priceChange >= 0;
                    final coinName = coin.symbol.replaceAll('USDT', '');

                    return InkWell(
                      onTap: () => ref.read(selectedCoinProvider.notifier).state = coin.symbol,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1F6FEB).withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(color: const Color(0xFF1F6FEB).withOpacity(0.3))
                              : null,
                        ),
                        child: Row(
                          children: [
                            // Coin Icon Emoji
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _getCoinColor(coinName).withOpacity(0.3),
                                    _getCoinColor(coinName).withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  getCoinEmoji(coinName),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    coinName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '/USDT',
                                    style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _formatPrice(coin.lastPrice),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: (isPositive ? const Color(0xFF089981) : const Color(0xFFF23645))
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${isPositive ? '+' : ''}${priceChange.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      color: isPositive ? const Color(0xFF00E676) : const Color(0xFFF23645),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF58A6FF),
                  strokeWidth: 2,
                ),
              ),
              error: (err, _) => Center(
                child: Text('$err', style: const TextStyle(color: Colors.red, fontSize: 10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // PRICE HEADER
  // ══════════════════════════════════════════════════════════════════
  Widget _buildPriceHeader(String selectedCoin, AsyncValue<TechnicalIndicatorModel?> indicatorAsync) {
    final coinName = selectedCoin.replaceAll('USDT', '');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Coin name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _getCoinColor(coinName).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _getCoinColor(coinName).withOpacity(0.3)),
            ),
            child: Text(
              '$coinName / USDT',
              style: TextStyle(
                color: _getCoinColor(coinName),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Technical Analysis Badge
          indicatorAsync.when(
            data: (data) {
              if (data == null) return const SizedBox();
              Color badgeColor;
              String label;
              if (data.action == 'Buy') {
                badgeColor = const Color(0xFF00E676);
                label = '⬆ AL';
              } else if (data.action == 'Sell') {
                badgeColor = const Color(0xFFF23645);
                label = '⬇ SAT';
              } else {
                badgeColor = Colors.orange;
                label = '◆ NÖTR';
              }
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: badgeColor.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    Text(
                      label,
                      style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Skor: ${data.score}',
                      style: TextStyle(color: badgeColor.withOpacity(0.7), fontSize: 10),
                    ),
                  ],
                ),
              );
            },
            loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 1.5)),
            error: (_, __) => const SizedBox(),
          ),
          const Spacer(),
          // Interval chips
          ..._buildIntervalChips(),
        ],
      ),
    );
  }

  List<Widget> _buildIntervalChips() {
    return ['1s', '1m', '5m', '15m', '1h', '4h'].map((interval) {
      final isActive = interval == _selectedInterval;
      return Padding(
        padding: const EdgeInsets.only(left: 4),
        child: InkWell(
          onTap: () {
            setState(() => _selectedInterval = interval);
            // Invalidate indicators to refetch with new interval
            ref.invalidate(technicalIndicatorProvider);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF1F6FEB).withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isActive ? const Color(0xFF1F6FEB) : const Color(0xFF30363D),
              ),
            ),
            child: Text(
              interval.toUpperCase(),
              style: TextStyle(
                color: isActive ? const Color(0xFF58A6FF) : const Color(0xFF8B949E),
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  // ══════════════════════════════════════════════════════════════════
  // BOTTOM TABS: Whale Trades | Liquidations | Funding | Momentum
  // ══════════════════════════════════════════════════════════════════
  Widget _buildBottomTabs() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF21262D).withOpacity(0.6)),
      ),
      child: Column(
        children: [
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: const Color(0xFF21262D).withOpacity(0.6)),
              ),
            ),
            child: TabBar(
              controller: _bottomTabController,
              indicatorColor: const Color(0xFF58A6FF),
              indicatorWeight: 2,
              labelColor: const Color(0xFF58A6FF),
              unselectedLabelColor: const Color(0xFF8B949E),
              labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontSize: 11),
              tabs: const [
                Tab(text: 'BALINA'),
                Tab(text: 'LIKIDASYON'),
                Tab(text: 'FONLAMA'),
                Tab(text: 'MOMENTUM'),
              ],
            ),
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _bottomTabController,
              children: [
                _buildWhaleTradesTab(),
                _buildLiquidationsTab(),
                _buildFundingRatesTab(),
                _buildMomentumTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Whale Trades ──
  Widget _buildWhaleTradesTab() {
    if (_whaleTrades.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF58A6FF)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _whaleTrades.length,
      itemBuilder: (context, index) {
        final trade = _whaleTrades[index];
        final isBuy = trade['side'] == 'BUY';
        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: (isBuy ? const Color(0xFF089981) : const Color(0xFFF23645)).withOpacity(0.08),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: (isBuy ? const Color(0xFF089981) : const Color(0xFFF23645)).withOpacity(0.15),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isBuy ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: isBuy ? const Color(0xFF00E676) : const Color(0xFFF23645),
              ),
              const SizedBox(width: 8),
              Text(
                trade['symbol'].toString().replaceAll('USDT', ''),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isBuy ? const Color(0xFF089981).withOpacity(0.2) : const Color(0xFFF23645).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  trade['side'],
                  style: TextStyle(
                    color: isBuy ? const Color(0xFF00E676) : const Color(0xFFF23645),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              if (double.parse(trade['amount'].toString()) >= 10000)
                const Text('', style: TextStyle(fontSize: 16)),
              Text(
                '\$${trade['amount']}K',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
              ),
              const SizedBox(width: 12),
              Text(
                trade['exchange'],
                style: const TextStyle(color: Color(0xFF8B949E), fontSize: 10),
              ),
              const SizedBox(width: 8),
              Text(
                trade['time'],
                style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Liquidations ──
  Widget _buildLiquidationsTab() {
    if (_liquidations.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF58A6FF)));
    }
    return Column(
      children: [
        // Liquidation Summary Row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLiqTimeframe('1H', _liq1h),
              _buildLiqTimeframe('4H', _liq4h),
              _buildLiqTimeframe('12H', _liq12h),
              _buildLiqTimeframe('24H', _liq24h),
            ],
          ),
        ),
        const Divider(color: Color(0xFF21262D), height: 1),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _liquidations.length,
            itemBuilder: (context, index) {
              final liq = _liquidations[index];
              final isLong = liq['side'] == 'LONG';
              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (isLong ? const Color(0xFF089981) : const Color(0xFFF23645)).withOpacity(0.08),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.flash_on, size: 14, color: isLong ? const Color(0xFF00E676) : const Color(0xFFF23645)),
                    const SizedBox(width: 8),
                    Text(liq['symbol'].toString().replaceAll('USDT', ''),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: (isLong ? const Color(0xFF089981) : const Color(0xFFF23645)).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        liq['side'],
                        style: TextStyle(
                          color: isLong ? const Color(0xFF00E676) : const Color(0xFFF23645),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(liq['amount'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(width: 8),
                    Text(liq['exchange'], style: const TextStyle(color: Color(0xFF8B949E), fontSize: 10)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLiqTimeframe(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF8B949E), fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Color(0xFFF23645), fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // ── Funding Rates ──
  Widget _buildFundingRatesTab() {
    if (_fundingRates.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF58A6FF)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _fundingRates.length,
      itemBuilder: (context, index) {
        final fund = _fundingRates[index];
        final isPos = fund['isPositive'] as bool;
        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF161B22),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Text(
                fund['symbol'].toString().replaceAll('USDT', ''),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const Spacer(),
              Text(
                '${fund['rate']}%',
                style: TextStyle(
                  color: isPos ? const Color(0xFF00E676) : const Color(0xFFF23645),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              Text(fund['exchange'], style: const TextStyle(color: Color(0xFF8B949E), fontSize: 10)),
            ],
          ),
        );
      },
    );
  }

  // ── Momentum Scanner ──
  Widget _buildMomentumTab() {
    if (_momentumCoins.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF58A6FF)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _momentumCoins.length,
      itemBuilder: (context, index) {
        final coin = _momentumCoins[index];
        final color = coin['momentumColor'] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.06),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withOpacity(0.12)),
          ),
          child: Row(
            children: [
              Text(
                coin['symbol'].toString().replaceAll('USDT', ''),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  coin['momentum'],
                  style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Text(
                _formatPrice(coin['price']),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(width: 12),
              Text(
                '${coin['change']}%',
                style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // RIGHT PANEL: Technical Gauge + Liq Heatmap
  // ══════════════════════════════════════════════════════════════════
  Widget _buildRightPanel(String selectedCoin, AsyncValue<TechnicalIndicatorModel?> indicatorAsync) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        border: Border(
          left: BorderSide(color: const Color(0xFF21262D).withOpacity(0.8)),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: const Color(0xFF21262D).withOpacity(0.8)),
              ),
            ),
            child: const Row(
              children: [
                Text('', style: TextStyle(fontSize: 14)),
                Icon(Icons.analytics, color: Color(0xFFF778BA), size: 18),
                SizedBox(width: 6),
                Text(
                  'Teknik Analiz',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          // Gauge
          Expanded(
            flex: 2,
            child: indicatorAsync.when(
              data: (data) {
                if (data == null) return const Center(child: Text('Veri bekleniyor...', style: TextStyle(color: Colors.white24)));
                return _buildGaugeCard(data);
              },
              loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              error: (_, __) => const Center(child: Text('Hata', style: TextStyle(color: Colors.red))),
            ),
          ),

          // Indicator Details
          Expanded(
            flex: 3,
            child: indicatorAsync.when(
              data: (data) {
                if (data == null) return const SizedBox();
                return _buildIndicatorDetails(data);
              },
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGaugeCard(TechnicalIndicatorModel data) {
    Color gaugeColor;
    String label;
    if (data.action == 'Buy') {
      gaugeColor = const Color(0xFF00E676);
      label = 'AL';
    } else if (data.action == 'Sell') {
      gaugeColor = const Color(0xFFF23645);
      label = 'SAT';
    } else {
      gaugeColor = Colors.orange;
      label = 'NÖTR';
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: 180,
            height: 90,
            child: CustomPaint(
              painter: _GaugePainter(score: data.score.toDouble(), color: gaugeColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: gaugeColor, fontSize: 24, fontWeight: FontWeight.w900),
          ),
          Text(
            'Skor: ${data.score}/100',
            style: TextStyle(color: gaugeColor.withOpacity(0.6), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorDetails(TechnicalIndicatorModel data) {
    final ind = data.indicators;
    final sr = data.supportResistance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        padding: const EdgeInsets.only(top: 4),
        children: [
          _sectionLabel('MOMENTUM'),
          _indicatorRow('RSI (14)', ind.rsi?.toStringAsFixed(2) ?? '-', _getRsiColor(ind.rsi)),
          _indicatorRow('STOCH RSI', ind.stochRsi?.toStringAsFixed(2) ?? '-', _getRsiColor(ind.stochRsi)),
          _indicatorRow('STOCH K/D', '${ind.stochK?.toStringAsFixed(1) ?? "-"}/${ind.stochD?.toStringAsFixed(1) ?? "-"}', null),
          _indicatorRow('CCI (20)', ind.cci?.toStringAsFixed(1) ?? '-', _getCciColor(ind.cci)),
          _indicatorRow('WILLIAMS %R', ind.williamsR?.toStringAsFixed(1) ?? '-', null),
          _indicatorRow('ROC', ind.roc?.toStringAsFixed(2) ?? '-', null),
          _indicatorRow('MFI', ind.mfi?.toStringAsFixed(1) ?? '-', _getRsiColor(ind.mfi)),
          _indicatorRow('AWESOME OSC', ind.awesomeOsc?.toStringAsFixed(2) ?? '-', null),

          const SizedBox(height: 8),
          _sectionLabel('TREND'),
          _indicatorRow('MACD', ind.macd?.toStringAsFixed(4) ?? '-', null),
          _indicatorRow('MACD SİNYAL', ind.macdSignal?.toStringAsFixed(4) ?? '-', null),
          _indicatorRow('MACD HİST', ind.macdHist?.toStringAsFixed(4) ?? '-', _getHistColor(ind.macdHist)),
          _indicatorRow('ADX', ind.adx?.toStringAsFixed(1) ?? '-', _getAdxColor(ind.adx)),
          _indicatorRow('+DI / -DI', '${ind.plusDi?.toStringAsFixed(1) ?? "-"} / ${ind.minusDi?.toStringAsFixed(1) ?? "-"}', null),
          _indicatorRow('ICHIMOKU T/K', '${ind.tenkan?.toStringAsFixed(2) ?? "-"} / ${ind.kijun?.toStringAsFixed(2) ?? "-"}', null),

          const SizedBox(height: 8),
          _sectionLabel('HAREKETLI ORTALAMALAR'),
          _indicatorRow('EMA 9', ind.ema9?.toStringAsFixed(2) ?? '-', null),
          _indicatorRow('EMA 20', ind.ema20?.toStringAsFixed(2) ?? '-', null),
          _indicatorRow('EMA 50', ind.ema50?.toStringAsFixed(2) ?? '-', null),
          _indicatorRow('SMA 10', ind.sma10?.toStringAsFixed(2) ?? '-', null),
          _indicatorRow('SMA 20', ind.sma20?.toStringAsFixed(2) ?? '-', null),
          _indicatorRow('SMA 50', ind.sma50?.toStringAsFixed(2) ?? '-', null),

          const SizedBox(height: 8),
          _sectionLabel('VOLATILITE'),
          _indicatorRow('BB ÜST', ind.bbUpper?.toStringAsFixed(2) ?? '-', null),
          _indicatorRow('BB ORTA', ind.bbMiddle?.toStringAsFixed(2) ?? '-', null),
          _indicatorRow('BB ALT', ind.bbLower?.toStringAsFixed(2) ?? '-', null),
          _indicatorRow('BB GENİŞLİK', ind.bbWidth?.toStringAsFixed(4) ?? '-', null),
          _indicatorRow('ATR (14)', ind.atr?.toStringAsFixed(4) ?? '-', null),

          const SizedBox(height: 8),
          _sectionLabel('HACIM'),
          _indicatorRow('OBV', ind.obv != null ? _fmtLargeNum(ind.obv!) : '-', null),
          _indicatorRow('VWAP', ind.vwap?.toStringAsFixed(2) ?? '-', null),

          if (sr != null) ...[
            const SizedBox(height: 8),
            _sectionLabel('DESTEK / DIRENC'),
            _indicatorRow('PİVOT', sr.pivot?.toStringAsFixed(2) ?? '-', const Color(0xFFFFD700)),
            _indicatorRow('D1', sr.s1?.toStringAsFixed(2) ?? '-', const Color(0xFF00E676)),
            _indicatorRow('D2', sr.s2?.toStringAsFixed(2) ?? '-', const Color(0xFF00C853)),
            _indicatorRow('D3', sr.s3?.toStringAsFixed(2) ?? '-', const Color(0xFF00897B)),
            _indicatorRow('R1', sr.r1?.toStringAsFixed(2) ?? '-', const Color(0xFFF23645)),
            _indicatorRow('R2', sr.r2?.toStringAsFixed(2) ?? '-', const Color(0xFFD32F2F)),
            _indicatorRow('R3', sr.r3?.toStringAsFixed(2) ?? '-', const Color(0xFFB71C1C)),
          ],
          const SizedBox(height: 16),
          _indicatorRow('FIYAT', '\$${ind.price?.toStringAsFixed(2) ?? "-"}', Colors.white),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 2),
      child: Text(text, style: const TextStyle(color: Color(0xFF58A6FF), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
    );
  }

  Color? _getCciColor(double? v) {
    if (v == null) return null;
    if (v < -100) return const Color(0xFF00E676);
    if (v > 100) return const Color(0xFFF23645);
    return Colors.orange;
  }

  Color? _getHistColor(double? v) {
    if (v == null) return null;
    return v > 0 ? const Color(0xFF00E676) : const Color(0xFFF23645);
  }

  Color? _getAdxColor(double? v) {
    if (v == null) return null;
    if (v > 25) return const Color(0xFF00E676);
    return Colors.orange;
  }

  String _fmtLargeNum(double v) {
    if (v.abs() >= 1e9) return '${(v / 1e9).toStringAsFixed(2)}B';
    if (v.abs() >= 1e6) return '${(v / 1e6).toStringAsFixed(2)}M';
    if (v.abs() >= 1e3) return '${(v / 1e3).toStringAsFixed(2)}K';
    return v.toStringAsFixed(2);
  }

  Color? _getRsiColor(double? value) {
    if (value == null) return null;
    if (value < 30) return const Color(0xFF00E676);
    if (value > 70) return const Color(0xFFF23645);
    return Colors.orange;
  }

  Widget _indicatorRow(String label, String value, Color? valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF8B949E), fontSize: 11)),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // ALARM DIALOG
  // ══════════════════════════════════════════════════════════════════
  void _showAlarmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.notifications_active, color: Color(0xFFFF9800)),
            SizedBox(width: 8),
            Text('Alarm Kur', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAlarmField('Koin', 'BTCUSDT'),
              const SizedBox(height: 12),
              _buildAlarmField('Fiyat Alarmi', 'Orn: 70000'),
              const SizedBox(height: 12),
              _buildAlarmField('RSI Alarmi', 'Orn: 30 alti'),
              const SizedBox(height: 12),
              _buildAlarmField('Hacim Alarmi', 'Orn: 1000 BTC uzeri'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal', style: TextStyle(color: Color(0xFF8B949E))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F6FEB),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Alarm basariyla kuruldu!'),
                  backgroundColor: const Color(0xFF238636),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            child: const Text('Alarmı Kur'),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmField(String label, String hint) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF8B949E)),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
        filled: true,
        fillColor: const Color(0xFF0D1117),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF30363D)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF30363D)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1F6FEB)),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // UTILITIES
  // ══════════════════════════════════════════════════════════════════
  String _formatPrice(String? price) {
    if (price == null) return '-';
    final p = double.tryParse(price);
    if (p == null) return price;
    if (p >= 1000) return '\$${p.toStringAsFixed(2)}';
    if (p >= 1) return '\$${p.toStringAsFixed(4)}';
    return '\$${p.toStringAsFixed(6)}';
  }

  String getCoinEmoji(String coin) {
    const map = {
      'BTC': 'B', 'ETH': 'E', 'BNB': 'B', 'SOL': 'S', 'XRP': 'X',
      'ADA': 'A', 'DOGE': 'D', 'AVAX': 'A', 'DOT': 'D', 'MATIC': 'M',
      'LINK': 'L', 'SHIB': 'S', 'LTC': 'L', 'ATOM': 'A', 'UNI': 'U',
      'ETC': 'E', 'XLM': 'X', 'NEAR': 'N', 'APT': 'A', 'FIL': 'F',
      'ARB': 'A', 'OP': 'O', 'INJ': 'I', 'SUI': 'S', 'SEI': 'S',
      'TIA': 'T', 'FET': 'F', 'RENDER': 'R', 'WIF': 'W', 'PEPE': 'P',
      'CHZ': 'C', 'POL': 'P', 'GRT': 'G',
    };
    return map[coin.toUpperCase()] ?? coin.substring(0, 1).toUpperCase();
  }

  Color _getCoinColor(String coin) {
    const map = {
      'BTC': Color(0xFFF7931A), 'ETH': Color(0xFF627EEA), 'SOL': Color(0xFF9945FF),
      'BNB': Color(0xFFF3BA2F), 'XRP': Color(0xFF00AAE4), 'ADA': Color(0xFF0033AD),
      'AVAX': Color(0xFFE84142), 'DOGE': Color(0xFFC2A633), 'DOT': Color(0xFFE6007A),
      'MATIC': Color(0xFF8247E5), 'LINK': Color(0xFF2A5ADA), 'SHIB': Color(0xFFFFA409),
      'LTC': Color(0xFFBFBBB5), 'ATOM': Color(0xFF2E3148), 'UNI': Color(0xFFFF007A),
      'ETC': Color(0xFF33B778), 'XLM': Color(0xFF14B6E7), 'NEAR': Color(0xFF00C08B),
      'APT': Color(0xFF06BFA5), 'FIL': Color(0xFF0090FF), 'ARB': Color(0xFF28A0F0),
      'OP': Color(0xFFFF0420), 'INJ': Color(0xFF00C2FF), 'SUI': Color(0xFF4DA2FF),
      'SEI': Color(0xFF9B1C1C), 'TIA': Color(0xFF7B2BF9), 'FET': Color(0xFF1D2951),
      'RENDER': Color(0xFF00D395), 'WIF': Color(0xFFBB7F4A), 'PEPE': Color(0xFF00B300),
      'CHZ': Color(0xFFCD0124), 'POL': Color(0xFF8247E5), 'GRT': Color(0xFF6742FF),
    };
    return map[coin.toUpperCase()] ?? const Color(0xFF58A6FF);
  }
}

// ══════════════════════════════════════════════════════════════════
// GAUGE PAINTER (Custom Half-Circle Gauge)
// ══════════════════════════════════════════════════════════════════
class _GaugePainter extends CustomPainter {
  final double score;
  final Color color;

  _GaugePainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);

    // Background arc
    final bgPaint = Paint()
      ..color = const Color(0xFF21262D)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, pi, pi, false, bgPaint);

    // Glow effect
    final glowPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    final sweepAngle = (score / 100) * pi;
    canvas.drawArc(rect, pi, sweepAngle, false, glowPaint);

    // Foreground arc
    final fgPaint = Paint()
      ..color = color
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, pi, sweepAngle, false, fgPaint);

    // Score text center
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${score.toInt()}',
        style: TextStyle(
          color: color,
          fontSize: 28,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(size.width / 2 - textPainter.width / 2, size.height - textPainter.height),
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.color != color;
  }
}
