import json
import logging
import httpx

logger = logging.getLogger(__name__)

class BinanceRestClient:
    BASE_URL = "https://api.binance.com/api/v3"

    async def get_24hr_tickers(self, symbols: list[str]) -> list:
        """
        Belirtilen semboller için 24 saatlik fiyat değişimi ve hacim verilerini çeker.
        """
        url = f"{self.BASE_URL}/ticker/24hr"
        params = {"symbols": json.dumps(symbols).replace(" ", "")}
        
        async with httpx.AsyncClient() as client:
            try:
                response = await client.get(url, params=params, timeout=10.0)
                response.raise_for_status()
                return response.json()
            except Exception as e:
                logger.error(f"Binance REST API error (get_24hr_tickers): {e}")
                return []

    async def get_historical_klines(self, symbol: str, interval: str, limit: int = 100) -> list:
        url = f"{self.BASE_URL}/klines"
        params = {"symbol": symbol.upper(), "interval": interval, "limit": limit}
        async with httpx.AsyncClient() as client:
            try:
                response = await client.get(url, params=params, timeout=10.0)
                response.raise_for_status()
                return response.json()
            except Exception as e:
                logger.error(f"Binance REST API error (get_historical_klines): {e}")
                return []
