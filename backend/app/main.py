import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import get_settings
from app.api.websocket.router import router as ws_router

logger = logging.getLogger(__name__)
settings = get_settings()


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    FastAPI lifespan: startup ve shutdown hook'ları.
    Eski @app.on_event yerine modern asynccontextmanager kullanıyoruz.
    """
    logger.info("🚀 KriptoGraf Finans API başlatılıyor...")
    # DB bağlantı pool, Redis vs. başlatılabilir
    yield
    # Graceful shutdown
    logger.info("🛑 KriptoGraf Finans API kapatılıyor...")


def create_application() -> FastAPI:
    app = FastAPI(
        title=settings.APP_NAME,
        version="0.1.0",
        docs_url="/docs" if settings.DEBUG else None,
        lifespan=lifespan,
    )

    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],  # Production'da domain listele
        allow_methods=["*"],
        allow_headers=["*"],
    )

    from app.api.v1.router import api_router
    app.include_router(api_router, prefix=settings.API_V1_PREFIX)
    app.include_router(ws_router)  # WS prefix yok, /ws/kline/... direkt

    return app


app = create_application()