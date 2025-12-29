#!/bin/bash
# Color Picker - Pick a color from anywhere on screen
# Uses slop for selection and imagemagick for color extraction

SCRIPTS_DIR="$HOME/.config/scripts"
source "$SCRIPTS_DIR/lib/notify.sh"

# Check dependencies
check_deps() {
    local missing=()
    command -v maim &>/dev/null || missing+=("maim")
    command -v convert &>/dev/null || missing+=("imagemagick")
    command -v slop &>/dev/null || missing+=("slop")
    
    if [ ${#missing[@]} -gt 0 ]; then
        notify_error "Color Picker" "Missing dependencies: ${missing[*]}"
        exit 1
    fi
}

# Pick color from screen
pick_color() {
    local mode="$1"
    local tmpfile="/tmp/colorpicker-$$.png"
    
    case "$mode" in
        "pixel")
            # Single pixel selection
            notify_info "Color Picker" "Click anywhere to pick a color"
            local coords=$(slop -t 0 -f "%x %y" 2>/dev/null)
            if [ -z "$coords" ]; then
                exit 0
            fi
            local x=$(echo "$coords" | cut -d' ' -f1)
            local y=$(echo "$coords" | cut -d' ' -f2)
            maim -g 1x1+$x+$y "$tmpfile" 2>/dev/null
            ;;
        "area")
            # Average color of selected area
            notify_info "Color Picker" "Select an area to get average color"
            maim -s "$tmpfile" 2>/dev/null
            ;;
    esac
    
    if [ ! -f "$tmpfile" ]; then
        exit 0
    fi
    
    # Extract color
    local hex=$(convert "$tmpfile" -resize 1x1 txt:- | grep -oP '#[0-9A-Fa-f]{6}' | head -1)
    rm -f "$tmpfile"
    
    if [ -z "$hex" ]; then
        notify_error "Color Picker" "Failed to extract color"
        exit 1
    fi
    
    # Convert to RGB
    local r=$((16#${hex:1:2}))
    local g=$((16#${hex:3:2}))
    local b=$((16#${hex:5:2}))
    local rgb="rgb($r, $g, $b)"
    
    # Convert to HSL (approximate)
    local max=$(( r > g ? (r > b ? r : b) : (g > b ? g : b) ))
    local min=$(( r < g ? (r < b ? r : b) : (g < b ? g : b) ))
    local l=$(( (max + min) * 50 / 255 ))
    
    echo "$hex"
}

# Copy color to clipboard
copy_color() {
    local color="$1"
    local format="$2"
    
    echo -n "$color" | xclip -selection clipboard
    notify_success "Color Picker" "$color\nCopied to clipboard ($format)"
}

# Main menu
main() {
    check_deps
    
    local options="🎯 Pick pixel color\n📦 Average from area\n📋 From clipboard"
    local choice=$(echo -e "$options" | rofi -dmenu -p "Color Picker" -theme snow)
    
    case "$choice" in
        "🎯 Pick pixel color")
            local hex=$(pick_color "pixel")
            if [ -n "$hex" ]; then
                show_color_menu "$hex"
            fi
            ;;
        "📦 Average from area")
            local hex=$(pick_color "area")
            if [ -n "$hex" ]; then
                show_color_menu "$hex"
            fi
            ;;
        "📋 From clipboard")
            local clip=$(xclip -selection clipboard -o 2>/dev/null)
            if [[ "$clip" =~ ^#[0-9A-Fa-f]{6}$ ]]; then
                show_color_menu "$clip"
            else
                notify_error "Color Picker" "Clipboard doesn't contain a valid hex color"
            fi
            ;;
        *)
            exit 0
            ;;
    esac
}

# Show format selection menu
show_color_menu() {
    local hex="$1"
    local hex_upper=$(echo "$hex" | tr '[:lower:]' '[:upper:]')
    local hex_lower=$(echo "$hex" | tr '[:upper:]' '[:lower:]')
    
    # Convert to RGB
    local r=$((16#${hex:1:2}))
    local g=$((16#${hex:3:2}))
    local b=$((16#${hex:5:2}))
    local rgb="rgb($r, $g, $b)"
    
    local options="$hex_upper (HEX uppercase)\n$hex_lower (HEX lowercase)\n$rgb (RGB)\n$r, $g, $b (RGB values)"
    local choice=$(echo -e "$options" | rofi -dmenu -p "Copy format" -theme snow)
    
    case "$choice" in
        *"HEX uppercase"*)
            copy_color "$hex_upper" "HEX"
            ;;
        *"HEX lowercase"*)
            copy_color "$hex_lower" "HEX"
            ;;
        *"(RGB)"*)
            copy_color "$rgb" "RGB"
            ;;
        *"RGB values"*)
            copy_color "$r, $g, $b" "RGB values"
            ;;
        *)
            exit 0
            ;;
    esac
}

main "$@"
