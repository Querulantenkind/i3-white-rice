#!/bin/bash
# Notification helper functions for Snow White rice scripts
# Uses dunstify for consistent notifications with proper urgency levels

# Get the directory where this script is located
SCRIPT_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Info notification (low urgency, 2 second timeout)
# Usage: notify_info "Title" "Message"
notify_info() {
    local title="${1:-Info}"
    local message="${2:-}"
    dunstify -u low -t 2000 -i dialog-information "$title" "$message"
}

# Success notification (normal urgency, 4 second timeout)
# Usage: notify_success "Title" "Message"
notify_success() {
    local title="${1:-Success}"
    local message="${2:-}"
    dunstify -u normal -t 4000 -i emblem-default "$title" "$message"
}

# Error notification (critical urgency, no timeout - must be dismissed)
# Usage: notify_error "Title" "Message"
notify_error() {
    local title="${1:-Error}"
    local message="${2:-}"
    dunstify -u critical -t 0 -i dialog-error "$title" "$message"
}

# Warning notification (normal urgency, 5 second timeout)
# Usage: notify_warning "Title" "Message"
notify_warning() {
    local title="${1:-Warning}"
    local message="${2:-}"
    dunstify -u normal -t 5000 -i dialog-warning "$title" "$message"
}
