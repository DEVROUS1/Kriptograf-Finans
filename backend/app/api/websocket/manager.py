import asyncio
import json
import logging
from collections import defaultdict
from typing import DefaultDict, Set

from fastapi import WebSocket, WebSocketDisconnect

logger = logging.getLogger(__name__)


class ConnectionManager:
    """
    Topic-based WebSocket room yöneticisi.
    
    Mimari: Her sembol+interval kombinasyonu bir "room"dur.
    Aynı room'daki tüm client'lara broadcast yapılır.
    
    Thread-safety: asyncio.Lock ile korunur (FastAPI single-process için yeterli).
    Multi-process için Redis'in kendi pub/sub mekanizması kullanılır.
    
    Rooms: {"BTCUSDT:1m": {ws1, ws2, ws3}, "ETHUSDT:5m": {ws4}}
    """

    def __init__(self) -> None:
        self._rooms: DefaultDict[str, Set[WebSocket]] = defaultdict(set)
        self._lock = asyncio.Lock()

    def _room_key(self, symbol: str, interval: str) -> str:
        return f"{symbol.upper()}:{interval}"

    async def connect(self, websocket: WebSocket, symbol: str, interval: str) -> None:
        await websocket.accept()
        room = self._room_key(symbol, interval)
        async with self._lock:
            self._rooms[room].add(websocket)
        logger.info(
            "Client bağlandı → room: %s | toplam: %d",
            room,
            len(self._rooms[room]),
        )

    async def disconnect(self, websocket: WebSocket, symbol: str, interval: str) -> None:
        room = self._room_key(symbol, interval)
        async with self._lock:
            self._rooms[room].discard(websocket)
            if not self._rooms[room]:
                del self._rooms[room]
        logger.info("Client ayrıldı → room: %s", room)

    async def broadcast_to_room(self, symbol: str, interval: str, data: dict) -> None:
        """
        Room'daki tüm bağlı client'lara mesaj gönder.
        Hatalı client'ları silently temizle — bir client'ın kopması
        diğerlerini etkilemez (defensive broadcasting).
        """
        room = self._room_key(symbol, interval)
        if room not in self._rooms:
            return

        dead_connections: Set[WebSocket] = set()
        payload = json.dumps(data)

        # Snapshot al: iteration sırasında set değişebilir
        async with self._lock:
            targets = set(self._rooms[room])

        for websocket in targets:
            try:
                await websocket.send_text(payload)
            except Exception:
                dead_connections.add(websocket)

        # Kopan bağlantıları temizle
        if dead_connections:
            async with self._lock:
                self._rooms[room] -= dead_connections
            logger.debug("%d kopuk client temizlendi.", len(dead_connections))

    @property
    def active_rooms(self) -> dict[str, int]:
        """Monitoring/health-check için aktif room bilgisi."""
        return {room: len(clients) for room, clients in self._rooms.items()}


# Uygulama genelinde tek instance (FastAPI dependency injection ile kullanılır)
connection_manager = ConnectionManager()