#!/usr/bin/env bash

set -euo pipefail

DOTFILES="$HOME/.dotfiles"
PLATFORM="$(uname -s)"
FIX=false
HAS_ISSUES=false

if [[ "${1:-}" == "--fix" ]]; then
    FIX=true
fi

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ok()   { echo -e "  ${GREEN}OK${NC}  $1"; }
warn() { echo -e "  ${YELLOW}!!${NC}  $1"; HAS_ISSUES=true; }
err()  { echo -e "  ${RED}XX${NC}  $1"; HAS_ISSUES=true; }

check_link() {
    local target="$1"
    local source="$2"
    local label="${3:-$target}"

    if [ -L "$target" ]; then
        local actual
        actual="$(readlink "$target")"
        if [ "$actual" = "$source" ]; then
            ok "$label"
        else
            warn "$label -> $actual (expected $source)"
            if $FIX; then
                ln -sf "$source" "$target"
                echo -e "      Fixed: $label -> $source"
            fi
        fi
    elif [ -e "$target" ]; then
        err "$label is a regular file, not a symlink"
        if diff -q "$source" "$target" >/dev/null 2>&1; then
            echo -e "      Content is identical to repo version"
            if $FIX; then
                ln -sf "$source" "$target"
                echo -e "      Fixed: replaced with symlink"
            else
                echo -e "      Safe to fix with --fix"
            fi
        else
            echo -e "      ${RED}Content differs from repo version — manual merge needed${NC}"
            echo -e "      Run: diff $source $target"
        fi
    else
        warn "$label missing"
        if $FIX; then
            mkdir -p "$(dirname "$target")"
            ln -sf "$source" "$target"
            echo -e "      Created: $label -> $source"
        fi
    fi
}

echo ""
echo "Dotfiles Symlink Audit"
echo "======================"
echo "Platform: $PLATFORM"
if $FIX; then
    echo "Mode: FIX"
else
    echo "Mode: AUDIT (use --fix to repair)"
fi
echo ""

echo "Shell:"
check_link "$HOME/.zshrc"         "$DOTFILES/.zshrc"         "~/.zshrc"
check_link "$HOME/.bashrc"        "$DOTFILES/.bashrc"        "~/.bashrc"
check_link "$HOME/.bash_profile"  "$DOTFILES/.bash_profile"  "~/.bash_profile"
check_link "$HOME/.profile"       "$DOTFILES/.profile"       "~/.profile"
echo ""

echo "Git:"
check_link "$HOME/.gitconfig"          "$DOTFILES/.gitconfig"          "~/.gitconfig"
check_link "$HOME/.gitconfig-personal" "$DOTFILES/.gitconfig-personal" "~/.gitconfig-personal"
echo ""

echo "Terminals:"
check_link "$HOME/.config/alacritty/alacritty.toml" "$DOTFILES/.config/alacritty/alacritty.toml" "~/.config/alacritty/alacritty.toml"
check_link "$HOME/.config/kitty/kitty.conf"         "$DOTFILES/.config/kitty/kitty.conf"         "~/.config/kitty/kitty.conf"
echo ""

echo "Dev tools:"
check_link "$HOME/.config/nvim"               "$DOTFILES/.config/nvim"               "~/.config/nvim"
check_link "$HOME/.config/starship.toml"      "$DOTFILES/.config/starship.toml"      "~/.config/starship.toml"
check_link "$HOME/.config/lazygit/config.yml" "$DOTFILES/.config/lazygit/config.yml" "~/.config/lazygit/config.yml"
check_link "$HOME/.local/bin/env"             "$DOTFILES/.local/bin/env"             "~/.local/bin/env"
echo ""

echo "Claude Code:"
check_link "$HOME/.claude/settings.json" "$DOTFILES/claude-code/settings.json" "~/.claude/settings.json"
check_link "$HOME/.claude/CLAUDE.md"     "$DOTFILES/claude-code/CLAUDE.md"     "~/.claude/CLAUDE.md"
check_link "$HOME/.claude/rules"         "$DOTFILES/claude-code/rules"         "~/.claude/rules"
check_link "$HOME/.claude/skills"        "$DOTFILES/claude-code/skills"        "~/.claude/skills"
echo ""

echo "VS Code:"
if [[ "$PLATFORM" == "Darwin" ]]; then
    VSCODE_DIR="$HOME/Library/Application Support/Code/User"
    if [ -f "$VSCODE_DIR/settings.json" ]; then
        ok "VS Code settings.json (generated file)"
    else
        warn "VS Code settings.json missing — run setup-macos.sh"
    fi
    check_link "$VSCODE_DIR/keybindings.json" "$DOTFILES/vscode/keybindings.json" "VS Code keybindings.json"
else
    for dir in "$HOME/.config/Code/User" "$HOME/.config/Code - OSS/User"; do
        label=$(basename "$(dirname "$dir")")
        if [ -f "$dir/settings.json" ]; then
            ok "$label settings.json (generated file)"
        else
            warn "$label settings.json missing — run setup-linux.sh"
        fi
        check_link "$dir/keybindings.json" "$DOTFILES/vscode/keybindings.json" "$label keybindings.json"
    done
fi
echo ""

if [[ "$PLATFORM" != "Darwin" ]]; then
    echo "Linux:"
    check_link "$HOME/.config/hypr"                "$DOTFILES/.config/hypr"                "~/.config/hypr"
    check_link "$HOME/.config/code-flags.conf"     "$DOTFILES/.config/code-flags.conf"     "~/.config/code-flags.conf"
    check_link "$HOME/.config/brave-flags.conf"    "$DOTFILES/.config/brave-flags.conf"    "~/.config/brave-flags.conf"
    check_link "$HOME/.config/chromium-flags.conf" "$DOTFILES/.config/chromium-flags.conf" "~/.config/chromium-flags.conf"
    echo ""
fi

echo "======================"
if $HAS_ISSUES; then
    echo -e "${YELLOW}Issues found.${NC}"
    if ! $FIX; then
        echo "Run: bash ~/.dotfiles/scripts/audit-symlinks.sh --fix"
    fi
else
    echo -e "${GREEN}All symlinks correct.${NC}"
fi
echo ""
