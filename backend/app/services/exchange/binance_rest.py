import json
import logging
import httpx

logger = logging.getLogger(__name__)

class BinanceRESTService:
    BASE_URL = "https://api.binance.com/api/v3"
    FUTURES_BASE_URL = "https://fapi.binance.com/fapi/v1"

    async def get_ticker_24h(self, symbol: str) -> dict:
        """Tek bir sembol için 24s ticker verisi."""
        url = f"{self.BASE_URL}/ticker/24hr"
        params = {"symbol": symbol.upper()}
        async with httpx.AsyncClient() as client:
            try:
                response = await client.get(url, params=params, timeout=10.0)
                if response.status_code == 200:
                    return response.json()
                return {}
            except Exception as e:
                logger.error(f"Binance REST API error (get_ticker_24h): {e}")
                return {}

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

    async def get_open_interest(self, symbol: str) -> dict:
        """Vadeli işlem açık pozisyon miktarı"""
        url = f"{self.FUTURES_BASE_URL}/openInterest"
        params = {"symbol": symbol.upper()}
        async with httpx.AsyncClient() as client:
            try:
                response = await client.get(url, params=params, timeout=10.0)
                response.raise_for_status()
                return response.json()
            except Exception as e:
                logger.error(f"Binance Futures API error (openInterest): {e}")
                return {}

    async def get_long_short_ratio(self, symbol: str, period: str = "5m") -> list:
        """Global Long/Short oranı"""
        url = f"{self.FUTURES_BASE_URL}/globalLongShortAccountRatio"
        params = {"symbol": symbol.upper(), "period": period, "limit": 30}
        async with httpx.AsyncClient() as client:
            try:
                response = await client.get(url, params=params, timeout=10.0)
                response.raise_for_status()
                return response.json()
            except Exception as e:
                logger.error(f"Binance Futures API error (longShortRatio): {e}")
                return []

    async def get_funding_rate(self, symbol: str) -> list:
        """Fonlama oranı geçmişi"""
        url = f"{self.FUTURES_BASE_URL}/fundingRate"
        params = {"symbol": symbol.upper(), "limit": 10}
        async with httpx.AsyncClient() as client:
            try:
                response = await client.get(url, params=params, timeout=10.0)
                response.raise_for_status()
                return response.json()
            except Exception as e:
                logger.error(f"Binance Futures API error (fundingRate): {e}")
                return []

    async def get_top_long_short_position_ratio(self, symbol: str, period: str = "5m") -> list:
        """Top Trader pozisyon oranı"""
        url = f"{self.FUTURES_BASE_URL}/topLongShortPositionRatio"
        params = {"symbol": symbol.upper(), "period": period, "limit": 30}
        async with httpx.AsyncClient() as client:
            try:
                response = await client.get(url, params=params, timeout=10.0)
                response.raise_for_status()
                return response.json()
            except Exception as e:
                logger.error(f"Binance Futures API error (topLSRatio): {e}")
                return []
