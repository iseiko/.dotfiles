#!/bin/bash

# --- CONFIGURATION ---
WALLPAPERS_DIR="/home/hollow/.dotfiles/wallpapers/Pictures/wallpapers/"
WALLPAPER_CACHE="$HOME/.cache/current_wallpaper.jpg"
APPLY_COLORS_SCRIPT="$HOME/.config/scripts/apply_colors.sh"


# --- Transition options --- #

TRANSITION_TYPE="fade"
TRANSITION_STEP=180
TRANSITION_FPS=180

# --- FUNCTIONS --- #

get_current_wallpaper_index() {
  CURRENT_WALLPAPER=$(swww query | grep "image" | awk '{print $NF}' | tr -d '"')
  for i in "${!WALLPAPERS[@]}"; do
    if [[ "${WALLPAPERS[$i]}" == "$CURRENT_WALLPAPER" ]]; then
      echo "$i"
      return
    fi
  done
  echo "-1"
}

convert_and_sync() {
    local source_path="$1"
    local target_path="$WALLPAPER_CACHE"
    echo "Converting $source_path and synchronizing cache..."
    mkdir -p "$(dirname "$target_path")"
    if ! command -v convert &> /dev/null; then
        echo "🚨 ERROR: ImageMagick 'convert' command not found. Please install ImageMagick."
        exit 1
    fi
    convert "$source_path" -quality 90 "$target_path"
    if [ $? -ne 0 ]; then
        echo "🚨 ERROR: ImageMagick failed to convert $source_path."
        exit 1
    fi
    echo "Cache synchronized to: $target_path"
}

# --- MAIN EXECUTION --- #

WALLPAPERS=($(find "$WALLPAPERS_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \)))
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
  echo "Error: No wallpapers found in $WALLPAPERS_DIR"
  exit 1
fi

CURRENT_INDEX=$(get_current_wallpaper_index)
if [ "$CURRENT_INDEX" -eq -1 ]; then
  CURRENT_INDEX=0
fi
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#WALLPAPERS[@]} ))

NEXT_WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

convert_and_sync "$NEXT_WALLPAPER"

swww img "$NEXT_WALLPAPER" \
  --transition-type "$TRANSITION_TYPE" \
  --transition-step "$TRANSITION_STEP" \
  --transition-fps "$TRANSITION_FPS" 
echo "Wallpaper changed to: $NEXT_WALLPAPER"

/bin/bash "$APPLY_COLORS_SCRIPT"

echo "Theming complete."