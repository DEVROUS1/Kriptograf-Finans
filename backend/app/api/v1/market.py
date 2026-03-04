import logging
from fastapi import APIRouter
from app.services.exchange.binance_rest import BinanceRestClient

logger = logging.getLogger(__name__)
router = APIRouter()

@router.get("/summary")
async def get_market_summary():
    """
    Returns 24hr ticker data for the top cryptocurrencies.
    """
    top_symbols = [
        "BTCUSDT", "ETHUSDT", "BNBUSDT", "SOLUSDT", "XRPUSDT",
        "ADAUSDT", "DOGEUSDT", "AVAXUSDT", "DOTUSDT", "MATICUSDT",
        "LINKUSDT", "SHIBUSDT", "LTCUSDT", "ATOMUSDT", "UNIUSDT",
        "ETCUSDT", "XLMUSDT", "NEARUSDT", "APTUSDT", "FILUSDT",
        "ARBUSDT", "OPUSDT", "INJUSDT", "SUIUSDT", "SEIUSDT",
        "TIAUSDT", "FETUSDT", "RENDERUSDT", "WIFUSDT", "PEPEUSDT",
        "CHZUSDT", "POLUSDT", "GRTUSDT"
    ]
    
    rest_client = BinanceRestClient()
    data = await rest_client.get_24hr_tickers(top_symbols)
    
    return {"status": "success", "data": data}

@router.get("/indicators")
async def get_technical_indicators(symbol: str = "BTCUSDT", interval: str = "1m"):
    """
    Belirli bir koin ve zaman aralığı için Binance'den geçmiş verileri çeker
    ve Teknik Analiz motorundan geçirerek Al/Sat kadran skorunu döndürür.
    """
    from app.services.analysis.technical import TechnicalAnalyzer
    
    rest_client = BinanceRestClient()
    
    # 100 mum yeterlidir (SMA 50 vb. için)
    klines = await rest_client.get_historical_klines(symbol, interval, limit=100)
    
    analysis = TechnicalAnalyzer.analyze_klines(klines)
    
    return {"status": "success", "symbol": symbol, "interval": interval, "data": analysis}
