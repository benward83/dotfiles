#!/bin/bash

# Dotfiles installation script
# Creates symlinks from home directory to dotfiles repo

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo -e "${GREEN}Installing dotfiles from ${DOTFILES_DIR}${NC}"

# Function to create backup
backup_file() {
    local file=$1
    if [ -e "$file" ] && [ ! -L "$file" ]; then
        mkdir -p "$BACKUP_DIR"
        echo -e "${YELLOW}Backing up existing file: $file${NC}"
        cp -r "$file" "$BACKUP_DIR/"
    fi
}

# Function to create symlink
create_symlink() {
    local source=$1
    local target=$2

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"

    # Backup existing file/directory if it exists and is not a symlink
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        backup_file "$target"
        rm -rf "$target"
    fi

    # Remove existing symlink if it exists
    if [ -L "$target" ]; then
        rm "$target"
    fi

    # Create symlink
    ln -s "$source" "$target"
    echo -e "${GREEN}✓${NC} Linked: $target -> $source"
}

echo ""
echo "Creating symlinks..."
echo ""

# Shell configuration files
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
create_symlink "$DOTFILES_DIR/.bash_profile" "$HOME/.bash_profile"
create_symlink "$DOTFILES_DIR/.profile" "$HOME/.profile"

# Git configuration
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/.gitconfig-personal" "$HOME/.gitconfig-personal"
create_symlink "$DOTFILES_DIR/.config/git/ignore" "$HOME/.config/git/ignore"

# VS Code configuration
create_symlink "$DOTFILES_DIR/.config/Code/User/settings.json" "$HOME/.config/Code/User/settings.json"
create_symlink "$DOTFILES_DIR/.config/Code/User/keybindings.json" "$HOME/.config/Code/User/keybindings.json"
create_symlink "$DOTFILES_DIR/.config/Code/User/snippets" "$HOME/.config/Code/User/snippets"

# Warp terminal
create_symlink "$DOTFILES_DIR/.config/warp-terminal/keybindings.yaml" "$HOME/.config/warp-terminal/keybindings.yaml"
create_symlink "$DOTFILES_DIR/.config/warp-terminal/shell.toml" "$HOME/.config/warp-terminal/shell.toml"

# Claude configuration
create_symlink "$DOTFILES_DIR/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# Scripts and binaries
create_symlink "$DOTFILES_DIR/bin/apply_win_rules_startup.sh" "$HOME/bin/apply_win_rules_startup.sh"
create_symlink "$DOTFILES_DIR/scripts/reset-scarlett.sh" "$HOME/scripts/reset-scarlett.sh"
create_symlink "$DOTFILES_DIR/.local/bin/env" "$HOME/.local/bin/env"

echo ""
if [ -d "$BACKUP_DIR" ]; then
    echo -e "${YELLOW}Original files backed up to: $BACKUP_DIR${NC}"
fi
echo -e "${GREEN}Dotfiles installation complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Install dependencies (see README.md)"
echo "2. Restart your shell or run: source ~/.zshrc"
