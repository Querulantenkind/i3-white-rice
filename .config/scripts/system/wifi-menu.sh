#!/bin/bash
# WiFi Menu - Scan and connect to wireless networks
# Uses nmcli for network management

SCRIPTS_DIR="$HOME/.config/scripts"
source "$SCRIPTS_DIR/lib/notify.sh"

# Get current connection
get_current_connection() {
    nmcli -t -f NAME connection show --active | head -n1
}

# Scan for networks
scan_networks() {
    # Trigger a rescan
    nmcli device wifi rescan 2>/dev/null
    sleep 1
    
    # Get list of networks: SSID, SIGNAL, SECURITY
    nmcli -t -f SSID,SIGNAL,SECURITY device wifi list | \
        grep -v "^--" | \
        sort -t: -k2 -rn | \
        uniq | \
        while IFS=: read -r ssid signal security; do
            [ -z "$ssid" ] && continue
            # Format: signal icon + SSID + security indicator
            if [ "$signal" -ge 75 ]; then
                icon="▂▄▆█"
            elif [ "$signal" -ge 50 ]; then
                icon="▂▄▆_"
            elif [ "$signal" -ge 25 ]; then
                icon="▂▄__"
            else
                icon="▂___"
            fi
            
            # Security indicator
            if [ -n "$security" ] && [ "$security" != "--" ]; then
                lock="🔒"
            else
                lock="  "
            fi
            
            echo "$icon $lock $ssid"
        done
}

# Connect to network
connect_to_network() {
    local ssid="$1"
    
    # Check if we already have a saved connection
    if nmcli connection show "$ssid" &>/dev/null; then
        notify_info "WiFi" "Connecting to $ssid..."
        if nmcli connection up "$ssid" &>/dev/null; then
            notify_success "WiFi" "Connected to $ssid"
        else
            notify_error "WiFi" "Failed to connect to $ssid"
        fi
    else
        # Need password
        local password=$(rofi -dmenu -p "Password for $ssid" -password -theme snow)
        
        if [ -z "$password" ]; then
            exit 0
        fi
        
        notify_info "WiFi" "Connecting to $ssid..."
        if nmcli device wifi connect "$ssid" password "$password" &>/dev/null; then
            notify_success "WiFi" "Connected to $ssid"
        else
            notify_error "WiFi" "Failed to connect to $ssid\nCheck password"
        fi
    fi
}

# Disconnect
disconnect() {
    local current=$(get_current_connection)
    if [ -n "$current" ]; then
        nmcli connection down "$current" &>/dev/null
        notify_info "WiFi" "Disconnected from $current"
    fi
}

# Toggle WiFi
toggle_wifi() {
    local status=$(nmcli radio wifi)
    if [ "$status" = "enabled" ]; then
        nmcli radio wifi off
        notify_info "WiFi" "WiFi disabled"
    else
        nmcli radio wifi on
        notify_info "WiFi" "WiFi enabled"
    fi
}

# Main menu
main() {
    local current=$(get_current_connection)
    local wifi_status=$(nmcli radio wifi)
    
    # Build menu
    local menu=""
    
    if [ "$wifi_status" = "enabled" ]; then
        menu="🔄 Scan networks\n"
        
        if [ -n "$current" ]; then
            menu+="❌ Disconnect ($current)\n"
        fi
        
        menu+="📴 Disable WiFi\n"
        menu+="───────────────\n"
        menu+=$(scan_networks)
    else
        menu="📶 Enable WiFi"
    fi
    
    local choice=$(echo -e "$menu" | rofi -dmenu -p "WiFi" -theme snow)
    
    case "$choice" in
        "🔄 Scan networks")
            main  # Refresh
            ;;
        "❌ Disconnect"*)
            disconnect
            ;;
        "📴 Disable WiFi")
            toggle_wifi
            ;;
        "📶 Enable WiFi")
            toggle_wifi
            sleep 2
            main  # Refresh after enabling
            ;;
        "───────────────")
            exit 0
            ;;
        "")
            exit 0
            ;;
        *)
            # Extract SSID (remove signal bars and lock icon)
            local ssid=$(echo "$choice" | sed 's/^[▂▄▆█_]* [🔒 ]* //')
            if [ -n "$ssid" ]; then
                connect_to_network "$ssid"
            fi
            ;;
    esac
}

main "$@"
