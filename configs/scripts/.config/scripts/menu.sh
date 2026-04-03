#!/bin/bash

chosen=$(printf "Logout\\nShutdown\\nReboot\\nSuspend\\nHibernate" | rofi -dmenu -i -p "System" -width 5 -lines 4)

case "$chosen" in
"Logout") hyprctl dispatch exit ;;
"Shutdown") systemctl poweroff ;;
"Reboot") systemctl reboot ;;
"Suspend") systemctl suspend ;;
"Hibernate") systemctl hibernate ;;
esac
