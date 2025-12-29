#!/bin/bash
# Screen recorder toggle using ffmpeg
# Records to ~/media/recordings/ with timestamp filename

SCRIPTS_DIR="$HOME/.config/scripts"
source "$SCRIPTS_DIR/lib/notify.sh"

# Directories and files
RECORDING_DIR="$HOME/media/recordings"
PID_FILE="/tmp/screen-recording.pid"
OUTPUT_FILE=""

mkdir -p "$RECORDING_DIR"

# Check if recording is in progress
is_recording() {
    [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null
}

# Start recording
start_recording() {
    local mode="$1"
    local filename="$RECORDING_DIR/recording-$(date +%Y-%m-%d-%H-%M-%S).mp4"
    
    case "$mode" in
        "fullscreen")
            # Get screen resolution
            local resolution=$(xdpyinfo | grep dimensions | awk '{print $2}')
            ffmpeg -f x11grab -framerate 30 -video_size "$resolution" -i :0.0 \
                   -c:v libx264 -preset ultrafast -crf 23 \
                   "$filename" &>/dev/null &
            ;;
        "area")
            # Use slop to select area
            local geometry=$(slop -f "%x %y %w %h")
            if [ -z "$geometry" ]; then
                exit 0
            fi
            local x=$(echo "$geometry" | awk '{print $1}')
            local y=$(echo "$geometry" | awk '{print $2}')
            local w=$(echo "$geometry" | awk '{print $3}')
            local h=$(echo "$geometry" | awk '{print $4}')
            
            ffmpeg -f x11grab -framerate 30 -video_size "${w}x${h}" -i ":0.0+${x},${y}" \
                   -c:v libx264 -preset ultrafast -crf 23 \
                   "$filename" &>/dev/null &
            ;;
        "with-audio")
            local resolution=$(xdpyinfo | grep dimensions | awk '{print $2}')
            ffmpeg -f x11grab -framerate 30 -video_size "$resolution" -i :0.0 \
                   -f pulse -i default \
                   -c:v libx264 -preset ultrafast -crf 23 \
                   -c:a aac -b:a 128k \
                   "$filename" &>/dev/null &
            ;;
    esac
    
    local pid=$!
    echo "$pid" > "$PID_FILE"
    echo "$filename" > /tmp/screen-recording-file.txt
    
    notify_success "Screen Recording" "Recording started\n$filename"
}

# Stop recording
stop_recording() {
    if is_recording; then
        local pid=$(cat "$PID_FILE")
        kill -INT "$pid" 2>/dev/null
        
        # Wait for ffmpeg to finish
        sleep 1
        
        local filename=$(cat /tmp/screen-recording-file.txt 2>/dev/null || echo "recording")
        
        rm -f "$PID_FILE" /tmp/screen-recording-file.txt
        
        notify_success "Screen Recording" "Recording saved\n$filename"
    else
        notify_warning "Screen Recording" "No recording in progress"
    fi
}

# Main menu
main() {
    if is_recording; then
        # If recording, offer to stop
        local choice=$(echo -e "Stop recording\nCancel" | rofi -dmenu -p "Recording" -theme snow)
        
        if [ "$choice" = "Stop recording" ]; then
            stop_recording
        fi
    else
        # Offer recording options
        local options="Full screen\nSelect area\nFull screen with audio"
        local choice=$(echo -e "$options" | rofi -dmenu -p "Record" -theme snow)
        
        case "$choice" in
            "Full screen")
                start_recording "fullscreen"
                ;;
            "Select area")
                start_recording "area"
                ;;
            "Full screen with audio")
                start_recording "with-audio"
                ;;
            *)
                exit 0
                ;;
        esac
    fi
}

main "$@"
