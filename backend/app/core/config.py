from functools import lru_cache
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
    )

    # App
    APP_NAME: str = "KriptoGraf Finans API"
    DEBUG: bool = False
    API_V1_PREFIX: str = "/api/v1"

    # Database
    DATABASE_URL: str = "postgresql+asyncpg://kriptograf:secret@localhost:5432/kriptograf_db"

    # Redis
    REDIS_URL: str = "redis://localhost:6379/0"

    # Security
    SECRET_KEY: str = "change-me-in-production"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24  # 1 gün

    # External
    FCM_SERVER_KEY: str = ""
    TELEGRAM_BOT_TOKEN: str = ""


@lru_cache
def get_settings() -> Settings:
    """Singleton pattern — env sadece bir kez okunur."""
    return Settings()