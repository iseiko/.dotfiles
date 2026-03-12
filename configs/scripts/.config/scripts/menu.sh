#!/bin/bash

## Define the menu options and associated commands
chosen=$(printf "Logout\\nShutdown\\nReboot\\nSuspend" | rofi -dmenu -i -p "System" -width 10 -lines 4)

case "$chosen" in
"Logout") hyprctl dispatch exit ;;
"Shutdown") systemctl poweroff ;;
"Reboot") systemctl reboot ;;
"Suspend") systemctl suspend ;;
esac
