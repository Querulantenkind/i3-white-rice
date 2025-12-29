# ❄️ Snow White Zsh Configuration
# Pure black-on-white with red accents

# Powerlevel10k Configuration
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Powerlevel10k Instant Prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Powerlevel10k Theme
source ~/powerlevel10k/powerlevel10k.zsh-theme

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY

# Directory Navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Extended Shell Options
setopt EXTENDED_GLOB
setopt CORRECT
setopt CORRECT_ALL
setopt NO_BEEP
setopt INTERACTIVE_COMMENTS

# Completion System
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.cache/zsh/completion

# Plugins
# zsh-autosuggestions (Arch package)
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# zsh-syntax-highlighting (Arch package) - Must be last
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    
    # Two-tone red accent highlighting (light red for syntax, dark red for errors)
    # Commands - black bold
    ZSH_HIGHLIGHT_STYLES[default]='fg=black'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=black,bold'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=black,bold'
    ZSH_HIGHLIGHT_STYLES[function]='fg=black,bold'
    ZSH_HIGHLIGHT_STYLES[command]='fg=black,bold'
    ZSH_HIGHLIGHT_STYLES[arg0]='fg=black,bold'
    
    # Errors - dark red (#8B0000)
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#8B0000,bold'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#8B0000,bold'
    
    # Red accents - bright red for syntax elements
    ZSH_HIGHLIGHT_STYLES[precommand]='fg=red,bold'
    ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=red,bold'
    ZSH_HIGHLIGHT_STYLES[redirection]='fg=red,bold'
    ZSH_HIGHLIGHT_STYLES[path]='fg=red'
    ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=red'
    ZSH_HIGHLIGHT_STYLES[globbing]='fg=red,bold'
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=red'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=red'
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=red'
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=red'
    ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=red,bold'
    ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=red'
    
    # Options - subtle grey
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#444444'
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#444444'
fi

# fzf - Fuzzy Finder
if command -v fzf &> /dev/null; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
    
    # fzf configuration with red accents
    export FZF_DEFAULT_OPTS="
        --height 40%
        --layout=reverse
        --border
        --inline-info
        --color=fg:#000000,bg:#ffffff,hl:#ff0000
        --color=fg+:#000000,bg+:#f0f0f0,hl+:#ff0000
        --color=info:#666666,prompt:#ff0000,pointer:#ff0000
        --color=marker:#ff0000,spinner:#666666,header:#666666
        --color=border:#ff0000
    "
    
    # Use fd instead of find
    if command -v fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi
fi

# zoxide - Smart cd
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# Aliases
# Modern replacements
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first'
alias lt='eza --tree --level=2 --icons'
alias lt3='eza --tree --level=3 --icons'
alias lt4='eza --tree --level=4 --icons'
alias tree='eza --tree --icons'
alias cat='bat --style=plain --paging=never'
alias grep='rg'
alias find='fd'

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gst='git stash'
alias gsp='git stash pop'
alias grb='git rebase'
alias grbi='git rebase -i'
alias lg='lazygit'

# System
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -p'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias size='du -sh * | sort -h'
alias ports='netstat -tulanp 2>/dev/null || ss -tulanp'
alias myip='curl -s ifconfig.me && echo'
alias temp='sensors 2>/dev/null || echo "Install lm_sensors"'
alias cpu='btop --utf-force'
alias mem='free -h && echo "" && ps aux --sort=-%mem | head -n 11'

# Package Management (Arch)
alias pacu='sudo pacman -Syu'
alias pacs='pacman -Ss'
alias paci='sudo pacman -S'
alias pacr='sudo pacman -Rns'
alias pacq='pacman -Q | wc -l'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null || echo "No orphans"'
alias yays='yay -Ss'
alias yayi='yay -S'

# Quick edit configs
alias zshrc='$EDITOR ~/.zshrc'
alias p10kcfg='$EDITOR ~/.p10k.zsh'
alias i3cfg='$EDITOR ~/.config/i3/config'
alias kittycfg='$EDITOR ~/.config/kitty/kitty.conf'
alias polycfg='$EDITOR ~/.config/polybar/config.ini'
alias roficfg='$EDITOR ~/.config/rofi/snow.rasi'
alias picomcfg='$EDITOR ~/.config/picom/picom.conf'
alias dunstcfg='$EDITOR ~/.config/dunst/dunstrc'

# Quick navigation
alias rice='cd ~/code/active/i3-white-rice'
alias code='cd ~/code'
alias dots='cd ~/.config'

# Screenshots (using maim)
alias ss='maim -s | xclip -selection clipboard -t image/png && echo "Screenshot copied!"'
alias ssf='maim | xclip -selection clipboard -t image/png && echo "Fullscreen copied!"'
alias sss='maim -s ~/media/screenshots/$(date +%Y%m%d-%H%M%S).png && echo "Screenshot saved!"'

# Clipboard
alias clip='xclip -selection clipboard'
alias clipo='xclip -selection clipboard -o'

# Reload configs
alias reload='source ~/.zshrc && echo "✓ zsh reloaded"'
alias i3reload='i3-msg reload && echo "✓ i3 reloaded"'
alias i3restart='i3-msg restart'
alias polyreload='polybar-msg cmd restart 2>/dev/null || pkill -USR1 polybar'

# Environment Variables
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LESS='-R'

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# ─────────────────────────────────────────────────────────────
# Hybrid Vim Mode (keeps standard shortcuts)
# ─────────────────────────────────────────────────────────────
bindkey -v
export KEYTIMEOUT=1

# Keep essential emacs/standard bindings in insert mode
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^K' kill-line
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^R' history-incremental-search-backward

# Arrow keys for history navigation (works in both modes)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -M viins '^[[A' up-line-or-beginning-search
bindkey -M viins '^[[B' down-line-or-beginning-search
bindkey -M vicmd '^[[A' up-line-or-beginning-search
bindkey -M vicmd '^[[B' down-line-or-beginning-search
bindkey -M viins '^[[C' forward-char
bindkey -M viins '^[[D' backward-char

# Ctrl+Left/Right for word navigation
bindkey -M viins '^[[1;5C' forward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M vicmd '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5D' backward-word

# Delete key
bindkey -M viins '^[[3~' delete-char
bindkey -M vicmd '^[[3~' delete-char
bindkey '^[[3;5~' kill-word

# Home/End keys
bindkey -M viins '^[[H' beginning-of-line
bindkey -M viins '^[[F' end-of-line
bindkey -M vicmd '^[[H' beginning-of-line
bindkey -M vicmd '^[[F' end-of-line

# Vim normal mode enhancements
bindkey -M vicmd 'H' beginning-of-line
bindkey -M vicmd 'L' end-of-line
bindkey -M vicmd 'k' up-line-or-beginning-search
bindkey -M vicmd 'j' down-line-or-beginning-search
bindkey -M vicmd 'u' undo
bindkey -M vicmd '^R' redo

# Edit command in $EDITOR with 'v' in normal mode
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# Yank to system clipboard
function vi-yank-xclip {
    zle vi-yank
    echo "$CUTBUFFER" | xclip -selection clipboard 2>/dev/null
}
zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip

# Visual cursor shape change (Block for normal, Beam for insert)
function zle-keymap-select zle-line-init {
    case $KEYMAP in
        vicmd)      echo -ne '\e[1 q' ;;  # Block cursor
        viins|main) echo -ne '\e[5 q' ;;  # Beam cursor
    esac
}
zle -N zle-keymap-select
zle -N zle-line-init

# Reset cursor on each new prompt
preexec() { echo -ne '\e[5 q' }

# ─────────────────────────────────────────────────────────────
# Functions
# ─────────────────────────────────────────────────────────────

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Quick find and edit
fe() {
    local file
    file=$(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}') && $EDITOR "$file"
}

# CD into directory with fzf
fcd() {
    local dir
    dir=$(fd --type d | fzf --preview 'eza --tree --level=1 --icons {}') && cd "$dir"
}

# Git checkout branch with fzf
fgb() {
    git branch | fzf | xargs git checkout
}

# Extract any archive type
extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"    ;;
            *.tar.gz)    tar xzf "$1"    ;;
            *.tar.xz)    tar xJf "$1"    ;;
            *.bz2)       bunzip2 "$1"    ;;
            *.rar)       unrar x "$1"    ;;
            *.gz)        gunzip "$1"     ;;
            *.tar)       tar xf "$1"     ;;
            *.tbz2)      tar xjf "$1"    ;;
            *.tgz)       tar xzf "$1"    ;;
            *.zip)       unzip "$1"      ;;
            *.Z)         uncompress "$1" ;;
            *.7z)        7z x "$1"       ;;
            *.zst)       unzstd "$1"     ;;
            *)           echo "Cannot extract '$1'" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Backup file with timestamp
backup() {
    if [[ -f "$1" ]]; then
        cp "$1" "$1.bak-$(date +%Y%m%d-%H%M%S)"
        echo "✓ Backed up to $1.bak-$(date +%Y%m%d-%H%M%S)"
    else
        echo "File not found: $1"
    fi
}

# Weather
weather() {
    curl -s "wttr.in/${1:-}"
}

# Quick notes
note() {
    if [[ -n "$1" ]]; then
        echo "$(date '+%Y-%m-%d %H:%M') - $*" >> ~/notes/quick.md
        echo "✓ Note saved"
    else
        $EDITOR ~/notes/quick.md
    fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="$HOME/.cargo/bin:$PATH"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
