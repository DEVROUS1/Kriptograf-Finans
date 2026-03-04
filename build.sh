#!/bin/bash
echo "🚀 KriptoGraf Finans - Cloudflare Build Başlıyor..."

# Ana dizinde miyiz kontrol edelim
echo "📂 Mevcut dizin: $(pwd)"
ls -la

# Flutter SDK'yı indir
echo "📦 Flutter indiriliyor..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Frontend klasörüne gir
echo "➡️ Frontend dizinine geçiliyor..."
cd frontend
echo "📂 Yeni dizin: $(pwd)"

# Flutter komutlarını çalıştır
echo "⚙️ Flutter paketleri alınıyor..."
flutter pub get

echo "🔨 Web sürümü derleniyor..."
flutter build web --release

echo "✅ Derleme tamamlandı!"
