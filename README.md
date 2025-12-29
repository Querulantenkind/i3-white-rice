# ❄️ Snow White i3 Rice

<p align="center">
  <strong>A minimalist, high-contrast, resource-efficient i3wm configuration for Arch Linux</strong><br>
  <em>Designed for maximum readability and speed with a pure white aesthetic</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/WM-i3-blue?style=flat-square" alt="i3">
  <img src="https://img.shields.io/badge/OS-Arch%20Linux-1793d1?style=flat-square&logo=arch-linux" alt="Arch Linux">
  <img src="https://img.shields.io/badge/Terminal-Kitty-000000?style=flat-square" alt="Kitty">
  <img src="https://img.shields.io/badge/Style-OmarchyOS-ff69b4?style=flat-square" alt="OmarchyOS Keybindings">
</p>

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🪶 **Ultra-Lightweight** | Core tools only — `i3`, `polybar`, `rofi`, `dunst` |
| ⬛ **High Contrast** | Pure white `#FFFFFF` background, sharp black `#000000` text |
| 🔤 **Pixel Perfect** | Bitmap font **GohuFont** for crisp rendering |
| 🚫 **No Bloat** | No gaps, no shadows, no fading — just raw speed |
| ⌨️ **OmarchyOS Keybindings** | Intuitive hotkeys inspired by [OmarchyOS](https://omarchy.com) |

### 🧰 Optimized Tools

| Tool | Purpose |
|------|---------|
| `kitty` | GPU-accelerated terminal |
| `alacritty` | Alternative Rust-based terminal (also configured) |
| `polybar` | Customizable status bar with modules |
| `rofi` | Application launcher (themed) |
| `picom` | Compositor (xrender, vsync only) |
| `dunst` | Lightweight notifications |
| `thunar` | File manager |
| `scrot` + `xclip` | Screenshots |
| `nm-applet` | NetworkManager system tray |

### 🐚 Terminal Setup

| Tool | Purpose |
|------|---------|
| `zsh` | Modern shell with powerful features |
| `powerlevel10k` | Beautiful, fast prompt theme |
| `zsh-autosuggestions` | Fish-like command suggestions |
| `zsh-syntax-highlighting` | Real-time syntax highlighting |
| `fzf` | Fuzzy finder for files & history |
| `bat` | `cat` with syntax highlighting |
| `eza` | Modern `ls` with icons |
| `ripgrep` | Fast recursive grep |
| `fd` | Fast alternative to `find` |
| `zoxide` | Smart directory jumper |
| `lazygit` | Terminal UI for git |

---

## 🛠️ Requirements

- **OS**: Arch Linux (or Arch-based)
- **AUR Helper**: `yay` (for fonts and extras)

<details>
<summary>📦 <strong>Full Package List</strong></summary>
polybar kitty rofi picom dunst
network-manager-applet pavucontrol
scrot xclip xdotool thunar btop
zen-browser neovim terminus-font
zsh zsh-autosuggestions zsh-syntax-highlighting
fzf bat eza ripgrep fd lazygit zoxide
ttf-nerd-fonts-symbols-mono
bdf-gohufont-git (AUR)
rofi-power-menu (AUR)
networkmanager-dmenu-gitsymbols-mono
bdf-gohufont-git (AUR)
rofi-power-menu (AUR)
```

</details>

---

## 🚀 Installation

```bash
git clone https://github.com/yourusername/i3-white-rice.git
cd i3-white-rice
./install.sh
```

The script will:
1. Install all required packages (including zsh and CLI tools)
2. Link configuration files to `~/.config`
3. Install Powerlevel10k theme
4. Change your default shell to zsh
5. Reload i3 if running

**After installation:**
- Press **`Super + Shift + R`** to restart i3
- Log out and back in for zsh to become the default shell
- Run `p10k configure` in the terminal to customize your prompt

---

## ⌨️ Keybindings

Keybindings are inspired by [OmarchyOS](https://learn.omacom.io/2/the-omarchy-manual/53/hotkeys) for a consistent, intuitive workflow.

### 🚀 Launching Apps

| Key | Action |
|-----|--------|
| `Super + Space` | Application launcher (Rofi) |
| `Super + Return` | Terminal (Kitty) |
| `Super + Shift + B` | Browser (Zen) |
| `Super + Shift + Alt + B` | Browser (Private) |
| `Super + Shift + F` | File manager (Thunar) |
| `Super + Shift + T` | System monitor (btop) |
| `Super + Shift + N` | Neovim |

### 🪟 Window Controls

| Key | Action |
|-----|--------|
| `Super + W` | Close window |
| `Super + T` | Toggle floating |
| `Super + F` | Fullscreen |
| `Super + S` | Show scratchpad |
| `Super + Alt + S` | Move to scratchpad |
| `Ctrl + Alt + Delete` | Close all windows |

### 🧭 Navigation

| Key | Action |
|-----|--------|
| `Super + 1-9` | Switch to workspace |
| `Super + Shift + 1-9` | Move window to workspace |
| `Super + Tab` | Next workspace |
| `Super + Shift + Tab` | Previous workspace |
| `Super + Arrows` | Focus in direction |
| `Super + Shift + Arrows` | Move window in direction |

### 📐 Layout & Resize

| Key | Action |
|-----|--------|
| `Super + H` | Split horizontal |
| `Super + B` | Split vertical |
| `Super + E` | Toggle split layout |
| `Super + G` | Tabbed layout |
| `Super + =/-` | Resize width |
| `Super + Shift + =/-` | Resize height |

### 📸 Screenshots

| Key | Action |
|-----|--------|
| `Print` | Screenshot selection → clipboard |
| `Shift + Print` | Full screenshot → clipboard |

### 🔔 Notifications

| Key | Action |
|-----|--------|
| `Super + ,` | Dismiss notification |
| `Super + Shift + ,` | Dismiss all |
| `Super + Ctrl + ,` | Toggle Do Not Disturb |
| `Super + Alt + ,` | Show last notification |

### 📋 Clipboard

| Key | Action |
|-----|--------|
| `Super + C` | Copy |
| `Super + V` | Paste |
| `Super + X` | Cut |
| `Super + Ctrl + V` | Clipboard manager |

### ⚙️ System

| Key | Action |
|-----|--------|
| `Super + Escape` | Power menu |
| `Super + Shift + Space` | Toggle bar |
| `Super + Shift + R` | Restart i3 |
| `Super + Shift + C` | Reload config |

---

## 📂 Structure

```
.config/
├── i3/
│   └── config          # Window manager config
├── kitty/
│   └── kitty.conf      # Terminal with Nerd Fonts & splits
├── alacritty/
│   └── alacritty.toml  # Alternative Rust terminal (Snow White theme)
├── rofi/
│   └── snow.rasi       # Launcher theme
├── picom/
│   └── picom.conf      # Compositor (no shadows)
├── i3status/
│   └── config          # Status bar modules
└── wallpapers/
    ├── snow-white.png  # Pure white wallpaper (1920x1080)
    ├── snow-white.svg  # Scalable vector version
    └── README.md       # Wallpaper documentation
.zshrc                  # Zsh config with plugins & aliases
```

---

## 🎨 Customization

### Terminals

**Kitty (Default):**
- GPU-accelerated terminal with split support
- `Ctrl+Shift+Enter` - New window in current directory
- `Ctrl+Shift+-` - Horizontal split
- `Ctrl+Shift+\` - Vertical split
- `Ctrl+Shift+T` - New tab
- `Ctrl+Shift+Q` - Close tab

**Alacritty (Alternative):**
- Lightweight Rust-based terminal included as alternative
- Same Snow White theme for consistency
- Launch with `alacritty` or configure in i3 config

**Font:** Default is JetBrainsMono Nerd Font. Change in:
- [.config/kitty/kitty.conf](.config/kitty/kitty.conf)
- [.config/alacritty/alacritty.toml](.config/alacritty/alacritty.toml)

### Shell (Zsh)

**Useful Functions:**
- `mkcd <dir>` - Create and cd into directory
- `fe` - Fuzzy find and edit file
- `fcd` - Fuzzy cd into directory
- `fgb` - Fuzzy checkout git branch

**Modern Commands:**
- `ls` → `eza` (with icons)
- `cat` → `bat` (with syntax highlighting)
- `cd` → also try `z` (zoxide smart jump)
- `grep` → `rg` (ripgrep)
- `find` → `fd`

Run `p10k configure` to customize your prompt appearance.

### Fonts

Replace fonts in:
- [.config/i3/config](.config/i3/config)
- [.config/kitty/kitty.conf](.config/kitty/kitty.conf)

### Applications

Edit variables at the top of [.config/i3/config](.config/i3/config):

```bash
set $term kitty          # or alacritty
set $browser zen-browser
set $filemanager thunar
```

---

## 📜 License

MIT © Snow White Rice
