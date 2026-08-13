# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **dotfiles repository** for managing personal configuration files across Linux (Arch/Omarchy) and macOS systems. All configurations are symlinked to enable easy version control and synchronization across machines.

- **Location**: `~/.dotfiles/`
- **GitHub**: `benward83/dotfiles`
- **Main branch**: `main`
- **Platform Support**: Linux (Arch with Hyprland/Omarchy), macOS

## Installation & Setup

### Initial Setup
```bash
# Clone and install
git clone https://github.com/benward83/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh  # Auto-detects platform (Linux or macOS)
```

### Platform-Specific Setup
```bash
# Linux
./scripts/setup-linux.sh

# macOS
./scripts/setup-macos.sh

# Omarchy theme setup (Linux only)
./scripts/omarchy-setup.sh
```

## Architecture & Configuration Management

### Symlink System
All configuration files are symlinked from `~/.dotfiles/` to their target locations. Editing a file in either location modifies the same file (symlinks, not copies).

**Key symlinked files:**
- Shell configs: `.zshrc`, `.bashrc`, `.bash_profile`, `.profile`
- Git configs: `.gitconfig`, `.gitconfig-personal`
- Hyprland: `~/.config/hypr/` → `~/.dotfiles/.config/hypr/`
- Neovim: `~/.config/nvim/` → `~/.dotfiles/.config/nvim/`
- Terminal configs: Alacritty, Kitty, Warp
- VS Code: `settings.json`, `keybindings.json`, `extensions.txt` (in `vscode/`)

### Git Email Configuration
Uses conditional includes to automatically switch between work and personal email:
- **Default (work)**: `bward@quadrabee.com`
- **Personal** (for `~/.dotfiles/` and `~/personal/`): `benward83@gmail.com`

Configuration in `.gitconfig`:
```ini
[includeIf "gitdir:~/.dotfiles/"]
    path = ~/.gitconfig-personal
[includeIf "gitdir:~/personal/"]
    path = ~/.gitconfig-personal
```

## Critical Workflows

### ALWAYS Commit Dotfile Changes
Because files are symlinked, any edit to a tracked config file must be immediately committed:

1. Make changes (edit anywhere - symlinks make `~/.zshrc` and `~/.dotfiles/.zshrc` the same file)
2. Test changes:
   - Shell configs: `source ~/.zshrc`
   - Hyprland configs: `hyprctl reload`
3. Commit and push immediately:
   ```bash
   cd ~/.dotfiles
   git status
   git add <changed-files>
   git commit -m "[Component] Description of actual changes"
   git push
   ```

### Hyprland Configuration Reload
**CRITICAL**: After editing any Hyprland config file, ALWAYS run:
```bash
hyprctl reload
```

Files requiring reload:
- `bindings.conf` (keybindings)
- `monitors.conf` (display setup)
- `envs.conf` (environment variables)
- `looknfeel.conf` (appearance)
- `input.conf` (mouse/keyboard settings)
- Any other `.config/hypr/*.conf` files

### Git Commit Format
**ALWAYS** use this format: `[Component] Description`

Examples:
- `[Zsh] Add docker compose alias`
- `[Hypr] Update keybindings for screenshot`
- `[Nvim] Add LSP configuration for TypeScript`
- `[Git] Update global gitignore`

**NEVER** add Claude Code attribution, Co-Authored-By tags, or emoji to commits. User wants clean, professional commit messages only.

## Directory Structure

```
.dotfiles/
├── install.sh                    # Main installer (platform detection)
├── scripts/
│   ├── setup-linux.sh           # Linux setup
│   ├── setup-macos.sh           # macOS setup
│   └── omarchy-setup.sh         # Omarchy theme installer
├── Shell configs
├── .zshrc                       # ZSH configuration
├── .bashrc, .bash_profile       # Bash configs
├── Git configs
├── .gitconfig                   # Main git config (work email)
├── .gitconfig-personal          # Personal email override
├── .config/
│   ├── hypr/                    # Hyprland (Linux only)
│   │   ├── hyprland.conf       # Main config (sources Omarchy defaults + overrides)
│   │   ├── bindings.conf       # Custom keybindings
│   │   ├── monitors.conf       # Display configuration
│   │   ├── envs.conf           # Environment variables
│   │   ├── looknfeel.conf      # Appearance settings
│   │   └── ...
│   ├── nvim/                    # Neovim (LazyVim-based)
│   ├── alacritty/alacritty.toml
│   ├── kitty/kitty.conf
│   ├── warp-terminal/
│   ├── starship.toml
│   ├── lazygit/config.yml
│   ├── waybar/                  # Status bar (Linux only)
│   │   ├── config.jsonc         # Modules and layout
│   │   └── style.css            # Bar styling
│   ├── git/ignore               # Global gitignore
│   └── Code/                    # VS Code (tracked via vscode/ dir)
├── linux/
│   └── omarchy/
│       ├── config.sh            # Theme preference
│       ├── themes/              # Custom themes (copied, not symlinked)
│       └── quattro/             # Staged Lua port for Omarchy 4 — inert, not sourced
├── vscode/
│   ├── settings.json            # VS Code settings
│   ├── keybindings.json         # VS Code keybindings
│   └── extensions.txt           # Extension list
└── .local/bin/env               # PATH setup script
```

## Shell Configuration (.zshrc)

### Key Features
- **oh-my-zsh** with plugins: `git`, `zsh-autosuggestions`, `zsh-syntax-highlighting`
- **Theme**: avit (with Powerlevel10k customization)
- **Prompt**: Starship
- **Directory management**: direnv (auto-loads `.envrc` files)
- **Node version management**: nvm
- **PATH setup**: Loaded from `.local/bin/env`

### Essential Aliases
```bash
# Shell
reload              # Reload .zshrc

# Git shortcuts
gch <branch>        # git checkout
gchb <branch>       # git checkout -b
gaa                 # git add .
gcm "msg"           # git commit -m
gss                 # git status
gpl                 # git pull
gps                 # git push
gd                  # git diff
gline               # git log --oneline
gamend "msg"        # git commit --amend -m
gamnoed             # git commit --amend --no-edit
gpfl                # git push --force-with-lease

# Custom functions
gaab <pattern>      # git add all except pattern
gclean              # Delete local branches with deleted remotes
grhard <branch>     # git reset --hard origin/<branch>
grshead <n>         # git reset --soft HEAD~n
grhhead <n>         # git reset --hard HEAD~n
```

### Editor Configuration
- **Local/remote SSH**: vim
- **Default editor**: VS Code (`code`)
- **Git commit editor**: VS Code with wait flag (`code -w`)

## Hyprland Configuration

### Configuration Philosophy
Hyprland uses a **layered configuration** approach:
1. **Omarchy defaults** (sourced from `~/.local/share/omarchy/default/hypr/`)
2. **Current theme** (from `~/.config/omarchy/current/theme/hyprland.conf`)
3. **Personal overrides** (from `~/.config/hypr/*.conf`)

**IMPORTANT**: Never edit Omarchy defaults directly. Always override in personal config files.

### Custom Keybindings (bindings.conf)
`bindings.conf` is the source of truth — read it rather than trusting this list. The main ones:
- `SUPER + Return`: Terminal (ghostty)
- `SUPER + ALT + Return`: Terminal with tmux, in the current directory
- `SUPER + SHIFT + B`: Browser (firefox)
- `SUPER + SHIFT + F`: File manager (Nautilus)
- `SUPER + SHIFT + N`: Editor
- `SUPER + SHIFT + D`: Lazydocker
- `SUPER + SHIFT + P`: btop (system monitor)
- `SUPER + SHIFT + O`: Obsidian
- `SUPER + SHIFT + /`: 1Password
- `SUPER + SHIFT + A`: ChatGPT (web app)
- `SUPER + SHIFT + E`: Email (Hey)
- `SUPER + SHIFT + C`: Claude Desktop
- `SUPER + SHIFT + T`: Telegram
- `SUPER + SHIFT + S`: Slack
- `SUPER + CTRL + 3/4/5`: Screenshot fullscreen / region / screen recording

Media keys configured for volume control with wpctl.

**Omarchy renames its own binaries between versions with no alias.** A binding pointing at a gone command fails silently — no error, nothing on screen.

`omarchy-check-bindings` (in `.local/bin/`) catches this. It scans `~/.config/hypr/*.{conf,lua}` and the waybar config for `omarchy-*` commands that no longer resolve. `setup-linux.sh` symlinks it onto PATH and into `~/.config/omarchy/hooks/post-update.d/`, so it runs automatically after every `omarchy-update` and sends a critical notification on a hit.

## Omarchy Theme System (Linux Only)

### Theme Management
- Custom themes stored in `linux/omarchy/themes/`
- Theme preference in `linux/omarchy/config.sh` (set `OMARCHY_THEME="theme-name"`)
- Apply with: `omarchy theme set <theme-name>`
- List themes: `omarchy theme list`

**Themes are copied into `~/.config/omarchy/themes/`, never symlinked.** The Omarchy 4 upgrade deletes every symlink in that directory without checking where it points, so a symlinked theme would be lost. Edit in `linux/omarchy/themes/`, then re-run `scripts/omarchy-setup.sh` to push the change out.

`config.sh` is only read by the setup scripts, never at boot, so it drifts from the running theme silently. Check it against `~/.config/omarchy/current/theme.name` when touching themes.

### Hot Reload
Omarchy themes support hot-reloading. Neovim config includes Omarchy theme watching for live updates.

## VS Code Configuration

VS Code settings are tracked in `vscode/` and symlinked to platform-specific locations:
- **Linux**: `~/.config/Code/User/` and `~/.config/Code - OSS/User/` (for open source build)
- **macOS**: `~/Library/Application Support/Code/User/`

**Note**: On Arch Linux, the `code` package is actually Code - OSS (open source build). The setup script creates symlinks for both standard VS Code and Code - OSS to ensure compatibility.

The setup scripts automatically:
1. Symlink settings and keybindings to both locations
2. Install all extensions from `extensions.txt`

### Updating VS Code Config
```bash
# Export current settings (if on configured machine)
cp ~/.config/Code/User/settings.json ~/.dotfiles/vscode/settings.json
cp ~/.config/Code/User/keybindings.json ~/.dotfiles/vscode/keybindings.json
code --list-extensions > ~/.dotfiles/vscode/extensions.txt

# Commit
cd ~/.dotfiles
git add vscode/
git commit -m "[VSCode] Update settings and extensions"
git push
```

## Claude Code Configuration

Claude Code config has moved to the **Obsidian vault** (`~/Documents/Obsidian Vault/Tooling/Claude Code/`), synced across devices via Obsidian Sync. The setup scripts in this repo create symlinks from `~/.claude/` to the vault.

See `Tooling/Claude Code/Cross-Device Setup.md` in the vault for full details.

## Dependencies

### Required for All Platforms
- ZSH + oh-my-zsh
- Git
- ZSH plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`
- NVM (Node Version Manager)
- direnv
- Starship prompt
- Neovim
- Lazygit

### Terminal Emulators
- Alacritty
- Kitty
- Warp (optional)

### Linux-Specific
- Hyprland
- Omarchy theme system
- CaskaydiaMono Nerd Font

### macOS-Specific
- Homebrew

## Common Tasks

### Test Shell Changes
```bash
source ~/.zshrc
```

### Apply Hyprland Changes
```bash
hyprctl reload
```

### Change Omarchy Theme
```bash
# Edit preference
code ~/.dotfiles/linux/omarchy/config.sh
# Set OMARCHY_THEME="theme-name"

# Apply
./scripts/omarchy-setup.sh
# OR
omarchy theme set theme-name
```

### Install ZSH Plugins (New Machine)
```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### Pull Latest Dotfiles
```bash
cd ~/.dotfiles
git pull origin main
```

## Platform Differences

### Cross-Platform Configs
Work on both Linux and macOS:
- Shell configurations
- Git configuration
- Neovim
- Starship
- Lazygit
- Terminal emulators (Alacritty, Kitty)

### Linux-Only
- Hyprland configuration
- Omarchy themes
- Some Warp terminal configs

### Platform-Specific Handling
The setup scripts automatically handle platform differences:
- VS Code paths differ between Linux and macOS
- Omarchy theme imports are skipped on macOS
- Hyprland configs are only symlinked on Linux

## Important Notes

1. **Symlinks are not copies**: Editing `~/.zshrc` edits `~/.dotfiles/.zshrc` (same file)
2. **Always commit after editing tracked files**: Changes are immediately reflected in the git repo
3. **Always reload after Hyprland changes**: Run `hyprctl reload`
4. **Don't edit Omarchy defaults**: Override in personal configs instead
5. **Commit messages are clean**: No AI attribution, no emoji (unless user requests)
6. **Git email is automatic**: Work email by default, personal email for `~/.dotfiles/` and `~/personal/`
