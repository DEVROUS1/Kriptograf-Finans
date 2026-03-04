import asyncio
import json
import logging

from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Depends

from app.api.websocket.manager import connection_manager
from app.services.cache.redis_service import RedisService
from app.services.exchange.binance import BinanceStreamClient
from app.core.config import get_settings

logger = logging.getLogger(__name__)
settings = get_settings()
router = APIRouter()

# Dependency injection ile Redis servisi
_redis_service = RedisService()


async def _feed_redis_from_binance(symbol: str, interval: str) -> None:
    """
    Background task: Binance → Redis pipeline.
    Bu task, ilk client o sembolü istediğinde başlatılır.
    Aynı sembolü isteyen ikinci client yeni bir task başlatmaz
    (ConnectionManager'daki room kontrolü sayesinde).
    """
    client = BinanceStreamClient()
    try:
        async for kline_event in client.stream_klines(symbol, interval):
            payload = kline_event.to_client_payload()
            # 1) Redis'e publish et (diğer worker'lar da okuyabilir)
            await _redis_service.publish_kline(symbol, interval, payload)
            # 2) Aynı process içindeki client'lara direkt broadcast
            await connection_manager.broadcast_to_room(symbol, interval, payload)
    except asyncio.CancelledError:
        logger.info("Binance feed task iptal edildi: %s %s", symbol, interval)
    finally:
        await client.close()


@router.websocket("/ws/kline/{symbol}/{interval}")
async def kline_websocket_endpoint(
    websocket: WebSocket,
    symbol: str,
    interval: str,
) -> None:
    """
    Client bağlantı endpoint'i.
    
    Protocol:
    1. Client bağlanır → accept
    2. Son bilinen kline cache'den gönderilir (bağlantı anında UI hemen dolar)
    3. Yeni data geldiğinde broadcast_to_room tetiklenir
    4. Client kapanırsa temiz disconnect
    
    Ölçekleme notu: Çok sayıda unique sembol varsa _feed_redis_from_binance
    task'ları Redis pub/sub üzerinden ayrıştırılabilir.
    """
    valid_intervals = {"1s", "1m", "3m", "5m", "15m", "30m", "1h", "4h", "1d", "1w"}
    if interval not in valid_intervals:
        await websocket.close(code=4001, reason=f"Geçersiz interval: {interval}")
        return

    await connection_manager.connect(websocket, symbol, interval)

    # İlk client bu room'u açıyorsa Binance feed task'ını başlat
    is_first_in_room = connection_manager.active_rooms.get(
        f"{symbol.upper()}:{interval}", 0
    ) == 1

    feed_task: asyncio.Task | None = None
    if is_first_in_room:
        feed_task = asyncio.create_task(
            _feed_redis_from_binance(symbol, interval),
            name=f"binance_feed_{symbol}_{interval}",
        )
        logger.info("Yeni Binance feed task başlatıldı: %s@kline_%s", symbol, interval)

    try:
        # Cache'deki son değeri hemen gönder (cold start UX)
        cached = await _redis_service.get_latest_kline(symbol, interval)
        if cached:
            await websocket.send_json({**cached, "_cached": True})

        # Client kapanana kadar bekle (mesaj bekliyoruz ama sadece ping için)
        while True:
            try:
                # Client'tan ping/pong veya kontrol mesajı bekle
                data = await asyncio.wait_for(
                    websocket.receive_text(),
                    timeout=30.0,
                )
                if data == "ping":
                    await websocket.send_text("pong")
            except asyncio.TimeoutError:
                # 30s'de bir keepalive
                try:
                    await websocket.send_json({"type": "keepalive"})
                except Exception:
                    break

    except WebSocketDisconnect:
        logger.info("Client normal disconnect: %s@kline_%s", symbol, interval)
    except Exception as e:
        logger.error("WebSocket endpoint hatası: %s", e)
    finally:
        await connection_manager.disconnect(websocket, symbol, interval)
        # Room boşaldıysa feed task'ı iptal et (kaynak tasarrufu)
        active = connection_manager.active_rooms
        if f"{symbol.upper()}:{interval}" not in active and feed_task:
            feed_task.cancel()
            logger.info("Binance feed task durduruldu (room boş): %s@%s", symbol, interval)
            