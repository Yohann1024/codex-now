#!/bin/bash

set -euo pipefail

APP_NAME="Codex Now.app"
BUNDLE_ID="com.openai.codexnow.launcher"
VERSION="1.0.0"
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$ROOT_DIR/build"
APP_DIR="$BUILD_DIR/$APP_NAME"
INSTALL_DIR="/Applications"
LAUNCHER_SRC="$ROOT_DIR/macos/CodexNowLauncher"
LAUNCHER_DST="$APP_DIR/Contents/MacOS/CodexNowLauncher"
PLIST_DST="$APP_DIR/Contents/Info.plist"
CODEX_ARGS="--dangerously-bypass-approvals-and-sandbox"
ICON_SRC="$HOME/Desktop/哈哈 yes.jpg"
REPO_ICON_SRC="$ROOT_DIR/assets/icon.jpg"
ICONSET_DIR="$BUILD_DIR/CodexNow.iconset"
ICON_DST="$APP_DIR/Contents/Resources/CodexNow.icns"

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${BLUE}$*${NC}"; }
success() { echo -e "${GREEN}$*${NC}"; }
warn() { echo -e "${YELLOW}$*${NC}"; }
fail() { echo -e "${RED}$*${NC}"; exit 1; }

check_system() {
    [ "$(uname)" = "Darwin" ] || fail "❌ Codex Now installer only supports macOS."
    [ -f "$LAUNCHER_SRC" ] || fail "❌ Missing launcher: $LAUNCHER_SRC"

    if command -v codex >/dev/null 2>&1; then
        success "✅ Found Codex: $(command -v codex)"
    else
        warn "⚠️  codex is not currently on PATH. The app will still search common install locations at launch."
    fi
}

build_app() {
    info "🧱 Building $APP_NAME..."
    rm -rf "$APP_DIR"
    mkdir -p "$APP_DIR/Contents/MacOS" "$APP_DIR/Contents/Resources"

    cp "$LAUNCHER_SRC" "$LAUNCHER_DST"
    chmod +x "$LAUNCHER_DST"

    if [ -f "$REPO_ICON_SRC" ]; then
        ICON_SRC="$REPO_ICON_SRC"
    fi

    if [ -f "$ICON_SRC" ]; then
        rm -rf "$ICONSET_DIR"
        mkdir -p "$ICONSET_DIR"
        sips -s format png -z 16 16 "$ICON_SRC" --out "$ICONSET_DIR/icon_16x16.png" >/dev/null
        sips -s format png -z 32 32 "$ICON_SRC" --out "$ICONSET_DIR/icon_16x16@2x.png" >/dev/null
        sips -s format png -z 32 32 "$ICON_SRC" --out "$ICONSET_DIR/icon_32x32.png" >/dev/null
        sips -s format png -z 64 64 "$ICON_SRC" --out "$ICONSET_DIR/icon_32x32@2x.png" >/dev/null
        sips -s format png -z 128 128 "$ICON_SRC" --out "$ICONSET_DIR/icon_128x128.png" >/dev/null
        sips -s format png -z 256 256 "$ICON_SRC" --out "$ICONSET_DIR/icon_128x128@2x.png" >/dev/null
        sips -s format png -z 256 256 "$ICON_SRC" --out "$ICONSET_DIR/icon_256x256.png" >/dev/null
        sips -s format png -z 512 512 "$ICON_SRC" --out "$ICONSET_DIR/icon_256x256@2x.png" >/dev/null
        sips -s format png -z 512 512 "$ICON_SRC" --out "$ICONSET_DIR/icon_512x512.png" >/dev/null
        sips -s format png -z 1024 1024 "$ICON_SRC" --out "$ICONSET_DIR/icon_512x512@2x.png" >/dev/null
        iconutil -c icns "$ICONSET_DIR" -o "$ICON_DST"
        rm -rf "$ICONSET_DIR"
    else
        warn "⚠️  Icon source not found: $ICON_SRC"
    fi

    cat > "$PLIST_DST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDisplayName</key>
    <string>🧠 Codex Now</string>
    <key>CFBundleName</key>
    <string>🧠 Codex Now</string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_ID</string>
    <key>CFBundleVersion</key>
    <string>$VERSION</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CFBundleExecutable</key>
    <string>CodexNowLauncher</string>
    <key>CFBundleIconFile</key>
    <string>CodexNow</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.13</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>CFBundleDocumentTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Viewer</string>
            <key>LSItemContentTypes</key>
            <array>
                <string>public.folder</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
PLIST

    plutil -lint "$PLIST_DST" >/dev/null
    success "✅ Built: $APP_DIR"
}

install_app() {
    info "📦 Installing to $INSTALL_DIR/$APP_NAME..."
    rm -rf "$INSTALL_DIR/$APP_NAME"
    cp -R "$APP_DIR" "$INSTALL_DIR/"
    xattr -dr com.apple.quarantine "$INSTALL_DIR/$APP_NAME" 2>/dev/null || true
    success "✅ Installed: $INSTALL_DIR/$APP_NAME"
}

show_done() {
    echo ""
    success "🎉 Codex Now installed successfully."
    echo ""
    echo "Usage:"
    echo "  1. Open Finder in a project folder."
    echo "  2. Launch /Applications/Codex Now.app."
    echo "  3. It opens your terminal and runs: codex $CODEX_ARGS"
    echo ""
    echo "Tips:"
    echo "  • Drag Codex Now.app to the Dock for one-click launch."
    echo "  • Command-drag it to Finder toolbar for folder-context launching."
    echo "  • Last directory is saved in ~/.codex-now-last-dir."
}

check_system
build_app
install_app
show_done
