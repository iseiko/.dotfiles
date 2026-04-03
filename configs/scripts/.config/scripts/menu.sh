#!/bin/bash

# System-matched colors
BG="#282828"
FG="#ebdbb2"
BORDER="#504945"  # Matches your window borders
ACCENT="#fe8019"  # Gruvbox Orange
SELECTED="#3c3836"

# Define the options with icons
# Format: "Icon  Name"
options="󰈆  Logout\n󰐥  Shutdown\n󰜉  Reboot\n󰤄  Suspend\n󰒲  Hibernate"

# Run Rofi with the icon-enabled theme
chosen=$(printf "$options" | rofi -dmenu -i -p "󰐥 System" \
-theme-str "
window {
    width: 300px;
    height: 450px; 
    border: 2px;
    border-color: $FG;
    background-color: $BG;
    padding: 15px;
}
mainbox {
    children: [ inputbar, listview ];
    background-color: transparent;
}
inputbar {
    children: [ prompt ];
    background-color: transparent;
    margin: 0 0 10px 0;
}
prompt {
    text-color: $FG;
    background-color: transparent;
    font: 'Iosevka Nerd Font Bold 12';
}
listview {
    fixed-height: true;
    lines: 5;
    scrollbar: false;
    background-color: transparent;
}
element {
    padding: 10px;
    border-radius: 4px;
    background-color: transparent;
    text-color: $FG;
}
element selected {
    background-color: $SELECTED;
    text-color: $ACCENT;
}
element-text {
    background-color: transparent;
    text-color: inherit;
    vertical-align: 0.5;
    font: 'Iosevka Nerd Font 12';
}
")

# The case statement ignores the icons for the logic check
case "$chosen" in
    *"Logout"*) hyprctl dispatch exit ;;
    *"Shutdown"*) systemctl poweroff ;;
    *"Reboot"*) systemctl reboot ;;
    *"Suspend"*) systemctl suspend ;;
    *"Hibernate"*) systemctl hibernate ;;
esac