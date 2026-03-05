import logging
import math
from fastapi import APIRouter
from app.services.exchange.binance_rest import BinanceRestClient

logger = logging.getLogger(__name__)
router = APIRouter()

TOP_SYMBOLS = [
    "BTCUSDT", "ETHUSDT", "BNBUSDT", "SOLUSDT", "XRPUSDT",
    "ADAUSDT", "DOGEUSDT", "AVAXUSDT", "DOTUSDT", "MATICUSDT",
    "LINKUSDT", "SHIBUSDT", "LTCUSDT", "ATOMUSDT", "UNIUSDT",
    "ETCUSDT", "XLMUSDT", "NEARUSDT", "APTUSDT", "FILUSDT",
    "ARBUSDT", "OPUSDT", "INJUSDT", "SUIUSDT", "SEIUSDT",
    "TIAUSDT", "FETUSDT", "RENDERUSDT", "WIFUSDT", "PEPEUSDT",
    "CHZUSDT", "POLUSDT", "GRTUSDT"
]


@router.get("/summary")
async def get_market_summary():
    """
    Returns 24hr ticker data for the top cryptocurrencies.
    """
    rest_client = BinanceRestClient()
    data = await rest_client.get_24hr_tickers(TOP_SYMBOLS)
    return {"status": "success", "data": data}


@router.get("/indicators")
async def get_technical_indicators(symbol: str = "BTCUSDT", interval: str = "1m"):
    """
    Belirli bir koin ve zaman aralığı için Teknik Analiz skorunu döndürür.
    """
    from app.services.analysis.technical import TechnicalAnalyzer
    rest_client = BinanceRestClient()
    klines = await rest_client.get_historical_klines(symbol, interval, limit=100)
    analysis = TechnicalAnalyzer.analyze_klines(klines)
    return {"status": "success", "symbol": symbol, "interval": interval, "data": analysis}


@router.get("/open-interest")
async def get_open_interest(symbol: str = "BTCUSDT"):
    """Açık pozisyon (Open Interest) verisi."""
    rest_client = BinanceRestClient()
    data = await rest_client.get_open_interest(symbol)
    return {"status": "success", "data": data}


@router.get("/long-short-ratio")
async def get_long_short_ratio(symbol: str = "BTCUSDT", period: str = "5m"):
    """Global Long/Short Account Ratio."""
    rest_client = BinanceRestClient()
    data = await rest_client.get_long_short_ratio(symbol, period)
    return {"status": "success", "data": data}


@router.get("/funding-rate")
async def get_funding_rate(symbol: str = "BTCUSDT"):
    """Gerçek fonlama oranı geçmişi."""
    rest_client = BinanceRestClient()
    data = await rest_client.get_funding_rate(symbol)
    return {"status": "success", "data": data}


@router.get("/correlation")
async def get_correlation_matrix():
    """
    Top coinler arasında fiyat korelasyon matrisi.
    Son 100 mumun close fiyatlarından hesaplanır.
    """
    rest_client = BinanceRestClient()
    symbols = TOP_SYMBOLS[:12]  # İlk 12 coin ile sınırla (performans)
    
    # Her coin için son 100 kapanış fiyatını çek
    price_data = {}
    for symbol in symbols:
        klines = await rest_client.get_historical_klines(symbol, "1h", limit=100)
        if klines:
            closes = [float(k[4]) for k in klines]  # index 4 = close
            price_data[symbol] = closes

    # Basit Pearson korelasyon hesaplama
    result = {}
    symbol_list = list(price_data.keys())
    for i, s1 in enumerate(symbol_list):
        result[s1] = {}
        for j, s2 in enumerate(symbol_list):
            if i == j:
                result[s1][s2] = 1.0
            elif j < i and s2 in result and s1 in result[s2]:
                result[s1][s2] = result[s2][s1]
            else:
                result[s1][s2] = _pearson(price_data[s1], price_data[s2])

    return {"status": "success", "symbols": symbol_list, "matrix": result}


@router.get("/calculator")
async def position_calculator(
    capital: float = 1000,
    leverage: int = 10,
    entry_price: float = 50000,
    stop_loss_pct: float = 2.0,
    take_profit_pct: float = 6.0,
    win_rate: float = 55.0,
):
    """
    Pozisyon büyüklüğü, likidasyon fiyatı, Kelly criterion ve EV hesaplayıcı.
    """
    position_size = capital * leverage
    liquidation_long = entry_price * (1 - 1 / leverage)
    liquidation_short = entry_price * (1 + 1 / leverage)
    
    risk_amount = position_size * (stop_loss_pct / 100)
    reward_amount = position_size * (take_profit_pct / 100)
    risk_reward_ratio = take_profit_pct / stop_loss_pct if stop_loss_pct > 0 else 0
    
    # Kelly Criterion: f* = (bp - q) / b
    w = win_rate / 100
    b = risk_reward_ratio
    kelly = ((b * w) - (1 - w)) / b if b > 0 else 0
    kelly = max(0, min(kelly, 1))  # 0-1 arasında clamp
    kelly_bet = capital * kelly
    
    # Expected Value
    ev = (w * reward_amount) - ((1 - w) * risk_amount)
    
    return {
        "status": "success",
        "data": {
            "position_size": round(position_size, 2),
            "liquidation_long": round(liquidation_long, 2),
            "liquidation_short": round(liquidation_short, 2),
            "risk_amount": round(risk_amount, 2),
            "reward_amount": round(reward_amount, 2),
            "risk_reward_ratio": round(risk_reward_ratio, 2),
            "kelly_fraction": round(kelly * 100, 2),
            "kelly_bet": round(kelly_bet, 2),
            "expected_value": round(ev, 2),
        }
    }


def _pearson(x: list, y: list) -> float:
    """İki seri arasındaki Pearson korelasyon katsayısı."""
    n = min(len(x), len(y))
    if n < 2:
        return 0.0
    x, y = x[:n], y[:n]
    mx, my = sum(x) / n, sum(y) / n
    sx = math.sqrt(sum((xi - mx) ** 2 for xi in x) / n)
    sy = math.sqrt(sum((yi - my) ** 2 for yi in y) / n)
    if sx == 0 or sy == 0:
        return 0.0
    cov = sum((x[i] - mx) * (y[i] - my) for i in range(n)) / n
    return round(cov / (sx * sy), 4)
