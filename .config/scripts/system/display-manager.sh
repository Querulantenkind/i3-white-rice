#!/bin/bash
# Display manager for multi-monitor setups
# Uses xrandr for display configuration

SCRIPTS_DIR="$HOME/.config/scripts"
source "$SCRIPTS_DIR/lib/notify.sh"

# Get list of connected monitors
get_monitors() {
    xrandr --query | grep " connected" | cut -d" " -f1
}

# Common display configurations
configure_display() {
    local mode="$1"
    local monitors=($(get_monitors))
    local primary="${monitors[0]}"
    local secondary="${monitors[1]:-}"
    
    case "$mode" in
        "single")
            # Only primary monitor
            if [ -n "$secondary" ]; then
                xrandr --output "$primary" --auto --primary --output "$secondary" --off
            else
                xrandr --output "$primary" --auto --primary
            fi
            notify_success "Display" "Single monitor: $primary"
            ;;
        "extend-right")
            # Extend to the right
            if [ -n "$secondary" ]; then
                xrandr --output "$primary" --auto --primary --output "$secondary" --auto --right-of "$primary"
                notify_success "Display" "Extended right: $primary + $secondary"
            else
                notify_warning "Display" "No secondary monitor detected"
            fi
            ;;
        "extend-left")
            # Extend to the left
            if [ -n "$secondary" ]; then
                xrandr --output "$primary" --auto --primary --output "$secondary" --auto --left-of "$primary"
                notify_success "Display" "Extended left: $secondary + $primary"
            else
                notify_warning "Display" "No secondary monitor detected"
            fi
            ;;
        "mirror")
            # Mirror displays
            if [ -n "$secondary" ]; then
                xrandr --output "$primary" --auto --primary --output "$secondary" --auto --same-as "$primary"
                notify_success "Display" "Mirrored: $primary = $secondary"
            else
                notify_warning "Display" "No secondary monitor detected"
            fi
            ;;
        "external-only")
            # Only external monitor
            if [ -n "$secondary" ]; then
                xrandr --output "$primary" --off --output "$secondary" --auto --primary
                notify_success "Display" "External only: $secondary"
            else
                notify_warning "Display" "No external monitor detected"
            fi
            ;;
    esac
    
    # Reload wallpaper after display change
    feh --bg-fill ~/.config/wallpapers/snow-white.png 2>/dev/null &
}

# Main menu
main() {
    local monitors=($(get_monitors))
    local monitor_count=${#monitors[@]}
    
    local options="Single monitor (${monitors[0]})"
    
    if [ "$monitor_count" -gt 1 ]; then
        options="$options\nExtend right\nExtend left\nMirror displays\nExternal only (${monitors[1]})"
    fi
    
    local choice=$(echo -e "$options" | rofi -dmenu -p "Display" -theme snow)
    
    case "$choice" in
        "Single monitor"*)
            configure_display "single"
            ;;
        "Extend right")
            configure_display "extend-right"
            ;;
        "Extend left")
            configure_display "extend-left"
            ;;
        "Mirror displays")
            configure_display "mirror"
            ;;
        "External only"*)
            configure_display "external-only"
            ;;
        *)
            exit 0
            ;;
    esac
}

main "$@"
