#!/bin/bash
# Power Menu - Shutdown, Reboot, Suspend, Logout, Lock
# Provides a rofi menu for common power actions

SCRIPTS_DIR="$HOME/.config/scripts"
source "$SCRIPTS_DIR/lib/notify.sh"

# Lock command (i3lock with snow white theme)
lock_screen() {
    i3lock -c ffffff \
        --inside-color=ffffff \
        --ring-color=000000 \
        --line-uses-ring \
        --keyhl-color=000000 \
        --bshl-color=000000 \
        --separator-color=000000 \
        --insidever-color=ffffff \
        --ringver-color=000000 \
        --insidewrong-color=ffffff \
        --ringwrong-color=000000
}

# Confirm action with rofi
confirm_action() {
    local action="$1"
    local confirm=$(echo -e "Yes\nNo" | rofi -dmenu -p "Really $action?" -theme snow)
    [ "$confirm" = "Yes" ]
}

# Main menu
main() {
    local options=" Lock\n Logout\n⏸ Suspend\n Reboot\n⏻ Shutdown"
    local choice=$(echo -e "$options" | rofi -dmenu -p "Power" -theme snow)

    case "$choice" in
        " Lock")
            lock_screen
            ;;
        " Logout")
            if confirm_action "logout"; then
                notify_info "Power" "Logging out..."
                i3-msg exit
            fi
            ;;
        "⏸ Suspend")
            if confirm_action "suspend"; then
                notify_info "Power" "Suspending..."
                lock_screen
                systemctl suspend
            fi
            ;;
        " Reboot")
            if confirm_action "reboot"; then
                notify_info "Power" "Rebooting..."
                systemctl reboot
            fi
            ;;
        "⏻ Shutdown")
            if confirm_action "shutdown"; then
                notify_info "Power" "Shutting down..."
                systemctl poweroff
            fi
            ;;
        *)
            exit 0
            ;;
    esac
}

main "$@"
