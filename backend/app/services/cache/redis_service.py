import json
import logging
from typing import Any

import redis.asyncio as aioredis

from app.core.config import get_settings

logger = logging.getLogger(__name__)
settings = get_settings()


class RedisService:
    """
    Single Responsibility: Sadece Redis pub/sub ve cache operasyonları.
    
    Fan-out mimarisi: Binance'ten gelen 1 event → Redis channel →
    N adet bağlı Flutter client'ına dağıtılır. Bu sayede her client için
    ayrı Binance bağlantısı açılmaz (kaynak tasarrufu kritik).
    """

    def __init__(self) -> None:
        self._pool = aioredis.ConnectionPool.from_url(
            settings.REDIS_URL,
            max_connections=50,
            decode_responses=True,
        )
        self._client = aioredis.Redis(connection_pool=self._pool)

    def _channel_name(self, symbol: str, interval: str) -> str:
        """
        Kanal adlandırma konvansiyonu: "kline:BTCUSDT:1m"
        Tüm servisler aynı konvansiyonu kullanmalı.
        """
        return f"kline:{symbol.upper()}:{interval}"

    async def publish_kline(self, symbol: str, interval: str, data: dict) -> None:
        """Kline event'ini Redis pub/sub kanalına yayınla."""
        channel = self._channel_name(symbol, interval)
        try:
            await self._client.publish(channel, json.dumps(data))
            # Son değeri cache'le (yeni bağlanan client'lar için)
            cache_key = f"cache:{channel}"
            await self._client.set(cache_key, json.dumps(data), ex=10)
        except Exception as e:
            logger.error("Redis publish hatası: %s", e)

    async def get_latest_kline(self, symbol: str, interval: str) -> dict | None:
        """Yeni bağlanan client için son bilinen değeri döndür."""
        cache_key = f"cache:kline:{symbol.upper()}:{interval}"
        raw = await self._client.get(cache_key)
        return json.loads(raw) if raw else None

    async def subscribe_kline(
        self,
        symbol: str,
        interval: str,
    ):
        """
        Async generator: Redis kanalından mesaj yield eder.
        ConnectionManager bu generator'ı tüketir ve client'lara iletir.
        """
        channel = self._channel_name(symbol, interval)
        pubsub = self._client.pubsub()
        await pubsub.subscribe(channel)
        logger.info("Redis subscribe: %s", channel)

        try:
            async for message in pubsub.listen():
                if message["type"] == "message":
                    yield json.loads(message["data"])
        finally:
            await pubsub.unsubscribe(channel)
            await pubsub.aclose()

    async def close(self) -> None:
        await self._client.aclose()
        await self._pool.aclose()