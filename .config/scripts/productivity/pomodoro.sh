#!/bin/bash
# Pomodoro timer with notification
# 25 minute focus session with critical notification at end

SCRIPTS_DIR="$HOME/.config/scripts"
source "$SCRIPTS_DIR/lib/notify.sh"

PID_FILE="/tmp/pomodoro.pid"
DURATION=1500  # 25 minutes in seconds

# Check if timer is running
is_running() {
    [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null
}

# Start pomodoro timer
start_timer() {
    if is_running; then
        notify_warning "Pomodoro" "Timer already running!\nUse 'Stop timer' to cancel"
        return
    fi
    
    # Run timer in background
    (
        sleep $DURATION
        rm -f "$PID_FILE"
        dunstify -u critical -t 0 -i appointment-soon "🍅 Pomodoro Complete!" "25 minutes have passed.\nTime for a break!"
        # Play sound if available
        paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null || true
    ) &
    
    echo $! > "$PID_FILE"
    notify_success "Pomodoro" "Timer started!\n25 minutes of focus time"
}

# Stop pomodoro timer
stop_timer() {
    if is_running; then
        kill "$(cat "$PID_FILE")" 2>/dev/null
        rm -f "$PID_FILE"
        notify_info "Pomodoro" "Timer cancelled"
    else
        notify_warning "Pomodoro" "No timer running"
    fi
}

# Get remaining time
get_remaining() {
    if is_running; then
        local pid=$(cat "$PID_FILE")
        local start_time=$(ps -o lstart= -p "$pid" 2>/dev/null)
        if [ -n "$start_time" ]; then
            local start_epoch=$(date -d "$start_time" +%s 2>/dev/null)
            local now_epoch=$(date +%s)
            local elapsed=$((now_epoch - start_epoch))
            local remaining=$((DURATION - elapsed))
            
            if [ $remaining -gt 0 ]; then
                local mins=$((remaining / 60))
                local secs=$((remaining % 60))
                echo "${mins}m ${secs}s remaining"
            else
                echo "Finishing..."
            fi
        fi
    else
        echo "No timer running"
    fi
}

# Main menu
main() {
    local options=""
    
    if is_running; then
        local remaining=$(get_remaining)
        options="Stop timer\nStatus: $remaining"
    else
        options="Start 25 min timer"
    fi
    
    local choice=$(echo -e "$options" | rofi -dmenu -p "Pomodoro" -theme snow)
    
    case "$choice" in
        "Start 25 min timer")
            start_timer
            ;;
        "Stop timer")
            stop_timer
            ;;
        "Status:"*)
            notify_info "Pomodoro" "$(get_remaining)"
            ;;
        *)
            exit 0
            ;;
    esac
}

main "$@"
