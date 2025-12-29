#!/bin/bash
# Script Launcher for Snow White i3 Rice
# Scans categorized scripts and presents them in a rofi menu
# Accessible via polybar click or $mod+r keybinding

set -e

# Directories
SCRIPTS_DIR="$HOME/.config/scripts"
CATEGORIES=("system" "media" "productivity" "development")

# Source notification helpers
source "$SCRIPTS_DIR/lib/notify.sh"

# Build the menu entries
build_menu() {
    for category in "${CATEGORIES[@]}"; do
        local category_dir="$SCRIPTS_DIR/$category"
        
        if [ -d "$category_dir" ]; then
            # Find all executable .sh files
            while IFS= read -r -d '' script; do
                # Get just the filename without extension
                local script_name=$(basename "$script" .sh)
                # Capitalize category name
                local category_upper=$(echo "$category" | sed 's/.*/\u&/')
                echo "[$category_upper] $script_name"
            done < <(find "$category_dir" -maxdepth 1 -type f -executable -name "*.sh" -print0 | sort -z)
        fi
    done
}

# Get the full path for a selected script
get_script_path() {
    local selection="$1"
    
    # Parse the selection: [Category] script-name
    local category=$(echo "$selection" | sed 's/\[\([^]]*\)\].*/\1/' | tr '[:upper:]' '[:lower:]')
    local script_name=$(echo "$selection" | sed 's/\[[^]]*\] //')
    
    echo "$SCRIPTS_DIR/$category/$script_name.sh"
}

# Main
main() {
    # Build menu and show in rofi
    local menu=$(build_menu)
    
    if [ -z "$menu" ]; then
        notify_error "Script Launcher" "No executable scripts found in $SCRIPTS_DIR"
        exit 1
    fi
    
    # Show rofi menu
    local selection=$(echo "$menu" | rofi -dmenu -p "Scripts" -theme snow)
    
    # Exit if nothing selected (user pressed Escape)
    if [ -z "$selection" ]; then
        exit 0
    fi
    
    # Get the script path
    local script_path=$(get_script_path "$selection")
    
    # Check if script exists and is executable
    if [ ! -f "$script_path" ]; then
        notify_error "Script Launcher" "Script not found: $script_path"
        exit 1
    fi
    
    if [ ! -x "$script_path" ]; then
        notify_error "Script Launcher" "Script not executable: $script_path\nRun: chmod +x $script_path"
        exit 1
    fi
    
    # Execute the script
    exec "$script_path"
}

main "$@"
