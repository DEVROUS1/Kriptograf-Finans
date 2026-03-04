import pandas as pd
import numpy as np
import ta
import logging

logger = logging.getLogger(__name__)

class TechnicalAnalyzer:
    @staticmethod
    def analyze_klines(klines_data: list) -> dict:
        try:
            if not klines_data or len(klines_data) < 50:
                return {"score": 50, "action": "Neutral", "error": "Not enough data"}

            df = pd.DataFrame(klines_data, columns=[
                "open_time", "open", "high", "low", "close", "volume",
                "close_time", "quote_av", "trades", "tb_base_av", "tb_quote_av", "ignore"
            ])
            for col in ["open", "high", "low", "close", "volume"]:
                df[col] = pd.to_numeric(df[col], errors="coerce")

            close = df["close"]
            high = df["high"]
            low = df["low"]
            volume = df["volume"]
            current_price = close.iloc[-1]

            # ═══════════════════════ MOMENTUM ═══════════════════════
            rsi = ta.momentum.RSIIndicator(close, window=14).rsi().iloc[-1]
            stoch_rsi = ta.momentum.StochRSIIndicator(close, window=14).stochrsi().iloc[-1] * 100
            stoch_k = ta.momentum.StochRSIIndicator(close, window=14).stochrsi_k().iloc[-1] * 100
            stoch_d = ta.momentum.StochRSIIndicator(close, window=14).stochrsi_d().iloc[-1] * 100
            cci = ta.trend.CCIIndicator(high, low, close, window=20).cci().iloc[-1]
            williams_r = ta.momentum.WilliamsRIndicator(high, low, close, lbp=14).williams_r().iloc[-1]
            roc = ta.momentum.ROCIndicator(close, window=12).roc().iloc[-1]
            awesome_osc = ta.momentum.AwesomeOscillatorIndicator(high, low).awesome_oscillator().iloc[-1]
            ultimate_osc = ta.momentum.UltimateOscillator(high, low, close).ultimate_oscillator().iloc[-1]

            # ═══════════════════════ TREND ═══════════════════════
            macd_obj = ta.trend.MACD(close)
            macd_val = macd_obj.macd().iloc[-1]
            macd_signal = macd_obj.macd_signal().iloc[-1]
            macd_hist = macd_obj.macd_diff().iloc[-1]
            adx = ta.trend.ADXIndicator(high, low, close, window=14).adx().iloc[-1]
            plus_di = ta.trend.ADXIndicator(high, low, close, window=14).adx_pos().iloc[-1]
            minus_di = ta.trend.ADXIndicator(high, low, close, window=14).adx_neg().iloc[-1]

            # Hareketli Ortalamalar
            ema_9 = ta.trend.EMAIndicator(close, window=9).ema_indicator().iloc[-1]
            ema_20 = ta.trend.EMAIndicator(close, window=20).ema_indicator().iloc[-1]
            ema_50 = ta.trend.EMAIndicator(close, window=50).ema_indicator().iloc[-1]
            sma_10 = ta.trend.SMAIndicator(close, window=10).sma_indicator().iloc[-1]
            sma_20 = ta.trend.SMAIndicator(close, window=20).sma_indicator().iloc[-1]
            sma_50 = ta.trend.SMAIndicator(close, window=50).sma_indicator().iloc[-1]

            # Ichimoku (tenkan/kijun)
            ichimoku = ta.trend.IchimokuIndicator(high, low, window1=9, window2=26)
            tenkan = ichimoku.ichimoku_conversion_line().iloc[-1]
            kijun = ichimoku.ichimoku_base_line().iloc[-1]

            # ═══════════════════════ VOLATILITY ═══════════════════════
            bb = ta.volatility.BollingerBands(close, window=20)
            bb_upper = bb.bollinger_hband().iloc[-1]
            bb_middle = bb.bollinger_mavg().iloc[-1]
            bb_lower = bb.bollinger_lband().iloc[-1]
            bb_width = bb.bollinger_wband().iloc[-1]
            atr = ta.volatility.AverageTrueRange(high, low, close, window=14).average_true_range().iloc[-1]

            # ═══════════════════════ VOLUME ═══════════════════════
            obv = ta.volume.OnBalanceVolumeIndicator(close, volume).on_balance_volume().iloc[-1]
            mfi = ta.volume.MFIIndicator(high, low, close, volume, window=14).money_flow_index().iloc[-1]
            vwap_val = (df["quote_av"].astype(float).cumsum() / volume.cumsum()).iloc[-1] if volume.sum() > 0 else current_price

            # ═══════════════════════ DESTEK / DİRENÇ (Pivot Points) ═══════════════════════
            prev_high = high.iloc[-2]
            prev_low = low.iloc[-2]
            prev_close = close.iloc[-2]
            pivot = (prev_high + prev_low + prev_close) / 3
            support_1 = (2 * pivot) - prev_high
            support_2 = pivot - (prev_high - prev_low)
            support_3 = prev_low - 2 * (prev_high - pivot)
            resistance_1 = (2 * pivot) - prev_low
            resistance_2 = pivot + (prev_high - prev_low)
            resistance_3 = prev_high + 2 * (pivot - prev_low)

            # ═══════════════════════ SKORLAMA ═══════════════════════
            score = 50

            # RSI
            if pd.notna(rsi):
                if rsi < 30: score += 12
                elif rsi < 40: score += 5
                elif rsi > 70: score -= 12
                elif rsi > 60: score -= 5

            # MACD
            if pd.notna(macd_val) and pd.notna(macd_signal):
                if macd_val > macd_signal: score += 8
                else: score -= 8

            # ADX trend gücü
            if pd.notna(adx) and pd.notna(plus_di) and pd.notna(minus_di):
                if adx > 25:
                    if plus_di > minus_di: score += 6
                    else: score -= 6

            # CCI
            if pd.notna(cci):
                if cci < -100: score += 5
                elif cci > 100: score -= 5

            # Hareketli Ortalamalar
            if pd.notna(ema_20) and current_price > ema_20: score += 4
            elif pd.notna(ema_20): score -= 4
            if pd.notna(sma_50) and current_price > sma_50: score += 6
            elif pd.notna(sma_50): score -= 6

            # Williams %R
            if pd.notna(williams_r):
                if williams_r < -80: score += 5
                elif williams_r > -20: score -= 5

            # Bollinger position
            if pd.notna(bb_lower) and current_price <= bb_lower: score += 6
            elif pd.notna(bb_upper) and current_price >= bb_upper: score -= 6

            # MFI
            if pd.notna(mfi):
                if mfi < 20: score += 4
                elif mfi > 80: score -= 4

            # Ichimoku
            if pd.notna(tenkan) and pd.notna(kijun):
                if tenkan > kijun: score += 4
                else: score -= 4

            score = max(0, min(100, score))
            if score >= 62: action = "Buy"
            elif score <= 38: action = "Sell"
            else: action = "Neutral"

            def safe(v):
                return round(float(v), 4) if pd.notna(v) else None

            return {
                "score": int(score),
                "action": action,
                "indicators": {
                    # Momentum
                    "rsi": safe(rsi),
                    "stoch_rsi": safe(stoch_rsi),
                    "stoch_k": safe(stoch_k),
                    "stoch_d": safe(stoch_d),
                    "cci": safe(cci),
                    "williams_r": safe(williams_r),
                    "roc": safe(roc),
                    "awesome_osc": safe(awesome_osc),
                    "ultimate_osc": safe(ultimate_osc),
                    "mfi": safe(mfi),
                    # Trend
                    "macd": safe(macd_val),
                    "macd_signal": safe(macd_signal),
                    "macd_hist": safe(macd_hist),
                    "adx": safe(adx),
                    "plus_di": safe(plus_di),
                    "minus_di": safe(minus_di),
                    # Moving Averages
                    "ema_9": safe(ema_9),
                    "ema_20": safe(ema_20),
                    "ema_50": safe(ema_50),
                    "sma_10": safe(sma_10),
                    "sma_20": safe(sma_20),
                    "sma_50": safe(sma_50),
                    # Ichimoku
                    "tenkan": safe(tenkan),
                    "kijun": safe(kijun),
                    # Volatility
                    "bb_upper": safe(bb_upper),
                    "bb_middle": safe(bb_middle),
                    "bb_lower": safe(bb_lower),
                    "bb_width": safe(bb_width),
                    "atr": safe(atr),
                    # Volume
                    "obv": safe(obv),
                    "vwap": safe(vwap_val),
                    # Price
                    "price": safe(current_price),
                },
                "support_resistance": {
                    "pivot": safe(pivot),
                    "s1": safe(support_1),
                    "s2": safe(support_2),
                    "s3": safe(support_3),
                    "r1": safe(resistance_1),
                    "r2": safe(resistance_2),
                    "r3": safe(resistance_3),
                }
            }

        except Exception as e:
            logger.error(f"Technical Analysis Error: {e}")
            return {"score": 50, "action": "Neutral", "error": str(e)}
