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

# Warp terminal (if exists in dotfiles)
if [ -d "$DOTFILES/.config/warp-terminal" ]; then
    echo "⚡ Linking Warp terminal configuration..."
    mkdir -p "$HOME/.config/warp-terminal"
    ln -sf "$DOTFILES/.config/warp-terminal/keybindings.yaml" "$HOME/.config/warp-terminal/keybindings.yaml"
    ln -sf "$DOTFILES/.config/warp-terminal/shell.toml" "$HOME/.config/warp-terminal/shell.toml"
fi

# VS Code (when added later)
if [ -f "$DOTFILES/vscode/settings.json" ]; then
    echo "💙 Linking VS Code configuration..."
    VSCODE_USER_DIR="$HOME/.config/Code/User"
    mkdir -p "$VSCODE_USER_DIR"
    ln -sf "$DOTFILES/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
    ln -sf "$DOTFILES/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"

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

echo "✅ Linux dotfiles setup complete!"
echo ""
echo "Next steps:"
echo "  1. Reload your shell: source ~/.zshrc"
echo "  2. If using Hyprland: hyprctl reload"
echo "  3. Restart your terminal to see all changes"
