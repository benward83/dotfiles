# Ben's Dotfiles

Personal configuration files for Linux development environments. Designed to maintain consistency across machines using symlinks.

## Quick Start

```bash
# Clone this repo
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles

# Run installation script
cd ~/.dotfiles
./install.sh

# Install dependencies (see below)
# Restart your shell
```

## What's Included

### Shell Configuration
- `.zshrc` - ZSH configuration with oh-my-zsh, powerlevel10k, custom aliases
- `.bashrc`, `.bash_profile`, `.profile` - Bash configurations
- `.local/bin/env` - PATH setup script

### Git Configuration
- `.gitconfig` - Git global config with conditional includes
  - Default: `bward@quadrabee.com` (work email)
  - For `~/.dotfiles/` and `~/personal/`: uses `.gitconfig-personal`
- `.gitconfig-personal` - Personal email override (`benward83@gmail.com`)
- `.config/git/ignore` - Global gitignore

### Editor Configuration
- `.config/Code/User/settings.json` - VS Code settings
- `.config/Code/User/keybindings.json` - VS Code keybindings
- `.config/Code/User/snippets/` - Code snippets directory

### Terminal Configuration
- `.config/warp-terminal/keybindings.yaml` - Warp terminal keybindings
- `.config/warp-terminal/shell.toml` - Warp shell configuration

### Development Tools
- `.claude/CLAUDE.md` - Claude AI project context

### Scripts
- `bin/apply_win_rules_startup.sh` - Window rules startup script
- `scripts/reset-scarlett.sh` - Scarlett audio interface reset script

## Dependencies

These need to be installed manually on a new system:

### Essential
- **ZSH** - `sudo dnf install zsh` (Fedora) or `sudo apt install zsh` (Ubuntu)
- **oh-my-zsh** - `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
- **Git** - Usually pre-installed

### ZSH Plugins
```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### Development Tools
- **NVM** (Node Version Manager) - `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash`
- **direnv** - `sudo dnf install direnv` or `sudo apt install direnv`
- **emb** - Enspirit build tool (if needed for work projects)
- **VS Code** - Download from https://code.visualstudio.com/

### Optional
- **Warp Terminal** - Download from https://www.warp.dev/

## Git Email Configuration Explained

The `.gitconfig` uses conditional includes to automatically use the correct email:

- **Work repos** (default): `bward@quadrabee.com`
- **Personal projects** (`~/.dotfiles/`, `~/personal/`): `benward83@gmail.com`

This is automatic - no manual switching needed! Just put personal projects in `~/personal/` directory.

## Installation Details

The `install.sh` script:
1. Backs up existing configs to `~/.dotfiles_backup_TIMESTAMP/`
2. Creates symlinks from `$HOME` to files in `~/.dotfiles/`
3. Preserves directory structure for `.config/` files
4. Is idempotent (safe to run multiple times)

## Manual Installation (Without Script)

If you prefer to set up manually:

```bash
cd ~/.dotfiles

# Shell configs
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/.profile ~/.profile

# Git configs
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.gitconfig-personal ~/.gitconfig-personal
mkdir -p ~/.config/git
ln -s ~/.dotfiles/.config/git/ignore ~/.config/git/ignore

# VS Code configs
mkdir -p ~/.config/Code/User
ln -s ~/.dotfiles/.config/Code/User/settings.json ~/.config/Code/User/settings.json
ln -s ~/.dotfiles/.config/Code/User/keybindings.json ~/.config/Code/User/keybindings.json
ln -s ~/.dotfiles/.config/Code/User/snippets ~/.config/Code/User/snippets

# Continue for other files...
```

## Updating Dotfiles

Since configs are symlinked, any edits you make to files like `~/.zshrc` automatically update the repo:

```bash
cd ~/.dotfiles
git status  # See what changed
git add -A
git commit -m "Update shell configuration"
git push
```

## Troubleshooting

**Q: Symlink already exists error?**
A: Remove the old symlink first: `rm ~/.zshrc` then re-run install script

**Q: Permission denied on scripts?**
A: Make them executable: `chmod +x ~/bin/*.sh ~/scripts/*.sh`

**Q: ZSH theme not loading?**
A: Install powerlevel10k and oh-my-zsh plugins (see Dependencies)

**Q: Git still using wrong email?**
A: Check which config is active: `git config user.email`
For dotfiles repo specifically: `cd ~/.dotfiles && git config user.email`

## Structure

```
.dotfiles/
├── README.md
├── install.sh
├── .gitignore
├── .zshrc
├── .bashrc
├── .bash_profile
├── .profile
├── .gitconfig
├── .gitconfig-personal
├── .config/
│   ├── Code/User/
│   │   ├── settings.json
│   │   ├── keybindings.json
│   │   └── snippets/
│   ├── git/ignore
│   └── warp-terminal/
│       ├── keybindings.yaml
│       └── shell.toml
├── .claude/
│   └── CLAUDE.md
├── .local/bin/
│   └── env
├── bin/
│   └── apply_win_rules_startup.sh
└── scripts/
    └── reset-scarlett.sh
```

## License

Personal configurations - use at your own risk!
