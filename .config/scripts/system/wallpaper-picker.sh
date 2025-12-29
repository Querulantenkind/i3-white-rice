#!/bin/bash
# Wallpaper Picker - Browse and set wallpapers
# Uses feh for setting wallpaper and rofi for selection

SCRIPTS_DIR="$HOME/.config/scripts"
source "$SCRIPTS_DIR/lib/notify.sh"

# Wallpaper directories to search
WALLPAPER_DIRS=(
    "$HOME/.config/wallpapers"
    "$HOME/Pictures/wallpapers"
    "$HOME/media/wallpapers"
    "/usr/share/backgrounds"
)

# Supported image extensions
EXTENSIONS="jpg|jpeg|png|webp|bmp"

# Current wallpaper file (feh stores this)
CURRENT_WALLPAPER="$HOME/.fehbg"

# Find all wallpapers
find_wallpapers() {
    for dir in "${WALLPAPER_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            /usr/bin/find "$dir" -type f -regextype posix-extended \
                -iregex ".*\.($EXTENSIONS)$" 2>/dev/null
        fi
    done | sort
}

# Get wallpaper display name
get_display_name() {
    local path="$1"
    local filename=$(basename "$path")
    local dir=$(dirname "$path")
    local dirname=$(basename "$dir")
    
    # Show folder/filename for clarity
    echo "[$dirname] $filename"
}

# Set wallpaper
set_wallpaper() {
    local wallpaper="$1"
    local mode="$2"
    
    case "$mode" in
        "fill")
            feh --bg-fill "$wallpaper"
            ;;
        "fit")
            feh --bg-max "$wallpaper"
            ;;
        "center")
            feh --bg-center "$wallpaper"
            ;;
        "tile")
            feh --bg-tile "$wallpaper"
            ;;
        "stretch")
            feh --bg-scale "$wallpaper"
            ;;
    esac
    
    notify_success "Wallpaper" "Set: $(basename "$wallpaper")\nMode: $mode"
}

# Preview wallpaper (temporary)
preview_wallpaper() {
    local wallpaper="$1"
    feh --bg-fill "$wallpaper"
}

# Restore previous wallpaper
restore_wallpaper() {
    if [ -f "$CURRENT_WALLPAPER" ]; then
        bash "$CURRENT_WALLPAPER"
    fi
}

# Select wallpaper mode
select_mode() {
    local wallpaper="$1"
    
    local options="Fill (cover screen)\nFit (maintain aspect)\nCenter (original size)\nTile (repeat)\nStretch (ignore aspect)"
    local choice=$(echo -e "$options" | rofi -dmenu -p "Mode" -theme snow)
    
    case "$choice" in
        "Fill"*)
            set_wallpaper "$wallpaper" "fill"
            ;;
        "Fit"*)
            set_wallpaper "$wallpaper" "fit"
            ;;
        "Center"*)
            set_wallpaper "$wallpaper" "center"
            ;;
        "Tile"*)
            set_wallpaper "$wallpaper" "tile"
            ;;
        "Stretch"*)
            set_wallpaper "$wallpaper" "stretch"
            ;;
        *)
            exit 0
            ;;
    esac
}

# Create solid color wallpaper
solid_color_wallpaper() {
    local color=$(rofi -dmenu -p "Enter color (hex)" -theme snow)
    
    if [ -z "$color" ]; then
        exit 0
    fi
    
    # Ensure # prefix
    [[ "$color" != \#* ]] && color="#$color"
    
    # Validate hex color
    if [[ ! "$color" =~ ^#[0-9A-Fa-f]{6}$ ]]; then
        notify_error "Wallpaper" "Invalid hex color: $color"
        exit 1
    fi
    
    local tmpfile="/tmp/solid-wallpaper-$$.png"
    convert -size 1920x1080 "xc:$color" "$tmpfile"
    
    if [ -f "$tmpfile" ]; then
        feh --bg-fill "$tmpfile"
        notify_success "Wallpaper" "Set solid color: $color"
    else
        notify_error "Wallpaper" "Failed to create solid color wallpaper"
    fi
}

# Random wallpaper
random_wallpaper() {
    local wallpapers=($(find_wallpapers))
    
    if [ ${#wallpapers[@]} -eq 0 ]; then
        notify_error "Wallpaper" "No wallpapers found"
        exit 1
    fi
    
    local random_index=$((RANDOM % ${#wallpapers[@]}))
    local wallpaper="${wallpapers[$random_index]}"
    
    set_wallpaper "$wallpaper" "fill"
}

# Main menu
main() {
    # Build wallpaper list
    local wallpapers=($(find_wallpapers))
    
    # Build menu
    local menu="🎲 Random wallpaper\n🎨 Solid color\n───────────────"
    
    for wp in "${wallpapers[@]}"; do
        menu+="\n$(get_display_name "$wp")|$wp"
    done
    
    # Show menu (display name only)
    local choice=$(echo -e "$menu" | cut -d'|' -f1 | rofi -dmenu -p "Wallpaper" -theme snow)
    
    case "$choice" in
        "🎲 Random wallpaper")
            random_wallpaper
            ;;
        "🎨 Solid color")
            solid_color_wallpaper
            ;;
        "───────────────")
            exit 0
            ;;
        "")
            exit 0
            ;;
        *)
            # Find the matching wallpaper path
            local selected_wp=""
            for wp in "${wallpapers[@]}"; do
                if [ "$(get_display_name "$wp")" = "$choice" ]; then
                    selected_wp="$wp"
                    break
                fi
            done
            
            if [ -n "$selected_wp" ]; then
                select_mode "$selected_wp"
            fi
            ;;
    esac
}

main "$@"
