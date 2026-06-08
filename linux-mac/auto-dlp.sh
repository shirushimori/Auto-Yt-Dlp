#!/bin/bash

set -e

echo "|=================================|"
echo "|          Auto YT-DLP            |"
echo "|=================================|"

# Install yt-dlp if missing
if ! command -v yt-dlp >/dev/null 2>&1; then
    echo "yt-dlp not found."

    if command -v apt >/dev/null 2>&1; then
        sudo apt update
        sudo apt install -y yt-dlp
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm yt-dlp
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y yt-dlp
    else
        echo "Unsupported package manager."
        exit 1
    fi
fi

# Install ffmpeg if missing
if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "ffmpeg not found."

    if command -v apt >/dev/null 2>&1; then
        sudo apt install -y ffmpeg
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm ffmpeg
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y ffmpeg
    fi
fi

echo
read -p "Enter Video/Playlist URL: " URL

echo
echo "1) Video"
echo "2) Audio"
read -p "Choose: " MODE

echo
echo "Save Location:"
echo "1) Default (~/Videos/yt-dlp)"
echo "2) Custom Folder"
read -p "Choose: " SAVECHOICE

DEFAULT_DIR="$HOME/Videos/yt-dlp"

if [ "$SAVECHOICE" = "1" ]; then
    SAVE_DIR="$DEFAULT_DIR"
else
    if command -v zenity >/dev/null 2>&1; then
        SAVE_DIR=$(zenity --file-selection --directory --title="Select Download Folder")
    elif command -v kdialog >/dev/null 2>&1; then
        SAVE_DIR=$(kdialog --getexistingdirectory)
    else
        read -p "Enter folder path: " SAVE_DIR
    fi
fi

mkdir -p "$SAVE_DIR"

echo
read -p "Create playlist subfolder? (y/n): " PLAYLIST_FOLDER

if [[ "$PLAYLIST_FOLDER" =~ ^[Yy]$ ]]; then
    read -p "Subfolder name: " SUBFOLDER
    SAVE_DIR="$SAVE_DIR/$SUBFOLDER"
    mkdir -p "$SAVE_DIR"
    PLAYLIST_OPT="--yes-playlist"
else
    PLAYLIST_OPT="--no-playlist"
fi

echo
read -p "Embed metadata? (y/n): " META

if [[ "$META" =~ ^[Yy]$ ]]; then
    META_OPT="--embed-metadata"
else
    META_OPT=""
fi

if [ "$MODE" = "1" ]; then

    echo
    echo "Video Quality:"
    echo "1) 480p"
    echo "2) 720p"
    echo "3) 1080p"
    echo "4) 1440p"
    echo "5) 2160p (4K)"
    read -p "Choose: " VQ

    case $VQ in
        1) HEIGHT=480 ;;
        2) HEIGHT=720 ;;
        3) HEIGHT=1080 ;;
        4) HEIGHT=1440 ;;
        5) HEIGHT=2160 ;;
        *) HEIGHT=1080 ;;
    esac

    echo
    echo "Audio Quality:"
    echo "1) Best"
    echo "2) Medium"
    echo "3) Low"
    read -p "Choose: " AQ

    case $AQ in
        1) AUDIO="bestaudio" ;;
        2) AUDIO="bestaudio[abr<=128]" ;;
        3) AUDIO="bestaudio[abr<=64]" ;;
        *) AUDIO="bestaudio" ;;
    esac

    OUTPUT="$SAVE_DIR/%(title)s.%(ext)s"

    yt-dlp \
        $PLAYLIST_OPT \
        $META_OPT \
        --newline \
        --progress \
        --console-title \
        -f "bestvideo[height<=${HEIGHT}]+${AUDIO}/best[height<=${HEIGHT}]" \
        -o "$OUTPUT" \
        "$URL"

else

    echo
    echo "Audio Format:"
    echo "1) mp3"
    echo "2) m4a"
    echo "3) opus"
    echo "4) webm"
    read -p "Choose: " FORMAT

    case $FORMAT in
        1) EXT="mp3" ;;
        2) EXT="m4a" ;;
        3) EXT="opus" ;;
        4) EXT="webm" ;;
        *) EXT="mp3" ;;
    esac

    echo
    echo "Audio Quality:"
    echo "1) 320k"
    echo "2) 192k"
    echo "3) 128k"
    echo "4) 64k"
    read -p "Choose: " AQ

    case $AQ in
        1) QUALITY=320 ;;
        2) QUALITY=192 ;;
        3) QUALITY=128 ;;
        4) QUALITY=64 ;;
        *) QUALITY=192 ;;
    esac

    OUTPUT="$SAVE_DIR/%(title)s.%(ext)s"

    yt-dlp \
        $PLAYLIST_OPT \
        $META_OPT \
        --newline \
        --progress \
        --console-title \
        -x \
        --audio-format "$EXT" \
        --audio-quality "${QUALITY}K" \
        -o "$OUTPUT" \
        "$URL"
fi

echo
echo "Download completed."
