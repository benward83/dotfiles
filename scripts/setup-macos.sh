#!/usr/bin/env bash

set -euo pipefail

echo "🍎 Setting up macOS dotfiles..."

DOTFILES="$HOME/.dotfiles"

# Shell configs
echo "📝 Linking shell configurations..."
ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/.bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES/.bash_profile" "$HOME/.bash_profile"
ln -sf "$DOTFILES/.profile" "$HOME/.profile"

# Git configs
echo "🔧 Linking git configurations..."
ln -sf "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES/.gitconfig-personal" "$HOME/.gitconfig-personal"

# Terminal emulators (will ignore Omarchy theme imports)
echo "💻 Linking terminal emulator configurations..."
mkdir -p "$HOME/.config/alacritty"
ln -sf "$DOTFILES/.config/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

mkdir -p "$HOME/.config/kitty"
ln -sf "$DOTFILES/.config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# Neovim
echo "✏️  Linking Neovim configuration..."
mkdir -p "$HOME/.config"
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

# VS Code (when added later)
if [ -f "$DOTFILES/vscode/settings.json" ]; then
    echo "💙 Linking VS Code configuration..."
    VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
    mkdir -p "$VSCODE_USER_DIR"

    jq -s '.[0] * .[1]' "$DOTFILES/vscode/settings.json" "$DOTFILES/vscode/settings.mac.json" > "$VSCODE_USER_DIR/settings.json"

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

# Claude Code — config lives in Obsidian vault, symlinked from ~/.claude/
echo "🤖 Linking Claude Code configuration (from Obsidian vault)..."
VAULT="$HOME/Documents/Obsidian Vault/Tooling/Claude Code"
if [ -d "$VAULT" ]; then
    mkdir -p "$HOME/.claude"
    ln -sf "$VAULT/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
    ln -sf "$VAULT/lessons.md" "$HOME/.claude/lessons.md"
    ln -sf "$VAULT/lessons-private.md" "$HOME/.claude/lessons-private.md"
    ln -sf "$VAULT/settings.json" "$HOME/.claude/settings.json"
    rm -rf "$HOME/.claude/rules"
    ln -sfn "$VAULT/rules" "$HOME/.claude/rules"
    rm -rf "$HOME/.claude/skills"
    ln -sfn "$VAULT/skills" "$HOME/.claude/skills"
    rm -rf "$HOME/.claude/hooks"
    ln -sfn "$VAULT/hooks" "$HOME/.claude/hooks"

    # Shell scripts need execute bit (Obsidian Sync doesn't preserve permissions)
    find "$VAULT" -name "*.sh" -exec chmod +x {} \;

    # Memory symlink (project path is platform-specific)
    PROJ_DIR="$HOME/.claude/projects/-Users-$(whoami)"
    mkdir -p "$PROJ_DIR"
    if [ ! -L "$PROJ_DIR/memory" ]; then
        rm -rf "$PROJ_DIR/memory"
        ln -s "$VAULT/memory" "$PROJ_DIR/memory"
    fi
else
    echo "  ⚠️  Obsidian vault not found at $VAULT — skipping Claude Code setup"
    echo "  Sync via Obsidian first, then re-run this script"
fi

echo "✅ macOS dotfiles setup complete!"
echo ""
echo "Next steps:"
echo "  1. Reload your shell: source ~/.zshrc"
echo "  2. Restart your terminal to see all changes"
echo ""
echo "Note: Hyprland and Omarchy configs are Linux-only and will be ignored on macOS"
