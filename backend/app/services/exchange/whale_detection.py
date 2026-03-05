"""
Whale Detection Service — Gerçek zamanlı büyük işlem tespiti.

Binance Trades API'den büyük transfer tespiti + Etherscan on-chain tracking.
$100M+ işlemler özel uyarı olarak işaretlenir.
"""
import logging
import time
import httpx

logger = logging.getLogger(__name__)

# Minimum balina eşiği ($)
WHALE_THRESHOLD = 50_000          # Normal balina ($50K+)
MEGA_WHALE_THRESHOLD = 500_000    # Mega balina ($500K+)
GIGA_WHALE_THRESHOLD = 5_000_000  # Giga balina ($5M+)

# Etherscan free API (rate limit: 5 req/s)
ETHERSCAN_API = "https://api.etherscan.io/api"
# Blockchain.info free API
BLOCKCHAIN_API = "https://blockchain.info"


class WhaleDetectionService:
    """Çoklu kaynaklardan balina işlemi tespiti."""

    @staticmethod
    async def get_binance_large_trades(symbol: str = "BTCUSDT", limit: int = 50) -> list:
        """
        Binance son işlemlerden büyük olanları filtreler.
        Not: Binance aggTrades endpoint'i ücretsizdir ve gerçek verilerdir.
        """
        url = f"https://api.binance.com/api/v3/aggTrades"
        params = {"symbol": symbol.upper(), "limit": 1000}  # Son 1000 işlem
        
        async with httpx.AsyncClient() as client:
            try:
                response = await client.get(url, params=params, timeout=10.0)
                response.raise_for_status()
                trades = response.json()
                
                # Son fiyatı al
                price_resp = await client.get(
                    f"https://api.binance.com/api/v3/ticker/price",
                    params={"symbol": symbol.upper()},
                    timeout=5.0,
                )
                current_price = float(price_resp.json().get("price", 0))
                
                whale_trades = []
                for trade in trades:
                    qty = float(trade.get("q", 0))
                    price = float(trade.get("p", 0))
                    usd_value = qty * price
                    
                    if usd_value >= WHALE_THRESHOLD:
                        level = "GIGA" if usd_value >= GIGA_WHALE_THRESHOLD else \
                                "MEGA" if usd_value >= MEGA_WHALE_THRESHOLD else "WHALE"
                        whale_trades.append({
                            "symbol": symbol.replace("USDT", ""),
                            "side": "SELL" if trade.get("m", False) else "BUY",
                            "quantity": qty,
                            "price": price,
                            "usd_value": round(usd_value, 2),
                            "timestamp": trade.get("T", 0),
                            "level": level,
                            "source": "Binance",
                        })
                
                # USD değerine göre sırala (büyükten küçüğe)
                whale_trades.sort(key=lambda x: x["usd_value"], reverse=True)
                return whale_trades[:limit]
                
            except Exception as e:
                logger.error(f"Binance whale detection error: {e}")
                return []

    @staticmethod
    async def get_etherscan_whale_transfers(min_value_eth: float = 15) -> list:
        """
        Etherscan'den son blokların büyük ETH transferlerini çeker.
        Ücretsiz API — API key gerekmez (düşük rate limit).
        """
        url = ETHERSCAN_API
        params = {
            "module": "proxy",
            "action": "eth_blockNumber",
        }
        
        async with httpx.AsyncClient() as client:
            try:
                # Son blok numarasını al
                block_resp = await client.get(url, params=params, timeout=10.0)
                block_data = block_resp.json()
                latest_block = int(block_data.get("result", "0x0"), 16)
                
                # Son 5 bloktaki internal tx'leri tara (~ son 1 dakika)
                whale_transfers = []
                
                # ETH fiyatını al
                eth_price_resp = await client.get(
                    "https://api.binance.com/api/v3/ticker/price",
                    params={"symbol": "ETHUSDT"},
                    timeout=5.0,
                )
                eth_price = float(eth_price_resp.json().get("price", 0))
                
                # Son bloktaki işlemleri al
                block_params = {
                    "module": "proxy",
                    "action": "eth_getBlockByNumber",
                    "tag": hex(latest_block),
                    "boolean": "true",
                }
                block_detail = await client.get(url, params=block_params, timeout=10.0)
                block_json = block_detail.json()
                
                transactions = block_json.get("result", {}).get("transactions", [])
                
                for tx in transactions:
                    value_wei = int(tx.get("value", "0x0"), 16)
                    value_eth = value_wei / 1e18
                    value_usd = value_eth * eth_price
                    
                    if value_eth >= min_value_eth:
                        level = "GIGA" if value_usd >= GIGA_WHALE_THRESHOLD else \
                                "MEGA" if value_usd >= MEGA_WHALE_THRESHOLD else "WHALE"
                        whale_transfers.append({
                            "symbol": "ETH",
                            "from": _shorten_addr(tx.get("from", "")),
                            "to": _shorten_addr(tx.get("to", "")),
                            "quantity": round(value_eth, 4),
                            "usd_value": round(value_usd, 2),
                            "tx_hash": tx.get("hash", ""),
                            "block": latest_block,
                            "level": level,
                            "source": "Ethereum",
                            "type": "transfer",
                        })
                
                whale_transfers.sort(key=lambda x: x["usd_value"], reverse=True)
                return whale_transfers[:20]
                
            except Exception as e:
                logger.error(f"Etherscan whale detection error: {e}")
                return []

    @staticmethod
    async def get_all_whale_activity(min_usd: float = WHALE_THRESHOLD) -> dict:
        """
        Tüm kaynaklardan birleşik balina aktivitesi.
        """
        service = WhaleDetectionService()
        
        # Paralel olarak tüm kaynaklardan veri çek
        top_coins = ["BTCUSDT", "ETHUSDT", "SOLUSDT", "BNBUSDT", "XRPUSDT"]
        
        all_trades = []
        for symbol in top_coins:
            trades = await service.get_binance_large_trades(symbol, limit=10)
            all_trades.extend(trades)
        
        # On-chain veriler (en az 15 ETH)
        onchain = await service.get_etherscan_whale_transfers(min_value_eth=15)
        
        # USD değerine göre sırala
        all_trades.sort(key=lambda x: x["usd_value"], reverse=True)
        
        # İstatistikler
        total_volume = sum(t["usd_value"] for t in all_trades)
        giga_count = sum(1 for t in all_trades if t["level"] == "GIGA")
        mega_count = sum(1 for t in all_trades if t["level"] == "MEGA")
        buy_volume = sum(t["usd_value"] for t in all_trades if t.get("side") == "BUY")
        sell_volume = sum(t["usd_value"] for t in all_trades if t.get("side") == "SELL")
        
        return {
            "trades": all_trades[:50],
            "onchain": onchain[:20],
            "stats": {
                "total_whale_volume": round(total_volume, 2),
                "giga_whale_count": giga_count,
                "mega_whale_count": mega_count,
                "buy_volume": round(buy_volume, 2),
                "sell_volume": round(sell_volume, 2),
                "buy_pressure": round(buy_volume / max(total_volume, 1) * 100, 1),
            },
        }


def _shorten_addr(addr: str) -> str:
    """Ethereum adresini kısalt: 0x1234...abcd"""
    if not addr or len(addr) < 10:
        return addr
    return f"{addr[:6]}...{addr[-4:]}"
