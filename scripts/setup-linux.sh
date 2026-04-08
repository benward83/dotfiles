#!/usr/bin/env bash

set -euo pipefail

echo "🐧 Setting up Linux dotfiles..."

DOTFILES="$HOME/.dotfiles"

# Shell configs (already symlinked, but ensure they exist)
echo "📝 Linking shell configurations..."
ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/.bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES/.bash_profile" "$HOME/.bash_profile"
ln -sf "$DOTFILES/.profile" "$HOME/.profile"

# Git configs
echo "🔧 Linking git configurations..."
ln -sf "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES/.gitconfig-personal" "$HOME/.gitconfig-personal"

# Hyprland (already tracked)
echo "🪟 Linking Hyprland configuration..."
ln -sf "$DOTFILES/.config/hypr" "$HOME/.config/hypr"

# Terminal emulators
echo "💻 Linking terminal emulator configurations..."
mkdir -p "$HOME/.config/alacritty"
ln -sf "$DOTFILES/.config/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

mkdir -p "$HOME/.config/kitty"
ln -sf "$DOTFILES/.config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# Neovim
echo "✏️  Linking Neovim configuration..."
ln -sf "$DOTFILES/.config/nvim" "$HOME/.config/nvim"

# Starship
echo "🚀 Linking Starship configuration..."
ln -sf "$DOTFILES/.config/starship.toml" "$HOME/.config/starship.toml"

# Lazygit
echo "🌿 Linking Lazygit configuration..."
mkdir -p "$HOME/.config/lazygit"
ln -sf "$DOTFILES/.config/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"

# Local binaries
echo "🔨 Linking local binaries..."
mkdir -p "$HOME/.local/bin"
ln -sf "$DOTFILES/.local/bin/env" "$HOME/.local/bin/env"

# Electron/Chromium flags for Wayland/GPU compatibility
echo "🎨 Linking Electron/Chromium flags..."
ln -sf "$DOTFILES/.config/code-flags.conf" "$HOME/.config/code-flags.conf"
ln -sf "$DOTFILES/.config/brave-flags.conf" "$HOME/.config/brave-flags.conf"
ln -sf "$DOTFILES/.config/chromium-flags.conf" "$HOME/.config/chromium-flags.conf"

# Omarchy custom themes
if [ -d "$DOTFILES/linux/omarchy/themes" ]; then
    echo "🎨 Copying custom Omarchy themes..."
    mkdir -p "$HOME/.config/omarchy/themes"
    for theme_dir in "$DOTFILES/linux/omarchy/themes"/*; do
        if [ -d "$theme_dir" ] && [ "$(basename "$theme_dir")" != ".gitkeep" ]; then
            theme_name=$(basename "$theme_dir")
            cp -r "$theme_dir" "$HOME/.config/omarchy/themes/$theme_name"
        fi
    done
fi

# VS Code
if [ -f "$DOTFILES/vscode/settings.json" ]; then
    echo "💙 Linking VS Code configuration..."

    VSCODE_USER_DIR="$HOME/.config/Code/User"
    VSCODE_OSS_USER_DIR="$HOME/.config/Code - OSS/User"
    mkdir -p "$VSCODE_USER_DIR" "$VSCODE_OSS_USER_DIR"

    MERGED=$(jq -s '.[0] * .[1]' "$DOTFILES/vscode/settings.json" "$DOTFILES/vscode/settings.linux.json")
    echo "$MERGED" > "$VSCODE_USER_DIR/settings.json"
    echo "$MERGED" > "$VSCODE_OSS_USER_DIR/settings.json"

    ln -sf "$DOTFILES/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
    ln -sf "$DOTFILES/vscode/keybindings.json" "$VSCODE_OSS_USER_DIR/keybindings.json"

    # Install extensions if extensions.txt exists
    if [ -f "$DOTFILES/vscode/extensions.txt" ] && command -v code &> /dev/null; then
        echo "📦 Installing VS Code extensions..."
        while IFS= read -r line; do
            [[ "$line" =~ ^#.*$ ]] && continue
            [[ -z "$line" ]] && continue
            code --install-extension "$line"
        done < "$DOTFILES/vscode/extensions.txt"
    fi
fi

# Claude Code
echo "🤖 Linking Claude Code configuration..."
mkdir -p "$HOME/.claude"
ln -sf "$DOTFILES/claude-code/settings.json" "$HOME/.claude/settings.json"
ln -sf "$DOTFILES/claude-code/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
rm -rf "$HOME/.claude/rules"
ln -sfn "$DOTFILES/claude-code/rules" "$HOME/.claude/rules"
rm -rf "$HOME/.claude/skills"
ln -sfn "$DOTFILES/claude-code/skills" "$HOME/.claude/skills"
ln -sf "$DOTFILES/claude-code/lessons.md" "$HOME/.claude/lessons.md"

echo "✅ Linux dotfiles setup complete!"
echo ""
echo "Next steps:"
echo "  1. Reload your shell: source ~/.zshrc"
echo "  2. If using Hyprland: hyprctl reload"
echo "  3. Restart your terminal to see all changes"
