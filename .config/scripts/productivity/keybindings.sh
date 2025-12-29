#!/bin/bash
# i3 keybindings cheatsheet
# Parses i3 config and displays bindings in rofi

SCRIPTS_DIR="$HOME/.config/scripts"
source "$SCRIPTS_DIR/lib/notify.sh"

I3_CONFIG="$HOME/.config/i3/config"

# Parse keybindings from i3 config
get_keybindings() {
    if [ ! -f "$I3_CONFIG" ]; then
        notify_error "Keybindings" "i3 config not found: $I3_CONFIG"
        exit 1
    fi
    
    # Extract bindsym lines and format them nicely
    grep "^bindsym" "$I3_CONFIG" | while read -r line; do
        # Remove 'bindsym ' prefix
        local binding=$(echo "$line" | sed 's/^bindsym //')
        
        # Split into key and command
        local key=$(echo "$binding" | awk '{print $1}')
        local cmd=$(echo "$binding" | cut -d' ' -f2-)
        
        # Clean up the command (remove exec --no-startup-id, etc.)
        cmd=$(echo "$cmd" | sed 's/exec --no-startup-id //')
        cmd=$(echo "$cmd" | sed 's/exec //')
        
        # Replace $mod with Super
        key=$(echo "$key" | sed 's/\$mod/Super/g')
        key=$(echo "$key" | sed 's/Mod1/Alt/g')
        key=$(echo "$key" | sed 's/Control/Ctrl/g')
        key=$(echo "$key" | sed 's/+/ + /g')
        
        # Truncate long commands
        if [ ${#cmd} -gt 50 ]; then
            cmd="${cmd:0:47}..."
        fi
        
        printf "%-30s  →  %s\n" "$key" "$cmd"
    done
}

# Group bindings by category
get_categorized_bindings() {
    echo "=== WINDOW MANAGEMENT ==="
    get_keybindings | grep -E "(kill|floating|fullscreen|focus|move|resize|split|layout)" | head -20
    
    echo ""
    echo "=== WORKSPACES ==="
    get_keybindings | grep -E "workspace" | head -15
    
    echo ""
    echo "=== APPLICATIONS ==="
    get_keybindings | grep -E "(Return|rofi|browser|thunar|btop|nvim|tdrop)" | head -10
    
    echo ""
    echo "=== MEDIA & SYSTEM ==="
    get_keybindings | grep -E "(XF86|bright|volume|Audio|player|redshift)" | head -10
    
    echo ""
    echo "=== OTHER ==="
    get_keybindings | grep -vE "(kill|floating|fullscreen|focus|move|resize|split|layout|workspace|Return|rofi|browser|thunar|btop|nvim|XF86|bright|volume|Audio|player|redshift|tdrop)" | head -10
}

# Main
main() {
    local bindings=$(get_keybindings)
    
    if [ -z "$bindings" ]; then
        notify_error "Keybindings" "No keybindings found"
        exit 1
    fi
    
    # Show in rofi (just for viewing, no action on selection)
    echo "$bindings" | rofi -dmenu -p "Keybindings" -theme snow -i
}

main "$@"
