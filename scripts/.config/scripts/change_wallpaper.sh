#!/bin/bash

# --- CONFIGURATION ---
# Path to your wallpaper directory
WALLPAPERS_DIR="/home/hollow/.dotfiles/wallpapers/Pictures/wallpapers/"

# Path for the synchronized, converted cache file (used by hyprlock, pywal, etc.)
WALLPAPER_CACHE="$HOME/.cache/current_wallpaper.jpg"

# Path to the color application script
APPLY_COLORS_SCRIPT="$HOME/.config/scripts/apply_colors.sh"

# Transition options
TRANSITION_TYPE="fade"
TRANSITION_STEP=180
TRANSITION_FPS=180

# --- FUNCTIONS ---

# Function to get the current wallpaper index
get_current_wallpaper_index() {
  # We query the currently displayed image path from swww and strip surrounding quotes
  CURRENT_WALLPAPER=$(swww query | grep "image" | awk '{print $NF}' | tr -d '"')
  
  # Search for this path in the list of available wallpapers
  for i in "${!WALLPAPERS[@]}"; do
    if [[ "${WALLPAPERS[$i]}" == "$CURRENT_WALLPAPER" ]]; then
      echo "$i"
      return
    fi
  done
  echo "-1"
}

# Function to convert and synchronize the image
convert_and_sync() {
    local source_path="$1"
    local target_path="$WALLPAPER_CACHE"
    
    echo "Converting $source_path and synchronizing cache..."
    
    # Ensure the cache directory exists
    mkdir -p "$(dirname "$target_path")"
    
    # Use ImageMagick 'convert' to transform the source image into a JPEG
    # The -quality 90 flag ensures good image quality.
    if ! command -v convert &> /dev/null; then
        echo "🚨 ERROR: ImageMagick 'convert' command not found. Please install ImageMagick."
        exit 1
    fi

    # Convert the source to the target JPEG cache file
    convert "$source_path" -quality 90 "$target_path"
    
    if [ $? -ne 0 ]; then
        echo "🚨 ERROR: ImageMagick failed to convert $source_path."
        exit 1
    fi
    echo "Cache synchronized to: $target_path"
}

# --- MAIN EXECUTION ---

# Get a list of all supported image files in the directory
WALLPAPERS=($(find "$WALLPAPERS_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \)))

# Check if the directory is empty
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
  echo "Error: No wallpapers found in $WALLPAPERS_DIR"
  exit 1
fi

# Determine the index of the next wallpaper
CURRENT_INDEX=$(get_current_wallpaper_index)
if [ "$CURRENT_INDEX" -eq -1 ]; then
  CURRENT_INDEX=0
fi

NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#WALLPAPERS[@]} ))
NEXT_WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

# 1. Convert and synchronize the next wallpaper file
convert_and_sync "$NEXT_WALLPAPER"

# 2. Set the new wallpaper with swww
# CRITICAL: We tell swww to set the ORIGINAL image path, NOT the converted cache path. 
# This preserves the original file for the next iteration of the cycling script.
swww img "$NEXT_WALLPAPER" \
  --transition-type "$TRANSITION_TYPE" \
  --transition-step "$TRANSITION_STEP" \
  --transition-fps "$TRANSITION_FPS" 
echo "Wallpaper changed to: $NEXT_WALLPAPER"

# 3. Call the color application script
/bin/bash "$APPLY_COLORS_SCRIPT"

echo "Theming complete."