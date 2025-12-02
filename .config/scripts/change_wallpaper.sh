#!/bin/bash

# Path to your wallpaper directory
WALLPAPERS_DIR="/home/hollow/.dotfiles/wallpapers/Pictures/wallpapers/"

# Transition options (optional, but nice)
TRANSITION_TYPE="fade"
TRANSITION_STEP=180
TRANSITION_FPS=180
TRANSITION_DURATION=1

# Get a list of all image files in the directory
WALLPAPERS=($(find "$WALLPAPERS_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \)))

# Check if the directory is empty
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
  echo "Error: No wallpapers found in $WALLPAPERS_DIR"
  exit 1
fi

# Function to get the current wallpaper and its index
get_current_wallpaper_index() {
  CURRENT_WALLPAPER=$(swww query | grep "image" | awk '{print $NF}')
  for i in "${!WALLPAPERS[@]}"; do
    if [[ "${WALLPAPERS[$i]}" == "$CURRENT_WALLPAPER" ]]; then
      echo "$i"
      return
    fi
  done
  echo "-1"
}

# Get the initial index or start at 0
CURRENT_INDEX=$(get_current_wallpaper_index)
if [ "$CURRENT_INDEX" -eq -1 ]; then
  CURRENT_INDEX=0
fi

# Increment the index and loop back to the start if it reaches the end
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#WALLPAPERS[@]} ))

# Get the next wallpaper file
NEXT_WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

# Set the new wallpaper with swww
swww img "$NEXT_WALLPAPER" \
  --transition-type "$TRANSITION_TYPE" \
  --transition-step "$TRANSITION_STEP" \
  --transition-fps 180
echo "Wallpaper changed to: $NEXT_WALLPAPER"
