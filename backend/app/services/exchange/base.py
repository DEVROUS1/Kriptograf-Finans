from abc import ABC, abstractmethod
from typing import AsyncGenerator
from app.models.domain.kline import KlineEvent


class AbstractExchangeStreamClient(ABC):
    """
    Open/Closed Principle: Yeni exchange eklemek için sadece bu sınıfı
    extend et, mevcut ConnectionManager'a dokunma.
    """

    @abstractmethod
    async def stream_klines(
        self,
        symbol: str,
        interval: str,
    ) -> AsyncGenerator[KlineEvent, None]:
        """
        Yields KlineEvent nesneleri. Bağlantı koptuğunda otomatik
        yeniden bağlanma (backoff) implementasyonu subclass'a aittir.
        """
        ...

    @abstractmethod
    async def close(self) -> None:
        """Temiz kaynak serbest bırakma. Context manager'da çağrılır."""
        ...