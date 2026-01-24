# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  node
  npm
  nvm
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Syntax highlighting configuration
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
ZSH_HIGHLIGHT_PATTERNS+=("git*" fg=yellow,bold)
ZSH_HIGHLIGHT_PATTERNS+=("cd" fg=green,bold)
ZSH_HIGHLIGHT_PATTERNS+=("pnpm" fg=green,bold)
ZSH_HIGHLIGHT_PATTERNS+=("npm" fg=green,bold)
ZSH_HIGHLIGHT_PATTERNS+=("node" fg=green,bold)

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  export VISUAL='vim'
else
  export EDITOR='code'
  export VISUAL='code'
fi

# Git commit editor (needs wait flag)
export GIT_EDITOR='code -w'

# ============================================
# Aliases
# ============================================

alias claude-config='code ~/.claude/CLAUDE.md'
alias zshrc='code ~/.zshrc'
alias embk="emb kubernetes"

# Git
alias gch="git checkout"
alias gcb="git checkout -b"
alias gsw="git switch"
alias gpl="git pull"
alias gps="git push"
alias gpf="git push --force"
alias gpfl="git push --force-with-lease"
alias ga="git add"
alias gaa="git add ."
alias gcm="git commit -m"
alias gss="git status"
alias gprb="git pull --rebase"
alias gst="git stash"
alias gstp="git stash pop"
alias gstc="git stash clear"
alias gfa="git fetch --all --prune"
alias gd="git diff"
alias gru="git remote update"
alias ghead="git reset HEAD~"
alias gline="git log --oneline"
alias gflog="git reflog --date=format:'%Y-%m-%d %H:%M' --pretty"
alias gap="git add -p"
alias grbi="git rebase -i origin/main"
alias grbc="git rebase --continue"
alias grba="git rebase --abort"
alias gamend="git commit --amend -m"
alias gamnoed="git commit --amend --no-edit"
alias gcmrd="git push -o merge_request.draft"
alias gcmr="git push -o merge_request.create"
alias grbsplit="git reset HEAD^"

# ============================================
# Git functions
# ============================================

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

# ============================================
# Kubectl aliases
# ============================================

alias k='kubectl'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kgn='kubectl get nodes'
alias kgi='kubectl get ingress'

alias kd='kubectl describe'
alias kdp='kubectl describe pod'
alias kds='kubectl describe service'
alias kdd='kubectl describe deployment'

alias kdel='kubectl delete'
alias kdelp='kubectl delete pod'

alias kl='kubectl logs'
alias klf='kubectl logs -f'

alias kex='kubectl exec -it'
alias kpf='kubectl port-forward'

# Context switching
alias kctx='kubectl config get-contexts'
alias kuse='kubectl config use-context'
alias kcurrent='kubectl config current-context'

# Namespace shortcuts
alias kn='kubectl config set-context --current --namespace'
alias kgns='kubectl get namespaces'

# Watch commands
alias kgpw='kubectl get pods --watch'

# ============================================
# NVM
# ============================================

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ============================================
# FZF
# ============================================

export FZF_DEFAULT_OPTS="--bind 'ctrl-o:execute(code {})+abort'"

# ============================================
# Key bindings
# ============================================

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^U" backward-kill-line

# ============================================
# Powerlevel10k
# ============================================

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# ============================================
# Platform-specific configuration
# ============================================

if [[ "$(uname)" == "Darwin" ]]; then
  # macOS
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  command -v rbenv &>/dev/null && eval "$(rbenv init - zsh)"
else
  # Linux
  export TERMINAL="warp-terminal"
  export BROWSER="firefox"
  alias open='xdg-open'
  command -v direnv &>/dev/null && eval "$(direnv hook zsh)"
  [[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"
  EMB_AC_ZSH_SETUP_PATH="$HOME/.cache/emb/autocomplete/zsh_setup" && test -f "$EMB_AC_ZSH_SETUP_PATH" && source "$EMB_AC_ZSH_SETUP_PATH"
fi
