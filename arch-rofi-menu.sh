#!/bin/bash

# Rofi menu for dwm logout and system actions
options="Logout\nRestart dwm\nSuspend\nReboot\nShutdown"

# Launch Rofi with the options
choice=$(echo -e "$options" | rofi -dmenu -p "Power Menu" -i)

# Handle the selected option
case "$choice" in
    "Logout")
        # Terminate dwm (assuming dwm is run in a way that exiting it logs out)
        pkill dwm
        ;;
    "Suspend")
        # Suspend the system using systemd
        systemctl suspend
        ;;
    "Reboot")
        # Reboot the system
        systemctl reboot
        ;;
    "Shutdown")
        # Power off the system
        systemctl poweroff
        ;;
    *)
        # Exit if no valid option is selected
        exit 1
        ;;
esac
