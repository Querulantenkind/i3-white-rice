#!/bin/bash
# Media player control using playerctl
# Shows current track info and control options

SCRIPTS_DIR="$HOME/.config/scripts"
source "$SCRIPTS_DIR/lib/notify.sh"

# Check if playerctl is available and a player is running
check_player() {
    if ! command -v playerctl &> /dev/null; then
        notify_error "Player Control" "playerctl is not installed"
        exit 1
    fi
    
    if ! playerctl status &> /dev/null; then
        notify_warning "Player Control" "No media player detected"
        exit 1
    fi
}

# Get current track info
get_track_info() {
    local artist=$(playerctl metadata artist 2>/dev/null || echo "Unknown")
    local title=$(playerctl metadata title 2>/dev/null || echo "Unknown")
    local album=$(playerctl metadata album 2>/dev/null || echo "")
    
    if [ -n "$album" ]; then
        echo "$artist - $title\n$album"
    else
        echo "$artist - $title"
    fi
}

# Show now playing notification
show_now_playing() {
    local status=$(playerctl status 2>/dev/null)
    local info=$(get_track_info)
    
    dunstify -u low -t 3000 -i audio-x-generic "Now Playing ($status)" "$info"
}

# Execute player action
player_action() {
    local action="$1"
    
    case "$action" in
        "play-pause")
            playerctl play-pause
            sleep 0.2
            show_now_playing
            ;;
        "next")
            playerctl next
            sleep 0.5
            show_now_playing
            ;;
        "previous")
            playerctl previous
            sleep 0.5
            show_now_playing
            ;;
        "stop")
            playerctl stop
            notify_info "Player Control" "Playback stopped"
            ;;
        "info")
            show_now_playing
            ;;
    esac
}

# Main menu
main() {
    check_player
    
    local status=$(playerctl status 2>/dev/null)
    local play_text="Play"
    [ "$status" = "Playing" ] && play_text="Pause"
    
    local options="$play_text\nNext track\nPrevious track\nStop\nNow playing info"
    local choice=$(echo -e "$options" | rofi -dmenu -p "Player" -theme snow)
    
    case "$choice" in
        "Play"|"Pause")
            player_action "play-pause"
            ;;
        "Next track")
            player_action "next"
            ;;
        "Previous track")
            player_action "previous"
            ;;
        "Stop")
            player_action "stop"
            ;;
        "Now playing info")
            player_action "info"
            ;;
        *)
            exit 0
            ;;
    esac
}

main "$@"
