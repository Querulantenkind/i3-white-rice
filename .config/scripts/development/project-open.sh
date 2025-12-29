#!/bin/bash
# Project opener - finds git repos in ~/code/ and opens in editor
# Recursively searches for .git directories

SCRIPTS_DIR="$HOME/.config/scripts"
source "$SCRIPTS_DIR/lib/notify.sh"

CODE_DIR="$HOME/code"
EDITOR="nvim"
TERMINAL="kitty"

# Find all git repositories
get_projects() {
    if [ ! -d "$CODE_DIR" ]; then
        return
    fi
    
    # Find all .git directories and get their parent folders
    find "$CODE_DIR" -type d -name ".git" 2>/dev/null | while read -r git_dir; do
        local project_dir=$(dirname "$git_dir")
        # Get relative path from CODE_DIR
        local rel_path="${project_dir#$CODE_DIR/}"
        echo "$rel_path"
    done | sort
}

# Open project in terminal with editor
open_project() {
    local project="$1"
    local full_path="$CODE_DIR/$project"
    
    if [ ! -d "$full_path" ]; then
        notify_error "Project Open" "Directory not found: $full_path"
        exit 1
    fi
    
    # Open terminal in project directory with editor
    $TERMINAL -d "$full_path" -e $EDITOR . &
    
    notify_success "Project Open" "Opened: $project"
}

# Main menu
main() {
    if [ ! -d "$CODE_DIR" ]; then
        notify_warning "Project Open" "Code directory not found: $CODE_DIR\nCreate it first!"
        exit 1
    fi
    
    local projects=$(get_projects)
    
    if [ -z "$projects" ]; then
        notify_info "Project Open" "No git repositories found in $CODE_DIR"
        exit 0
    fi
    
    local choice=$(echo "$projects" | rofi -dmenu -p "Project" -theme snow -i)
    
    if [ -n "$choice" ]; then
        open_project "$choice"
    fi
}

main "$@"
