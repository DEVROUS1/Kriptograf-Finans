import asyncio
import json
import logging
from typing import AsyncGenerator

import websockets
from websockets.exceptions import ConnectionClosedError, WebSocketException

from app.models.domain.kline import KlineEvent
from app.services.exchange.base import AbstractExchangeStreamClient

logger = logging.getLogger(__name__)

# Binance WebSocket Base URL
_BINANCE_WS_BASE = "wss://stream.binance.com:9443/ws"

# Exponential backoff parametreleri
_INITIAL_BACKOFF_SEC = 1.0
_MAX_BACKOFF_SEC = 60.0
_BACKOFF_FACTOR = 2.0


class BinanceStreamClient(AbstractExchangeStreamClient):
    """
    Binance combined stream'den kline verisi çeken istemci.
    
    Özellikler:
    - Otomatik exponential backoff yeniden bağlanma
    - Graceful shutdown via asyncio.Event
    - Her instance izole: birden fazla sembol için paralel kullanılabilir
    """

    def __init__(self) -> None:
        self._shutdown_event = asyncio.Event()
        self._ws: websockets.WebSocketClientProtocol | None = None

    async def stream_klines(
        self,
        symbol: str,
        interval: str,
    ) -> AsyncGenerator[KlineEvent, None]:
        """
        symbol: "BTCUSDT" (büyük/küçük harf farketmez, normalize edilir)
        interval: "1m", "5m", "1h", "1d" vb.
        """
        stream_name = f"{symbol.lower()}@kline_{interval}"
        url = f"{_BINANCE_WS_BASE}/{stream_name}"
        backoff = _INITIAL_BACKOFF_SEC

        while not self._shutdown_event.is_set():
            try:
                logger.info("Binance WS bağlantısı kuruluyor: %s", url)
                async with websockets.connect(
                    url,
                    ping_interval=20,
                    ping_timeout=10,
                    close_timeout=5,
                ) as ws:
                    self._ws = ws
                    backoff = _INITIAL_BACKOFF_SEC  # başarılı bağlantıda sıfırla
                    logger.info("Binance WS bağlı: %s", stream_name)

                    async for raw_message in ws:
                        if self._shutdown_event.is_set():
                            break

                        try:
                            payload = json.loads(raw_message)
                            # Sadece kline event'lerini işle
                            if payload.get("e") == "kline":
                                yield KlineEvent.from_binance_raw(payload)
                        except (json.JSONDecodeError, KeyError, ValueError) as e:
                            # Bozuk mesajı skip et, stream'i öldürme
                            logger.warning("Binance mesaj parse hatası: %s", e)

            except ConnectionClosedError as e:
                logger.warning(
                    "Binance bağlantısı kapandı (%s). %.1fs sonra yeniden denenecek.",
                    e.code,
                    backoff,
                )
            except WebSocketException as e:
                logger.error("WebSocket hatası: %s. %.1fs sonra yeniden denenecek.", e, backoff)
            except asyncio.CancelledError:
                logger.info("Binance stream iptal edildi: %s", stream_name)
                break

            if not self._shutdown_event.is_set():
                await asyncio.sleep(backoff)
                backoff = min(backoff * _BACKOFF_FACTOR, _MAX_BACKOFF_SEC)

    async def close(self) -> None:
        self._shutdown_event.set()
        if self._ws and not self._ws.closed:
            await self._ws.close()
        logger.info("BinanceStreamClient kapatıldı.")