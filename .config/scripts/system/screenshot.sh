#!/bin/bash
# Screenshot tool with multiple modes
# Uses maim for capturing and xclip for clipboard

SCRIPTS_DIR="$HOME/.config/scripts"
source "$SCRIPTS_DIR/lib/notify.sh"

# Screenshot directory
SCREENSHOT_DIR="$HOME/media/screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Generate filename with timestamp
get_filename() {
    echo "$SCREENSHOT_DIR/screenshot-$(date +%Y-%m-%d-%H-%M-%S).png"
}

# Take screenshot and copy to clipboard
take_screenshot() {
    local mode="$1"
    local filename=$(get_filename)
    
    case "$mode" in
        "area")
            # Select area
            maim -s "$filename" 2>/dev/null
            ;;
        "window")
            # Current window
            maim -i $(xdotool getactivewindow) "$filename" 2>/dev/null
            ;;
        "full")
            # Full screen
            maim "$filename" 2>/dev/null
            ;;
    esac
    
    # Check if screenshot was taken
    if [ -f "$filename" ]; then
        # Copy to clipboard
        xclip -selection clipboard -t image/png -i "$filename"
        notify_success "Screenshot" "Saved to $filename\nCopied to clipboard"
    else
        notify_error "Screenshot" "Failed to capture screenshot"
        exit 1
    fi
}

# Main menu
main() {
    local options="Area selection\nActive window\nFull screen"
    local choice=$(echo -e "$options" | rofi -dmenu -p "Screenshot" -theme snow)
    
    case "$choice" in
        "Area selection")
            take_screenshot "area"
            ;;
        "Active window")
            take_screenshot "window"
            ;;
        "Full screen")
            take_screenshot "full"
            ;;
        *)
            exit 0
            ;;
    esac
}

main "$@"
