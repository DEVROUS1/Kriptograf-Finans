from dataclasses import dataclass, field
from typing import Optional
from decimal import Decimal


@dataclass(frozen=True, slots=True)
class KlineEvent:
    """
    Binance kline event'ini normalize eden immutable domain model.
    frozen=True → thread-safe, hashable. slots=True → bellek optimize.
    """
    symbol: str
    interval: str
    open_time: int
    open: Decimal
    high: Decimal
    low: Decimal
    close: Decimal
    volume: Decimal
    is_closed: bool
    event_time: int

    @classmethod
    def from_binance_raw(cls, raw: dict) -> "KlineEvent":
        """
        Factory method: Binance raw WebSocket payload'ını parse eder.
        Tüm string fiyatları Decimal'a çeviririz — float rounding hatası yok.
        """
        k = raw["k"]
        return cls(
            symbol=k["s"],
            interval=k["i"],
            open_time=k["t"],
            open=Decimal(k["o"]),
            high=Decimal(k["h"]),
            low=Decimal(k["l"]),
            close=Decimal(k["c"]),
            volume=Decimal(k["v"]),
            is_closed=k["x"],
            event_time=raw["E"],
        )

    def to_client_payload(self) -> dict:
        """Client'a gönderilecek minimal ve tip-güvenli payload."""
        return {
            "s": self.symbol,
            "i": self.interval,
            "t": self.open_time,
            "o": str(self.open),
            "h": str(self.high),
            "l": str(self.low),
            "c": str(self.close),
            "v": str(self.volume),
            "x": self.is_closed,
            "E": self.event_time,
        }