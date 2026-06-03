#!/usr/bin/env bash

set -e

APP_NAME="Auto-Yt-Dlp"
INSTALL_DIR="$HOME/Applications/AutoScripts-Mori"
SCRIPT_NAME="auto-dlp.sh"
RAW_URL="https://raw.githubusercontent.com/shirushimori/Auto-Yt-Dlp/refs/heads/main/linux-mac/auto-dlp.sh"

echo "Installing $APP_NAME..."

# Check curl

if ! command -v curl >/dev/null 2>&1; then
echo "curl is not installed."

```
if command -v apt >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y curl
elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --noconfirm curl
elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y curl
elif command -v brew >/dev/null 2>&1; then
    brew install curl
else
    echo "Please install curl manually."
    exit 1
fi
```

fi

mkdir -p "$INSTALL_DIR"

curl -L "$RAW_URL" -o "$INSTALL_DIR/$SCRIPT_NAME"

chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Desktop shortcut

DESKTOP_FILE="$HOME/.local/share/applications/auto-ytdlp.desktop"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Auto Yt-Dlp
Exec=$INSTALL_DIR/$SCRIPT_NAME
Terminal=true
Categories=Utility;
EOF

chmod +x "$DESKTOP_FILE"

# Desktop icon

if [ -d "$HOME/Desktop" ]; then
cp "$DESKTOP_FILE" "$HOME/Desktop/Auto-Yt-Dlp.desktop" || true
chmod +x "$HOME/Desktop/Auto-Yt-Dlp.desktop" || true
fi

echo
echo "Installed to:"
echo "$INSTALL_DIR/$SCRIPT_NAME"
echo
echo "Start Menu and Desktop shortcuts created."
