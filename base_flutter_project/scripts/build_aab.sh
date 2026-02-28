#!/bin/bash

FLAVOR="prod"
ENTRYPOINT="lib/main.dart"

echo "🛠️  Building AAB with FLAVOR=$FLAVOR ENTRYPOINT=$ENTRYPOINT"

PROJECT_NAME=$(basename "$PWD" | cut -d'-' -f1)
CURRENT_DATE=$(date +%d-%m-%Y)
VERSION_NAME=$(grep versionName android/app/build.gradle | head -1 | sed 's/[^0-9.]//g')

if [[ -f ".fvmrc" ]] && command -v fvm &> /dev/null; then
  FLUTTER_CMD="fvm flutter"
else
  FLUTTER_CMD="flutter"
fi

CMD="$FLUTTER_CMD build appbundle --flavor $FLAVOR -t $ENTRYPOINT"
echo "🚀 Running: $CMD"
eval $CMD

OUTPUT_DIR="build/app/outputs/bundle/${FLAVOR}Release"
SRC="$OUTPUT_DIR/app-${FLAVOR}-release.aab"
DEST="$OUTPUT_DIR/${PROJECT_NAME}-${FLAVOR}-v${VERSION_NAME}-${CURRENT_DATE}.aab"

if [ -f "$SRC" ]; then
  [ -f "$DEST" ] && rm "$DEST"
  mv "$SRC" "$DEST"
  echo "✅ AAB renamed to: $DEST"

  # Open folder
  if [[ "$OSTYPE" == "darwin"* ]]; then
    open "$OUTPUT_DIR"
  else
    xdg-open "$OUTPUT_DIR"
  fi
else
  echo "❌ AAB not found at: $SRC"
fi
