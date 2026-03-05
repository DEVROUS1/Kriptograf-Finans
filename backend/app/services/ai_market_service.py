import logging
import google.generativeai as genai
from app.core.config import get_settings
from app.services.exchange.binance_rest import BinanceRESTService
from app.services.exchange.whale_detection import WhaleDetectionService

logger = logging.getLogger(__name__)
settings = get_settings()

class AIMarketService:
    def __init__(self):
        # API Key set edilmişse Gemini yapılandırılır
        if settings.GEMINI_API_KEY and settings.GEMINI_API_KEY != "your-api-key-here":
            genai.configure(api_key=settings.GEMINI_API_KEY)
            self.model = genai.GenerativeModel('gemini-pro')
            self.has_api = True
        else:
            self.has_api = False
            logger.warning("GEMINI_API_KEY set edilmemiş. AI analizi kısıtlı modda çalışacak.")

    async def get_market_analysis(self, symbol: str = "BTCUSDT"):
        """
        Piyasa verilerini toplar ve Gemini ile derin analiz üretir.
        """
        # 1. Veri Toplama
        binance = BinanceRESTService()
        whale = WhaleDetectionService()
        
        # Fiyat ve 24h özet
        ticker = await binance.get_ticker_24h(symbol) or {}
        last_price = ticker.get("lastPrice", "0")
        price_change = ticker.get("priceChangePercent", "0")
        high = ticker.get("highPrice", "0")
        low = ticker.get("lowPrice", "0")
        volume = ticker.get("quoteVolume", "0")

        # Balina aktiviteleri
        whale_data = await whale.get_all_whale_activity()
        whale_trades = whale_data.get("trades", [])[:5] # Son 5 büyük işlem
        whale_stats = whale_data.get("stats", {})

        # Teknik gösterge simülasyonu/özeti (backend'de ta kütüphanesi kullanılabilir)
        # Şimdilik temel verileri gönderiyoruz, Gemini bunları yorumlayabilir.

        # 2. Prompt Hazırlama
        prompt = f"""
        Sen profesyonel bir kripto piyasa analiz uzmanısın. İşte {symbol} için güncel piyasa verileri:
        
        - Güncel Fiyat: ${last_price}
        - 24s Değişim: %{price_change}
        - Günlük Aralık: ${low} - ${high}
        - 24s Hacim: ${float(volume):,.0f}
        
        Balina Aktiviteleri (Son büyük işlemler):
        {self._format_whale_trades(whale_trades)}
        
        Genel Balina İstatistiği:
        - Whale Alış Hacmi: ${whale_stats.get('buy_volume', 0):,.0f}
        - Whale Satış Hacmi: ${whale_stats.get('sell_volume', 0):,.0f}
        - Giga Whale ({GIGA_WHALE_THRESHOLD} USD+): {whale_stats.get('giga_whale_count', 0)} adet
        
        Senden beklenenler:
        1. Bu verileri teknik ve temel açıdan analiz et.
        2. Balina hareketlerinin fiyata olası etkisini yorumla.
        3. Kısa ve orta vadeli görünüm (Boğa/Ayı/Nötr) hakkında görüşünü bildir.
        4. Yatırımcılar için dikkat edilmesi gereken kritik seviyeleri belirt.
        
        Analizi profesyonel, objektif ve Türkçe olarak hazırla. 
        Analizin sonuna "Bu bir yatırım tavsiyesi değildir" notunu ekle.
        Okunabilir olması için markdown formatında (başlıklar, listeler) yaz.
        """

        # 3. AI Yanıtı Üretme
        if self.has_api:
            try:
                response = self.model.generate_content(prompt)
                return response.text
            except Exception as e:
                logger.error(f"Gemini API hatası: {e}")
                return self._get_fallback_analysis(symbol, last_price, price_change)
        else:
            return self._get_fallback_analysis(symbol, last_price, price_change)

    def _format_whale_trades(self, trades):
        if not trades:
            return "Belirgin balina hareketi saptanmadı."
        fmt_list = []
        for t in trades:
            fmt_list.append(f"- {t['symbol']}: ${t['usd_value']:,.0f} {t['side']} ({t['level']})")
        return "\n".join(fmt_list)

    def _get_fallback_analysis(self, symbol, price, change):
        """API hatası durumunda kural tabanlı analiz."""
        sentiment = "Pozitif" if float(change) > 0 else "Negatif"
        return f"""
        ### {symbol} Piyasa Özeti (Analiz Modülü Beklemede)
        
        Şu anki verilere göre {symbol} fiyatı **${price}** seviyesindedir ve son 24 saatte **%{change}** değişim göstermiştir.
        Piyasa görünümü şu an için kısmen **{sentiment}** eğilimindedir.
        
        *Not: AI Analiz servisimiz tam kapasiteyle çalışabilmesi için Gemini API anahtarı yapılandırılmalıdır. Teknik göstergeler ve derin balina analizi yakında aktif olacaktır.*
        
        **Kritik Seviyeler:**
        - Destek: Mevcut fiyata göre %3-5 aşağısı.
        - Direnç: Günlük en yüksek seviye olan ${price}.
        
        *Bu bir yatırım tavsiyesi değildir.*
        """

GIGA_WHALE_THRESHOLD = 5_000_000 # whale_detection.py ile uyumlu
