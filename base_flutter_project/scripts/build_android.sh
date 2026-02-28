#!/bin/bash

FLAVOR=$1
ENTRYPOINT=$2
FULL_ADS=$3

echo "🛠️  Building APK with:"
echo "FLAVOR: $FLAVOR"
echo "ENTRYPOINT: $ENTRYPOINT"
echo "FULL_ADS: $FULL_ADS"

# Tên thư mục hiện tại là tên project
PROJECT_NAME=$(basename "$PWD")

# Xử lý dart-define và hậu tố tên file
if [ -z "$FULL_ADS" ] || [ "$FULL_ADS" = "false" ]; then
  DART_DEFINE=""
  FILE_SUFFIX="normal"
else
  DART_DEFINE="--dart-define=FULL_ADS=$FULL_ADS"
  FILE_SUFFIX="full-ads"
fi

# Lấy version từ build.gradle
VERSION_NAME=$(grep versionName android/app/build.gradle | head -1 | sed 's/[^0-9.]//g')

# Chọn flutter command
if [[ -f ".fvmrc" ]] && command -v fvm &> /dev/null; then
  FLUTTER_CMD="fvm flutter"
else
  FLUTTER_CMD="flutter"
fi

# Build APK
CMD="$FLUTTER_CMD build apk --flavor $FLAVOR -t $ENTRYPOINT $DART_DEFINE"
echo "🚀 Running: $CMD"
eval $CMD

# Đổi tên file APK
SRC="build/app/outputs/flutter-apk/app-$FLAVOR-release.apk"
DEST="build/app/outputs/flutter-apk/${PROJECT_NAME}-${FLAVOR}-v${VERSION_NAME}-${FILE_SUFFIX}.apk"

if [ -f "$SRC" ]; then
  mv "$SRC" "$DEST"
  echo "✅ APK renamed to: $DEST"
  # Mở thư mục chứa file build
  echo "📂 Opening folder: $(dirname "$DEST")"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    open "$(dirname "$DEST")"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open "$(dirname "$DEST")"
  fi
else
  echo "❌ APK not found at: $SRC"
fi

