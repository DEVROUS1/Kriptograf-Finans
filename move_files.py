import os
import shutil

base_dir = r"c:\Users\Kaan\Desktop\yeni uygulmaa"

mappings = {
    # Backend
    "import logging.py": "backend/app/main.py",
    "import asyncio.py": "backend/app/api/websocket/router.py",
    "import asyncio2.py": "backend/app/api/websocket/manager.py",
    "from dataclasses import dataclass, field.py": "backend/app/models/domain/kline.py",
    "from abc import ABC, abstractmethod.py": "backend/app/services/exchange/base.py",
    "import asyncio22.py": "backend/app/services/exchange/binance.py",
    "import json.py": "backend/app/services/cache/redis_service.py",
    "from functools import lru_cache.py": "backend/app/core/config.py",
    "yeni uygulama.yaml": "docker-compose.yml", # root

    # Frontend
    "Untitled-9.yaml": "frontend/pubspec.yaml",
    "Untitled-15.dart": "frontend/lib/main.dart",
    "Untitled-10.txt": "frontend/lib/config/app_config.dart",
    "Untitled-11.dart": "frontend/lib/data/models/kline_model.dart",
    "Untitled-12.dart": "frontend/lib/core/network/websocket_service.dart",
    "Untitled-13.ini": "frontend/lib/presentation/providers/kline_provider.dart",
    "Untitled-14.dart": "frontend/lib/presentation/widgets/live_price_widget.dart"
}

for src_name, dest_rel_path in mappings.items():
    src_path = os.path.join(base_dir, src_name)
    dest_path = os.path.join(base_dir, dest_rel_path)

    if os.path.exists(src_path):
        os.makedirs(os.path.dirname(dest_path), exist_ok=True)
        shutil.move(src_path, dest_path)
        print(f"Moved {src_name} -> {dest_rel_path}")
    else:
        print(f"File not found: {src_path}")
