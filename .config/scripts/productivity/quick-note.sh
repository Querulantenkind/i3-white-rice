#!/bin/bash
# Quick note taking with rofi
# Appends notes to daily journal file in ~/notes/

SCRIPTS_DIR="$HOME/.config/scripts"
source "$SCRIPTS_DIR/lib/notify.sh"

NOTES_DIR="$HOME/notes"
mkdir -p "$NOTES_DIR"

# Get today's journal file
get_journal_file() {
    echo "$NOTES_DIR/$(date +%Y-%m-%d).md"
}

# Add note to journal
add_note() {
    local note="$1"
    local journal=$(get_journal_file)
    local timestamp=$(date +%H:%M)
    
    # Create file with header if it doesn't exist
    if [ ! -f "$journal" ]; then
        echo "# Journal - $(date +%Y-%m-%d)" > "$journal"
        echo "" >> "$journal"
    fi
    
    # Append note with timestamp
    echo "- **$timestamp** $note" >> "$journal"
    
    notify_success "Quick Note" "Note saved to journal"
}

# View today's notes
view_notes() {
    local journal=$(get_journal_file)
    
    if [ -f "$journal" ]; then
        kitty -e bat --paging=always "$journal"
    else
        notify_info "Quick Note" "No notes for today yet"
    fi
}

# Main
main() {
    local options="Add new note\nView today's notes\nOpen notes folder"
    local choice=$(echo -e "$options" | rofi -dmenu -p "Notes" -theme snow)
    
    case "$choice" in
        "Add new note")
            local note=$(rofi -dmenu -p "Note" -theme snow -lines 0)
            if [ -n "$note" ]; then
                add_note "$note"
            fi
            ;;
        "View today's notes")
            view_notes
            ;;
        "Open notes folder")
            thunar "$NOTES_DIR" &
            ;;
        *)
            exit 0
            ;;
    esac
}

main "$@"
