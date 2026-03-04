#!/bin/bash
set -e

echo "🚀 KriptoGraf Finans - Gelişmiş Cloudflare Build Başlıyor..."

# 1. İşlem göreceğimiz asıl dizini (repo) kaydedelim
export PROJECT_DIR=$(pwd)
echo "📂 Proje Dizini: $PROJECT_DIR"

# 2. Flutter'ı Cloudflare'ın git sistemini bozmamak için /opt altına kuralım
echo "📦 Eski Flutter çakışması önleniyor..."
cd /opt
git clone https://github.com/flutter/flutter.git -b 3.24.5 /opt/flutter
export PATH="$PATH:/opt/flutter/bin"

# 3. Kendi kodumuza (frontend) geri dönelim
cd "$PROJECT_DIR/frontend"
echo "📂 Çalışma Dizini: $(pwd)"

# 4. Derlemeyi tamamlayalım
echo "⚙️ Flutter paketleri alınıyor..."
flutter pub get

echo "🔨 Web sürümü derleniyor..."
flutter build web --release

echo "✅ Derleme Başarılı!"
