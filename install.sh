#!/bin/bash

# Snow White i3 Rice Installer for Arch Linux
# Installs necessary packages and symlinks configuration files.

set -e

echo "❄️  Installing Snow White i3 Rice..."

# 1. Install Packages
echo "📦 Installing packages..."
if command -v pacman &> /dev/null; then
    sudo pacman -S --needed i3-wm kitty rofi picom xorg-xsetroot terminus-font git base-devel \
        dunst scrot xclip xdotool thunar btop neovim \
        clipmenu brightnessctl pamixer redshift playerctl feh udiskie \
        polybar network-manager-applet pavucontrol papirus-icon-theme \
        zsh zsh-autosuggestions zsh-syntax-highlighting fzf bat eza ripgrep fd lazygit zoxide ttf-nerd-fonts-symbols-mono \
        maim ffmpeg jq slop libnotify
else
    echo "⚠️  Pacman not found. Please install the following packages manually:"
    echo "   i3-wm kitty rofi picom xorg-xsetroot terminus-font dunst scrot xclip xdotool thunar btop neovim clipmenu brightnessctl pamixer redshift playerctl feh udiskie"
    echo "   polybar network-manager-applet pavucontrol papirus-icon-theme"
    echo "   zsh zsh-autosuggestions zsh-syntax-highlighting fzf bat eza ripgrep fd lazygit zoxide ttf-nerd-fonts-symbols-mono"
    echo "   maim ffmpeg jq slop libnotify"
fi

# 2. Install GohuFont (AUR) if not present
if ! fc-list | grep -i "Gohu" &> /dev/null; then
    echo "🔤 GohuFont not found. Installing from AUR (yay)..."
    if command -v yay &> /dev/null; then
        yay -S --needed bdf-gohufont-git
    else
        echo "⚠️  'yay' AUR helper not found. Please install 'bdf-gohufont-git' manually for the correct font."
        echo "   Alternatively, edit the config files to use 'Terminus' instead."
    fi
else
    echo "✅ GohuFont is already installed."
fi

# 2b. Install AUR packages
echo "🔌 Installing AUR packages..."
if command -v yay &> /dev/null; then
    yay -S --needed rofi-power-menu i3lock-color autotiling tdrop rofi-calc rofi-emoji networkmanager-dmenu-git
else
    echo "⚠️  'yay' AUR helper not found. Please install these AUR packages manually:"
    echo "   rofi-power-menu i3lock-color autotiling tdrop rofi-calc rofi-emoji networkmanager-dmenu-git"
fi

# 3. Link Configuration Files
echo "🔗 Linking configuration files..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

# Function to link a directory
link_config() {
    local name=$1
    local source="$SCRIPT_DIR/.config/$name"
    local target="$CONFIG_DIR/$name"

    if [ -L "$target" ]; then
        echo "   ⚠️  Removing existing symlink $target"
        rm "$target"
    elif [ -d "$target" ]; then
        echo "   ⚠️  Backup existing $target to $target.bak"
        rm -rf "$target.bak" 2>/dev/null
        mv "$target" "$target.bak"
    fi
    
    echo "   -> Linking $name"
    ln -s "$source" "$target"
}

mkdir -p "$CONFIG_DIR"

link_config "i3"
link_config "kitty"
link_config "alacritty"
link_config "rofi"
link_config "polybar"
link_config "picom"
link_config "dunst"
link_config "scripts"
link_config "gtk-3.0"

# Link .gtkrc-2.0 (GTK2 config)
GTKRC_SOURCE="$SCRIPT_DIR/.config/.gtkrc-2.0"
GTKRC_TARGET="$HOME/.gtkrc-2.0"
if [ -f "$GTKRC_TARGET" ]; then
    echo "   ⚠️  Backup existing .gtkrc-2.0 to .gtkrc-2.0.bak"
    mv "$GTKRC_TARGET" "$GTKRC_TARGET.bak"
fi
echo "   -> Linking .gtkrc-2.0"
ln -s "$GTKRC_SOURCE" "$GTKRC_TARGET"

# Link wallpapers separately (they are in repo root, not in .config)
WALLPAPER_TARGET="$CONFIG_DIR/wallpapers"
if [ -L "$WALLPAPER_TARGET" ]; then
    echo "   ⚠️  Removing existing symlink $WALLPAPER_TARGET"
    rm "$WALLPAPER_TARGET"
elif [ -d "$WALLPAPER_TARGET" ]; then
    echo "   ⚠️  Backup existing $WALLPAPER_TARGET to $WALLPAPER_TARGET.bak"
    mv "$WALLPAPER_TARGET" "$WALLPAPER_TARGET.bak"
fi
echo "   -> Linking wallpapers"
ln -s "$SCRIPT_DIR/wallpapers" "$WALLPAPER_TARGET"

# Link zsh config
if [ -f "$HOME/.zshrc" ]; then
    echo "   ⚠️  Backup existing .zshrc to .zshrc.bak"
    mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi
echo "   -> Linking .zshrc"
ln -s "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"

# 4. Setup zsh plugins
echo "🔌 Setting up zsh plugins..."

# Powerlevel10k
if [ ! -d "$HOME/powerlevel10k" ]; then
    echo "   -> Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
else
    echo "   ✅ Powerlevel10k already installed"
fi

# Change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🐚 Changing default shell to zsh..."
    chsh -s "$(which zsh)"
    echo "   ⚠️  Please log out and back in for shell change to take effect"
fi

# 6. Create user directories
echo "📁 Creating user directories..."
mkdir -p "$HOME/notes"
mkdir -p "$HOME/media/screenshots"
mkdir -p "$HOME/media/recordings"
mkdir -p "$HOME/code"

# 7. Make scripts executable
echo "🔧 Making scripts executable..."
find "$CONFIG_DIR/scripts" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# 8. Reload i3
echo "🔄 Reloading i3..."
i3-msg reload 2>/dev/null || echo "   (i3 is not running, skipping reload)"

# 9. Reload polybar
echo "🔄 Reloading polybar..."
polybar-msg cmd restart 2>/dev/null || echo "   (Polybar is not running, skipping reload)"

echo "❄️  Snow White Rice installed successfully!"
echo ""
echo "   New features:"
echo "   🚀 Script Launcher: Super+r or click rocket icon in polybar"
echo "   📸 Screenshot tool, 🎬 Screen recorder, ⏱️ Pomodoro timer"
echo "   📝 Quick notes, 🎵 Media controls, 🖥️ Display manager"
echo ""
echo "   Press Mod+Shift+r to restart i3 in place if you are already running it."
