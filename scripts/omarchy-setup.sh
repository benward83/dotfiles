#!/usr/bin/env bash

set -euo pipefail

echo "🎨 Setting up Omarchy theme system..."

DOTFILES="$HOME/.dotfiles"

# Check if Omarchy is installed
if ! [ -d "$HOME/.local/share/omarchy" ]; then
    echo "⚠️  Omarchy not found. Install Omarchy first:"
    echo "   https://github.com/warbacon/omarchy"
    exit 1
fi

# Load theme preference
OMARCHY_THEME="matte-black"  # Default
if [ -f "$DOTFILES/linux/omarchy/config.sh" ]; then
    source "$DOTFILES/linux/omarchy/config.sh"
    echo "📋 Using theme preference: $OMARCHY_THEME"
fi

# Symlink custom themes (if any)
if [ -d "$DOTFILES/linux/omarchy/themes" ]; then
    mkdir -p "$HOME/.config/omarchy/themes"

    for theme_dir in "$DOTFILES/linux/omarchy/themes"/*; do
        if [ -d "$theme_dir" ] && [ "$(basename "$theme_dir")" != ".gitkeep" ]; then
            theme_name=$(basename "$theme_dir")
            echo "🔗 Linking custom theme: $theme_name"
            ln -sf "$theme_dir" "$HOME/.config/omarchy/themes/$theme_name"
        fi
    done
fi

# Apply theme using Omarchy's theme switcher
if command -v omarchy &> /dev/null; then
    echo "🎨 Applying theme: $OMARCHY_THEME"
    omarchy theme set "$OMARCHY_THEME" 2>/dev/null || {
        echo "⚠️  Could not apply theme automatically."
        echo "   Available themes:"
        omarchy theme list 2>/dev/null || ls ~/.config/omarchy/themes/ ~/.local/share/omarchy/themes/ 2>/dev/null
        echo "   Run: omarchy theme set <theme-name>"
    }
else
    echo "⚠️  Omarchy command not found. Theme must be set manually."
    echo "   Run: omarchy theme set $OMARCHY_THEME"
fi

echo "✅ Omarchy setup complete!"
