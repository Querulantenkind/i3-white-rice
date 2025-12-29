# ❄️ Snow White Powerlevel10k Configuration
# Pure black-on-white with red accents
# Generated for i3-white-rice

# Temporarily disable instant prompt during configuration
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Unset all configuration options
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Zsh >= 5.1 is required
  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

  # ─────────────────────────────────────────────────────────────
  # Prompt Layout
  # ─────────────────────────────────────────────────────────────
  
  # Left prompt segments
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon                 # OS identifier
    dir                     # Current directory
    vcs                     # Git status
    command_execution_time  # Duration of last command
    status                  # Exit code
  )

  # Right prompt segments
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    dunst_notifications     # Custom: Unread notifications
    i3_workspace            # Custom: i3 workspace number
    vi_mode                 # Vi mode indicator
    background_jobs         # Background jobs indicator
    time                    # Current time
  )

  # ─────────────────────────────────────────────────────────────
  # Global Styling - Black on White with Red Accents
  # ─────────────────────────────────────────────────────────────
  
  # Basic prompt settings
  typeset -g POWERLEVEL9K_MODE=nerdfont-v3
  typeset -g POWERLEVEL9K_ICON_PADDING=moderate
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
  
  # Segment separators - red accents
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=' '
  
  # Segment spacing
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_FIRST_SEGMENT_END_SYMBOL='%{%}'
  typeset -g POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%{%}'

  # Transient prompt - minimal after command execution
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

  # Prompt character (shown after transient)
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  
  # ─────────────────────────────────────────────────────────────
  # OS Icon
  # ─────────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=0
  typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=7
  typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='❄️'

  # ─────────────────────────────────────────────────────────────
  # Directory
  # ─────────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=0
  typeset -g POWERLEVEL9K_DIR_BACKGROUND=7
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=8
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=0
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER='(.git|.svn|.hg|package.json|Cargo.toml|go.mod)'
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=40
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3
  typeset -g POWERLEVEL9K_DIR_NOT_WRITABLE_FOREGROUND=1
  
  # Special directory icons
  typeset -g POWERLEVEL9K_DIR_CLASSES=(
    '~/code(|/*)'  CODE     ''
    '~'            HOME     ''
    '*'            DEFAULT  ''
  )

  # ─────────────────────────────────────────────────────────────
  # Git/VCS Status
  # ─────────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=0
  typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=7
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=1
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=7
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=1
  typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=7
  
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=' '
  typeset -g POWERLEVEL9K_VCS_COMMIT_ICON='@'
  
  # Git status icons with red accents
  typeset -g POWERLEVEL9K_VCS_STAGED_ICON='+'
  typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON='!'
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_ICON='✖'
  typeset -g POWERLEVEL9K_VCS_STASH_ICON='≡'
  
  # Show these git status features
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1

  # ─────────────────────────────────────────────────────────────
  # Command Execution Time
  # ─────────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=7
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION='⏱'

  # ─────────────────────────────────────────────────────────────
  # Exit Status
  # ─────────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=0
  typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND=7
  typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✔'
  
  # Error status - dark red for distinction
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=0
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=1
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✖'
  
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=0
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_BACKGROUND=1
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION='✖'
  
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=0
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_BACKGROUND=1
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION='✖'

  # ─────────────────────────────────────────────────────────────
  # Vi Mode Indicator
  # ─────────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_VI_MODE_FOREGROUND=0
  typeset -g POWERLEVEL9K_VI_MODE_BACKGROUND=7
  typeset -g POWERLEVEL9K_VI_INSERT_MODE_STRING=''
  typeset -g POWERLEVEL9K_VI_COMMAND_MODE_STRING='N'
  typeset -g POWERLEVEL9K_VI_VISUAL_MODE_STRING='V'
  typeset -g POWERLEVEL9K_VI_OVERWRITE_MODE_STRING='R'

  # ─────────────────────────────────────────────────────────────
  # Background Jobs
  # ─────────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=0
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=7
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='⚙'

  # ─────────────────────────────────────────────────────────────
  # Time
  # ─────────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=0
  typeset -g POWERLEVEL9K_TIME_BACKGROUND=7
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false
  typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=''

  # ─────────────────────────────────────────────────────────────
  # Custom Segment: Dunst Notifications (Cached)
  # ─────────────────────────────────────────────────────────────
  function prompt_dunst_notifications() {
    local cache_file="/tmp/p10k_dunst_cache_$$"
    local cache_duration=2
    local count
    
    # Check if dunstctl is available
    command -v dunstctl &>/dev/null || return
    
    # Use cache if valid
    if [[ -f "$cache_file" ]]; then
      local cache_age=$(($(date +%s) - $(stat -c %Y "$cache_file" 2>/dev/null || echo 0)))
      if [[ $cache_age -lt $cache_duration ]]; then
        count=$(cat "$cache_file")
      fi
    fi
    
    # Refresh cache if needed
    if [[ -z "$count" ]]; then
      count=$(dunstctl count waiting 2>/dev/null || echo 0)
      echo "$count" > "$cache_file" 2>/dev/null
    fi
    
    # Only show if there are notifications
    [[ "$count" -gt 0 ]] && p10k segment -f 1 -b 7 -i '🔔' -t "$count"
  }
  
  typeset -g POWERLEVEL9K_DUNST_NOTIFICATIONS_FOREGROUND=1
  typeset -g POWERLEVEL9K_DUNST_NOTIFICATIONS_BACKGROUND=7

  # ─────────────────────────────────────────────────────────────
  # Custom Segment: i3 Workspace (Cached)
  # ─────────────────────────────────────────────────────────────
  function prompt_i3_workspace() {
    local cache_file="/tmp/p10k_i3_cache_$$"
    local cache_duration=2
    local workspace
    
    # Check if i3-msg is available
    command -v i3-msg &>/dev/null || return
    
    # Use cache if valid
    if [[ -f "$cache_file" ]]; then
      local cache_age=$(($(date +%s) - $(stat -c %Y "$cache_file" 2>/dev/null || echo 0)))
      if [[ $cache_age -lt $cache_duration ]]; then
        workspace=$(cat "$cache_file")
      fi
    fi
    
    # Refresh cache if needed
    if [[ -z "$workspace" ]]; then
      if command -v jq &>/dev/null; then
        workspace=$(i3-msg -t get_workspaces 2>/dev/null | jq -r '.[] | select(.focused==true).num')
      else
        workspace=$(i3-msg -t get_workspaces 2>/dev/null | grep -oP '"num":\s*\K\d+(?=.*"focused":\s*true)')
      fi
      echo "$workspace" > "$cache_file" 2>/dev/null
    fi
    
    # Show workspace number
    [[ -n "$workspace" ]] && p10k segment -f 0 -b 7 -i '' -t "$workspace"
  }
  
  typeset -g POWERLEVEL9K_I3_WORKSPACE_FOREGROUND=0
  typeset -g POWERLEVEL9K_I3_WORKSPACE_BACKGROUND=7

  # ─────────────────────────────────────────────────────────────
  # Transient Prompt Configuration
  # ─────────────────────────────────────────────────────────────
  
  # What to show in transient prompt (minimal)
  function p10k-on-pre-prompt() {
    p10k display '1'=show
  }
  
  function p10k-on-post-prompt() {
    p10k display '1'=hide
  }

  # Instant prompt mode
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

  # ─────────────────────────────────────────────────────────────
  # Hot Reload
  # ─────────────────────────────────────────────────────────────
  
  # Reload when .p10k.zsh changes
  (( ! $+functions[p10k] )) || p10k reload
}

# Cleanup temporary options
(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
