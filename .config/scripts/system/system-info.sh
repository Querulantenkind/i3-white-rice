#!/bin/bash
# System information display
# Shows hardware stats via dunst notification

SCRIPTS_DIR="$HOME/.config/scripts"
source "$SCRIPTS_DIR/lib/notify.sh"

# Gather system information
get_system_info() {
    # CPU info
    local cpu_model=$(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2 | sed 's/^ //')
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d. -f1)
    
    # Memory info
    local mem_total=$(free -h | awk '/^Mem:/ {print $2}')
    local mem_used=$(free -h | awk '/^Mem:/ {print $3}')
    local mem_percent=$(free | awk '/^Mem:/ {printf "%.0f", $3/$2 * 100}')
    
    # Disk info
    local disk_total=$(df -h / | awk 'NR==2 {print $2}')
    local disk_used=$(df -h / | awk 'NR==2 {print $3}')
    local disk_percent=$(df / | awk 'NR==2 {print $5}')
    
    # Uptime
    local uptime=$(uptime -p | sed 's/up //')
    
    # Kernel
    local kernel=$(uname -r)
    
    # Build message
    local message=""
    message+="CPU: ${cpu_model}\n"
    message+="CPU Usage: ${cpu_usage}%\n"
    message+="\n"
    message+="Memory: ${mem_used} / ${mem_total} (${mem_percent}%)\n"
    message+="Disk: ${disk_used} / ${disk_total} (${disk_percent})\n"
    message+="\n"
    message+="Kernel: ${kernel}\n"
    message+="Uptime: ${uptime}"
    
    echo -e "$message"
}

# Main
main() {
    local hostname=$(hostname)
    local info=$(get_system_info)
    
    # Use notify with longer timeout for system info
    dunstify -u low -t 10000 -i computer "System Info: $hostname" "$info"
}

main "$@"
