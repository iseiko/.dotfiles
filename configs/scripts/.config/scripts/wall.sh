#!/bin/bash

WALL_DIR="$HOME/Pictures/Wallpapers/"
PAPERD_CONF="$HOME/.config/wpaperd/config.toml"
WINDOW_CONF="$HOME/.config/rofi/wall.rasi"

SELECTION=$(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) -exec sh -c 'echo -en "$(basename {})\\0icon\\x1fthumbnail://{}\n"' \; | sort -f | rofi -dmenu -config "$WINDOW_CONF" -p "Select Wallpaper")
[ -z "$SELECTION" ] && exit
FULL_PATH="$WALL_DIR/$SELECTION"

convert $FULL_PATH ~/Pictures/.Current/current.png

pkill wpaperd
wpaperd &
notify-send "Wallpaper changed to $SELECTION"

# --- Logging Section ---

DB_PATH="$HOME/.local/share/wallpaper_logs.db"
mkdir -p "$(dirname "$DB_PATH")"
sqlite3 "$DB_PATH" "
CREATE TABLE IF NOT EXISTS wallpaper_changes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    changed_at DATETIME,
    wallpaper_path TEXT
);" >/dev/null
sqlite3 "$DB_PATH" "
INSERT INTO wallpaper_changes (changed_at, wallpaper_path)
VALUES (datetime('now'), '$(echo "$FULL_PATH" | sed "s/'/''/g")');"
