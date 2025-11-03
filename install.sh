#!/usr/bin/env bash

# Dotfiles installation script
# Platform-agnostic wrapper for setup scripts

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}    Dotfiles Installation${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Detect platform
case "$(uname -s)" in
    Linux*)
        PLATFORM="Linux"
        SETUP_SCRIPT="$DOTFILES_DIR/scripts/setup-linux.sh"
        ;;
    Darwin*)
        PLATFORM="macOS"
        SETUP_SCRIPT="$DOTFILES_DIR/scripts/setup-macos.sh"
        ;;
    *)
        echo -e "${RED}✗ Unsupported platform: $(uname -s)${NC}"
        echo "This script supports Linux and macOS only."
        exit 1
        ;;
esac

echo -e "${BLUE}Platform detected: $PLATFORM${NC}"
echo ""

# Check if setup script exists
if [ ! -f "$SETUP_SCRIPT" ]; then
    echo -e "${RED}✗ Setup script not found: $SETUP_SCRIPT${NC}"
    exit 1
fi

# Run platform-specific setup
bash "$SETUP_SCRIPT"

# Run Omarchy setup for Linux if available
if [ "$PLATFORM" = "Linux" ] && [ -f "$DOTFILES_DIR/scripts/omarchy-setup.sh" ]; then
    echo ""
    read -p "Do you want to set up Omarchy themes? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        bash "$DOTFILES_DIR/scripts/omarchy-setup.sh"
    fi
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Installation complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
