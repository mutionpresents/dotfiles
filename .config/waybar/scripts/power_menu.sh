#!/bin/bash

# Power menu script for Waybar with Hyprland
# Save this as ~/.config/waybar/scripts/power_menu.sh

# Define options
options="🔒 Lock\n💤 Sleep\n🔄 Restart\n    Shutdown"

# Show menu with rofi
choice=$(echo -e "$options" | rofi -dmenu \
    -p "Power Menu" \
    -show-icons \
    -icon-theme Papirus \
    -theme ~/.config/rofi/config.rasi)

# Execute based on choice
case $choice in
    "🔒 Lock")
        hyprlock
        ;;
    "💤 Sleep")
        systemctl suspend
        ;;
    "🔄 Restart")
        systemctl reboot
        ;;
    "    Shutdown")
        systemctl poweroff
        ;;
esac
