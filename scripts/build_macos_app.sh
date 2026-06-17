#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="SuperVoiceAssistant"
DISPLAY_NAME="Super Voice Assistant"
BUILD_DIR="$ROOT/.build/release"
DIST_DIR="$ROOT/dist"
APP_DIR="$DIST_DIR/${APP_NAME}.app"

cd "$ROOT"

echo "Building ${APP_NAME} (release)..."
swift build -c release --product "$APP_NAME"

echo "Packaging ${DISPLAY_NAME}.app..."
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

cp "$BUILD_DIR/$APP_NAME" "$APP_DIR/Contents/MacOS/"
cp "$ROOT/Support/Info.plist" "$APP_DIR/Contents/Info.plist"
cp "$ROOT/Sources/AppIcon.icns" "$APP_DIR/Contents/Resources/"
cp "$ROOT/config.json" "$APP_DIR/Contents/Resources/"

if [ -f "$ROOT/.env" ]; then
    cp "$ROOT/.env" "$APP_DIR/Contents/Resources/"
    echo "Included .env in app bundle Resources"
else
    echo "No .env found — copy .env.example to .env before building, or create:"
    echo "  ~/Library/Application Support/SuperVoiceAssistant/.env"
fi

echo ""
echo "Built: $APP_DIR"
echo ""
echo "Next steps:"
echo "  1. Open the app: open \"$APP_DIR\""
echo "  2. Grant Microphone and Accessibility permissions in System Settings"
echo "  3. For Gemini features, add GEMINI_API_KEY to either:"
echo "     - $APP_DIR/Contents/Resources/.env"
echo "     - ~/Library/Application Support/SuperVoiceAssistant/.env"
