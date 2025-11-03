# Ben's Dotfiles

Personal configuration files for **Linux (Arch/Omarchy)** and **macOS** development environments. Designed to maintain consistency across machines using symlinks with platform-specific setup scripts.

## Quick Start

```bash
# Clone this repo
git clone https://github.com/benward83/dotfiles.git ~/.dotfiles

# Run installation script (auto-detects your platform)
cd ~/.dotfiles
./install.sh

# Install dependencies (see below)
# Restart your shell
```

## Platform Support

This dotfiles repository supports:
- **Linux** (Arch Linux with Hyprland/Omarchy)
- **macOS**

Platform-specific configs are automatically handled by the setup scripts.

## What's Included

### Shell Configuration
- `.zshrc` - ZSH configuration with oh-my-zsh, custom aliases and functions
- `.bashrc`, `.bash_profile`, `.profile` - Bash configurations
- `.local/bin/env` - PATH setup script

### Git Configuration
- `.gitconfig` - Git global config with conditional includes
  - Default: `bward@quadrabee.com` (work email)
  - For `~/.dotfiles/` and `~/personal/`: uses `.gitconfig-personal`
- `.gitconfig-personal` - Personal email override (`benward83@gmail.com`)
- `.config/git/ignore` - Global gitignore

### Terminal Emulators
- `.config/alacritty/alacritty.toml` - Alacritty configuration
- `.config/kitty/kitty.conf` - Kitty terminal configuration
- `.config/warp-terminal/` - Warp terminal configs (Linux-specific)
- `.config/starship.toml` - Starship prompt configuration

### Text Editors
- `.config/nvim/` - Neovim configuration (LazyVim-based)
  - Custom plugins and themes
  - Omarchy theme hot-reload support (Linux)
  - Cross-platform compatible
- `vscode/` - VS Code settings (to be added)
  - `settings.json` - Editor settings
  - `keybindings.json` - Custom keybindings
  - `extensions.txt` - Extension list

### Development Tools
- `.config/lazygit/config.yml` - Lazygit TUI configuration
- `direnv` - Auto-loaded via `.zshrc`

### Linux-Specific (Omarchy/Hyprland)
- `.config/hypr/` - Hyprland window manager configuration
  - `hyprland.conf` - Main config
  - `bindings.conf` - Keybindings
  - `monitors.conf` - Display setup
  - `looknfeel.conf` - Appearance
  - `envs.conf` - Environment variables
- `linux/omarchy/` - Omarchy theme system
  - `config.sh` - Theme preferences
  - `themes/` - Custom themes directory

### Scripts
- `scripts/setup-linux.sh` - Linux/Omarchy setup script
- `scripts/setup-macos.sh` - macOS setup script
- `scripts/omarchy-setup.sh` - Omarchy theme installer
- `scripts/reset-scarlett.sh` - Audio interface reset script

## Installation Scripts

### Main Installer

```bash
./install.sh
```

Auto-detects your platform (Linux or macOS) and runs the appropriate setup script. On Linux, offers to set up Omarchy themes interactively.

### Platform-Specific Setup

**Linux:**
```bash
./scripts/setup-linux.sh
```

**macOS:**
```bash
./scripts/setup-macos.sh
```

**Omarchy Themes (Linux only):**
```bash
./scripts/omarchy-setup.sh
```

## Dependencies

These need to be installed manually on a new system:

### Essential (All Platforms)
- **ZSH** - `sudo pacman -S zsh` (Arch) or `brew install zsh` (macOS)
- **oh-my-zsh**:
  ```bash
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ```
- **Git** - Usually pre-installed

### ZSH Plugins
```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### Development Tools
- **NVM** (Node Version Manager):
  ```bash
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
  ```
- **direnv** - `sudo pacman -S direnv` (Arch) or `brew install direnv` (macOS)
- **Starship** - `sudo pacman -S starship` (Arch) or `brew install starship` (macOS)
- **Neovim** - `sudo pacman -S neovim` (Arch) or `brew install neovim` (macOS)
- **Lazygit** - `sudo pacman -S lazygit` (Arch) or `brew install lazygit` (macOS)

### Terminal Emulators
- **Alacritty** - `sudo pacman -S alacritty` (Arch) or `brew install --cask alacritty` (macOS)
- **Kitty** - `sudo pacman -S kitty` (Arch) or `brew install --cask kitty` (macOS)
- **Warp** (optional) - Download from https://www.warp.dev/

### Linux-Specific (Omarchy/Hyprland)
- **Hyprland** - `sudo pacman -S hyprland`
- **Omarchy** - Follow installation from https://github.com/warbacon/omarchy
- **CaskaydiaMono Nerd Font** - For terminal icons

### macOS-Specific
- **Homebrew** - `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

## Git Email Configuration

The `.gitconfig` uses conditional includes to automatically use the correct email:

- **Work repos** (default): `bward@quadrabee.com`
- **Personal projects** (`~/.dotfiles/`, `~/personal/`): `benward83@gmail.com`

This is automatic - no manual switching needed! Just put personal projects in `~/personal/` directory.

## Omarchy Theme System (Linux)

Custom themes go in `linux/omarchy/themes/`. The setup script will symlink them to `~/.config/omarchy/themes/`.

To change your preferred theme:
1. Edit `linux/omarchy/config.sh`
2. Set `OMARCHY_THEME="your-theme-name"`
3. Run `./scripts/omarchy-setup.sh`

Or use Omarchy directly:
```bash
omarchy theme list
omarchy theme set <theme-name>
```

## Adding VS Code Configuration (Future)

When on your system with VS Code configured:

1. Export settings:
   ```bash
   cp ~/.config/Code/User/settings.json ~/.dotfiles/vscode/settings.json
   cp ~/.config/Code/User/keybindings.json ~/.dotfiles/vscode/keybindings.json
   ```

2. Export extensions:
   ```bash
   code --list-extensions > ~/.dotfiles/vscode/extensions.txt
   ```

3. Commit and push:
   ```bash
   cd ~/.dotfiles
   git add vscode/
   git commit -m "[VSCode] Add settings and extensions"
   git push
   ```

The setup scripts will automatically handle platform-specific VS Code paths.

## Updating Dotfiles

Since configs are symlinked, any edits you make to files like `~/.zshrc` automatically update the repo:

```bash
cd ~/.dotfiles
git status  # See what changed
git add <changed-files>
git commit -m "[Component] Description of changes"
git push
```

**Important:** Follow the commit message format: `[Component] Description`

Examples:
- `[Zsh] Add docker compose alias`
- `[Hypr] Update keybindings for screenshot`
- `[Nvim] Add new LSP configuration`

## Cross-Platform Notes

### Configs That Work Everywhere
- Shell configs (`.zshrc`, etc.)
- Git configuration
- Neovim
- Starship prompt
- Lazygit
- Terminal emulators (alacritty, kitty)

### Linux-Only
- Hyprland configuration
- Omarchy themes
- Warp terminal (partially)

### Platform-Specific Handling
- Terminal configs reference Omarchy themes but won't break on macOS (files just won't exist)
- VS Code paths differ: Linux uses `~/.config/Code/User/`, macOS uses `~/Library/Application Support/Code/User/`
- Setup scripts handle these differences automatically

## Troubleshooting

**Q: Symlink already exists error?**
A: The scripts handle this automatically. If issues persist, manually remove: `rm ~/.zshrc` then re-run.

**Q: Permission denied on scripts?**
A: Ensure scripts are executable: `chmod +x ~/.dotfiles/scripts/*.sh`

**Q: ZSH plugins not loading?**
A: Install oh-my-zsh plugins (see Dependencies section)

**Q: Omarchy themes not applying?**
A: Ensure Omarchy is installed. Run `omarchy theme list` to see available themes.

**Q: Terminal theme looks broken on macOS?**
A: Normal - Omarchy theme imports are Linux-only. You can comment out the import lines or add macOS-specific themes.

**Q: Neovim plugins not installed?**
A: Open nvim and run `:Lazy sync` to install all plugins.

**Q: Hyprland config appearing on macOS?**
A: It's harmless - macOS ignores Hyprland configs. The setup script only symlinks what's needed.

## Repository Structure

```
.dotfiles/
├── README.md                        # This file
├── install.sh                       # Main installer (platform detection)
├── .gitignore                       # Comprehensive gitignore
│
├── Shell configs
├── .zshrc                           # ZSH configuration
├── .bashrc                          # Bash configuration
├── .bash_profile
├── .profile
│
├── Git configs
├── .gitconfig                       # Main git config
├── .gitconfig-personal              # Personal email override
│
├── .config/                         # Cross-platform configs
│   ├── hypr/                        # Hyprland (Linux only)
│   │   ├── hyprland.conf
│   │   ├── bindings.conf
│   │   ├── monitors.conf
│   │   └── ...
│   ├── alacritty/
│   │   └── alacritty.toml
│   ├── kitty/
│   │   └── kitty.conf
│   ├── nvim/                        # Neovim (cross-platform)
│   │   ├── init.lua
│   │   └── lua/
│   ├── warp-terminal/               # Warp terminal
│   ├── starship.toml                # Starship prompt
│   ├── lazygit/
│   │   └── config.yml
│   ├── git/
│   │   └── ignore
│   └── Code/                        # VS Code (already tracked)
│
├── linux/                           # Linux-specific
│   └── omarchy/
│       ├── config.sh                # Theme preferences
│       └── themes/                  # Custom themes
│
├── macos/                           # macOS-specific (future)
│
├── vscode/                          # VS Code (to be added)
│   ├── settings.json
│   ├── keybindings.json
│   └── extensions.txt
│
├── scripts/
│   ├── setup-linux.sh               # Linux setup
│   ├── setup-macos.sh               # macOS setup
│   ├── omarchy-setup.sh             # Omarchy theme installer
│   └── reset-scarlett.sh            # Audio script
│
└── .local/bin/
    └── env                          # PATH setup
```

## License

Personal configurations - use at your own risk!
