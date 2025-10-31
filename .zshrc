# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export MK_USER_PLUGINS_DIR=$HOME/.mkplugins

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="avit"
POWERLEVEL10K_LEFT_PROMPT_ELEMENTS=(dir rbenv vcs)
POWERLEVEL10K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
POWERLEVEL10K_PROMPT_ON_NEWLINE=true
# Add a space in the first prompt
POWERLEVEL10K_MULTILINE_FIRST_PROMPT_PREFIX="%f"
# Visual customisation of the second prompt line
local user_symbol="$"
if [[ $(print -P "%#") =~ "#" ]]; then
    user_symbol="#"
fi
POWERLEVEL10K_MULTILINE_LAST_PROMPT_PREFIX="%{%B%F{black}%K{yellow}%} $user_symbol%{%b%f%k%F{yellow}%} %{%f%}"

POWERLEVEL10K_VCS_MODIFIED_BACKGROUND=’red’

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
# Plugin configuration
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
ZSH_HIGHLIGHT_PATTERNS+=("git*" fg=yellow,bold)
ZSH_HIGHLIGHT_PATTERNS+=("cd" fg=green,bold)
ZSH_HIGHLIGHT_PATTERNS+=("pnpm" fg=blue,bold)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code -w'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
  alias claude-config='code ~/.claude/CLAUDE.md'

  alias zshrc='code ~/.zshrc'

  alias open='xdg-open'
  alias embk="emb kubernetes"
# Git
  alias gch="git checkout"
  alias gchb="git checkout -b"
  alias gpl="git pull"
  alias gps="git push"
  alias ga="git add"
  alias gaa="git add ."
  alias gcm="git commit -m"
  alias gss="git status"
  alias gprb="git pull --rebase"
  alias gst="git stash"
  alias gstp="git stash pop"
  alias gfa="git fetch --all --prune"
  alias gd="git diff"
  alias gru="git remote update"
  alias ghead="git reset HEAD~"
  alias gline="git log --oneline"
  alias gflog="git reflog --date=format:'%Y-%m-%d %H:%M' --pretty"
  alias gap="git add -p"
  alias gamend="git commit --amend -m"
  alias gamnoed="git commit --amend --no-edit"
  alias gpfl="git push --force-with-lease"
  alias gcmrd="git push -o merge_request.draft"
  alias gcmr="git push -o merge_request.create"

# Custom funcs
function gaab() {
  git add --all -- ":!$1"
}

function gpscmr() {
  git push -u origin $(branch) -o merge_request.create
}

function gautomerge() {
  git push --force-with-lease origin $(branch) \
    -o merge_request.merge_when_pipeline_succeeds
}

function gfix() {
  git commit --fixup="$1"
}

function gpr-create() {
  git push -o merge_request.create "$@"
}

function gpr-draft() {
  git push -o merge_request.draft "$@"
}

function gpr-merge() {
  git push -o merge_request.merge_when_pipeline_succeeds "$@"
}

function grbauto() {
  git rebase -i --autosquash "$1"
}

function grhard() {
  local target_branch="${1:-$(git rev-parse --abbrev-ref HEAD)}"
  git reset --hard "origin/$target_branch"
}

function grshead() {
  git reset --soft HEAD~"$1"
}

function grhhead() {
  git reset --hard HEAD~"$1"
}

function gunstage() {
  git reset HEAD~"$1"
}

function gpsbuild() {
  local tag="build-$(date +%Y%m%d%H%M%S)"
  git tag $tag
  git push origin $tag
}

function gdelremotebranch() {
  git push origin --delete "$1"
}

function gpushforce_staging() {
  git push --force -u origin staging
}

function gclean() {
  git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -d
}

function reload() {
  source ~/.zshrc
  echo "ZSH configuration reloaded!"
}

export NVM_DIR="$HOME/.nvm"
   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
   [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
# export NVM_DIR="$HOME/.nvm"
# [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# source /Users/bward/.docker/init-zsh.sh || true # Added by Docker Desktop

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Key bindings for terminal
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^U" backward-kill-line

# direnv
eval "$(direnv hook zsh)"
# Auto-Warpify
printf 'P$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh", "uname": "Linux" }}�'

EMB_AC_ZSH_SETUP_PATH=/home/bward/.cache/emb/autocomplete/zsh_setup && test -f $EMB_AC_ZSH_SETUP_PATH && source $EMB_AC_ZSH_SETUP_PATH; # emb autocomplete setup

. "$HOME/.local/bin/env"
