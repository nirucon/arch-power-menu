#!/usr/bin/env bash
# rofi-power-menu.sh: Robust Rofi-based power menu for DWM with SDDM

set -euo pipefail
IFS=$'\n\t'
LOG_TAG="rofi-power-menu"

# Ensure required commands are available
for cmd in rofi systemctl logger loginctl; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: $cmd is not installed." >&2
        exit 1
    fi
done

# Define menu options
options=(
    "Logout"
    "Suspend"
    "Reboot"
    "Shutdown"
)

# Show menu in Rofi
total=${#options[@]}
choice=$(printf '%s\n' "${options[@]}" | rofi \
    -dmenu \
    -p "Power Menu" \
    -mesg "Session actions" \
    -i \
    -lines "$total"
)

# Log the selection for debugging
logger -t "$LOG_TAG" "User selected: $choice"

# Confirmation helper for destructive actions
action_confirm() {
    local answer
    answer=$(printf '%s\n' "No" "Yes" | rofi \
        -dmenu \
        -p "Är du säker?" \
        -i \
        -lines 2
    )
    [[ "$answer" == "Yes" ]]
}

# Handle the selected option
case "$choice" in
    Logout)
        # Terminate current session via loginctl or fallback to killing DWM
        if [[ -n "${XDG_SESSION_ID-}" ]]; then
            loginctl terminate-session "$XDG_SESSION_ID"
        else
            pkill dwm
        fi
        ;;

    Suspend)
        action_confirm && systemctl suspend || exit 0
        ;;

    Reboot)
        action_confirm && systemctl reboot
        ;;

    Shutdown)
        action_confirm && systemctl poweroff
        ;;

    *)
        # No or invalid choice: do nothing
        exit 0
        ;;
esac
