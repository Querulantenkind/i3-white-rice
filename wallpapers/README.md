# ❄️ Snow White Wallpapers

Minimalist, high-contrast wallpapers for the Snow White i3 Rice.

## Available Wallpapers

### `snow-white.png`
- **Resolution:** 1920x1080 (Full HD)
- **Style:** Pure white (#FFFFFF)
- **Perfect for:** Maximum eye comfort, minimal distraction

### `snow-white.svg`
- **Format:** Scalable Vector Graphics
- **Features:** Subtle snowflake pattern with light gray accents
- **Use:** Can be rendered at any resolution

## Usage

The wallpaper is automatically set by `feh` when i3 starts. To change it manually:

```bash
feh --bg-fill ~/.config/wallpapers/snow-white.png
```

To restore on login, add to your `~/.xinitrc` or i3 config (already configured):

```bash
exec --no-startup-id feh --bg-fill ~/.config/wallpapers/snow-white.png
```

## Creating Custom Wallpapers

To create your own snow white variations:

```bash
# Solid color
convert -size 1920x1080 xc:#ffffff custom-white.png

# With subtle gradient
convert -size 1920x1080 gradient:#ffffff-#f8f8f8 gradient-white.png

# With pattern
convert -size 1920x1080 pattern:gray5 -background white -alpha remove pattern-white.png
```

## Multi-Monitor Setup

For different resolutions or multiple monitors:

```bash
# 4K (3840x2160)
feh --bg-fill ~/.config/wallpapers/snow-white.svg

# Dual monitors
feh --bg-fill ~/.config/wallpapers/snow-white.png --bg-fill ~/.config/wallpapers/snow-white.png
```

---

**Snow White Rice** | Minimalist Arch Linux i3wm Setup
