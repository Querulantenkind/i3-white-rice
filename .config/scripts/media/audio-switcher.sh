#!/bin/bash
# Audio output switcher using PulseAudio/PipeWire
# Lists available sinks and switches default output

SCRIPTS_DIR="$HOME/.config/scripts"
source "$SCRIPTS_DIR/lib/notify.sh"

# Get list of audio sinks with friendly names
get_sinks() {
    pactl list sinks short | while read -r line; do
        local sink_id=$(echo "$line" | awk '{print $1}')
        local sink_name=$(echo "$line" | awk '{print $2}')
        
        # Get the description (friendly name)
        local description=$(pactl list sinks | grep -A 20 "Sink #$sink_id" | grep "Description:" | cut -d: -f2 | sed 's/^ //')
        
        if [ -n "$description" ]; then
            echo "$sink_id: $description"
        else
            echo "$sink_id: $sink_name"
        fi
    done
}

# Get current default sink
get_default_sink() {
    pactl get-default-sink
}

# Set default sink and move all streams to it
set_sink() {
    local sink_id="$1"
    local sink_name=$(pactl list sinks short | awk -v id="$sink_id" '$1 == id {print $2}')
    
    # Set as default
    pactl set-default-sink "$sink_name"
    
    # Move all existing streams to new sink
    pactl list sink-inputs short | while read -r line; do
        local input_id=$(echo "$line" | awk '{print $1}')
        pactl move-sink-input "$input_id" "$sink_name" 2>/dev/null
    done
}

# Main menu
main() {
    local sinks=$(get_sinks)
    
    if [ -z "$sinks" ]; then
        notify_error "Audio Switcher" "No audio outputs found"
        exit 1
    fi
    
    local choice=$(echo "$sinks" | rofi -dmenu -p "Audio Output" -theme snow)
    
    if [ -z "$choice" ]; then
        exit 0
    fi
    
    # Extract sink ID from choice
    local sink_id=$(echo "$choice" | cut -d: -f1)
    local sink_desc=$(echo "$choice" | cut -d: -f2 | sed 's/^ //')
    
    set_sink "$sink_id"
    notify_success "Audio Output" "Switched to:\n$sink_desc"
}

main "$@"
