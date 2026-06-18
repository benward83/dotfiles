# ============================================
# Powerlevel10k instant prompt
# ============================================
# Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# ============================================
# Oh-my-zsh
# ============================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  node
  npm
  nvm
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Syntax highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
ZSH_HIGHLIGHT_PATTERNS+=("git*" fg=yellow,bold)
ZSH_HIGHLIGHT_PATTERNS+=("cd" fg=green,bold)
ZSH_HIGHLIGHT_PATTERNS+=("pnpm" fg=green,bold)
ZSH_HIGHLIGHT_PATTERNS+=("npm" fg=green,bold)
ZSH_HIGHLIGHT_PATTERNS+=("node" fg=green,bold)

# ============================================
# Environment
# ============================================

# Editor (vim over SSH, VS Code locally)
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  export VISUAL='vim'
else
  export EDITOR='code'
  export VISUAL='code'
fi
export GIT_EDITOR='code -w'

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# FZF
export FZF_DEFAULT_OPTS="--bind 'ctrl-o:execute(code {})+abort'"

# ============================================
# Secrets (machine-local, not tracked)
# ============================================

[[ -f ~/.secrets ]] && source ~/.secrets

# ============================================
# General aliases
# ============================================

alias claude-config='code ~/.claude/CLAUDE.md'
alias zshrc='code ~/.zshrc'
alias embk="emb kubernetes"

# ============================================
# Git aliases
# ============================================

# Status / diff / log
alias gss="git status"
alias gd="git diff"
alias gline="git log --oneline"
alias gflog="git reflog --date=format:'%Y-%m-%d %H:%M' --pretty"

# Add
alias ga="git add"
alias gaa="git add ."
alias gap="git add -p"

# Branch / checkout / switch
alias gb="git branch"
alias gch="git checkout"
alias gcb="git checkout -b"
alias gsw="git switch"

# Pull / push / fetch / remote
alias gpl="git pull"
alias gprb="git pull --rebase"
alias gps="git push"
alias gpf="git push --force"
alias gpfl="git push --force-with-lease"
alias gfa="git fetch --all --prune"
alias gru="git remote update"
alias gcmrd="git push -o merge_request.draft"
alias gcmr="git push -o merge_request.create"

# Stash
alias gst="git stash"
alias gstp="git stash pop"
alias gstc="git stash clear"

# Reset
alias ghead="git reset HEAD~"
alias grbsplit="git reset HEAD^"

# Rebase
alias grbc="git rebase --continue"
alias grba="git rebase --abort"

# Amend
alias gamend="git commit --amend -m"
alias gamnoed="git commit --amend --no-edit"

# Worktree
alias gwtl="git worktree list"
alias gwta="git worktree add"
alias gwtr="git worktree remove"
alias gwtp="git worktree prune"

# ============================================
# Git functions
# ============================================

git_default_branch() {
  local ref
  ref=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null) \
    && { echo "${ref#origin/}"; return 0; }
  ref=$(git ls-remote --symref origin HEAD 2>/dev/null \
        | awk '/^ref:/{sub("refs/heads/","",$2); print $2; exit}')
  [ -n "$ref" ] && { echo "$ref"; return 0; }
  local b
  for b in main staging master; do
    git show-ref --verify --quiet "refs/remotes/origin/$b" && { echo "$b"; return 0; }
  done
  return 1
}

grbi() { git rebase -i "origin/$(git_default_branch)"; }

grw() {
  local default count target
  default=$(git_default_branch)
  echo "Commits ahead of origin/$default:"
  git log --oneline "origin/$default"..HEAD | nl

  if [[ -n "$1" ]]; then
    target="HEAD~$1"
  else
    echo
    read "count?How many to rebase (blank = all ahead of origin/$default)? "
    if [[ -z "$count" ]]; then
      target="origin/$default"
    else
      target="HEAD~$count"
    fi
  fi

  GIT_SEQUENCE_EDITOR="nano" GIT_EDITOR="nano" EDITOR="nano" git rebase -i "$target"
}

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

function gstaging() {
  local branch="${1:-main}"
  git push origin "$branch":staging --force-with-lease
}

function gclean() {
  git fetch --prune
  git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -d
}

function gbranch() {
  git branch -D "$1"
}

# Coverseal-aware commit (prefixes with [Module])
function gcm() {
  local msg="$*"
  if [ -z "$msg" ]; then
    echo "Usage: gcm <message>"
    return 1
  fi

  local staged=$(git diff --cached --name-only 2>/dev/null)
  if [ -z "$staged" ]; then
    echo "Nothing staged. Stage files first with ga."
    return 1
  fi

  local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ "$repo_root" != *"Work/Enspirit/coverseal"* ]]; then
    git commit -m "$msg"
    return $?
  fi

  local module=""
  local -a detected=()

  if echo "$staged" | grep -q "views/smc/\|stores/smc\|models/smc\|utils/smc\|/smc[A-Z]"; then
    detected+=("SMC")
  fi
  if echo "$staged" | grep -q "^dbagent/"; then
    detected+=("dbagent")
  fi
  if echo "$staged" | grep -q "^webspicy/"; then
    detected+=("Webspicy")
  fi
  if echo "$staged" | grep -q "^helm/"; then
    detected+=("Helm")
  fi
  if echo "$staged" | grep -q "\.kiln\.yml"; then
    detected+=("CI")
  fi
  if echo "$staged" | grep -q "^frontend/packages/"; then
    detected+=("Pkg")
  fi
  if echo "$staged" | grep -q "services/mobile/"; then
    detected+=("Mobile")
  fi
  if echo "$staged" | grep -q "^e2e/"; then
    detected+=("E2E")
  fi
  if echo "$staged" | grep -q "^kong/\|^emb/"; then
    detected+=("Emb")
  fi
  if echo "$staged" | grep -q "^\.kiln\|^kiln/"; then
    detected+=("Kiln")
  fi

  if [ ${#detected[@]} -eq 1 ]; then
    module="${detected[1]}"
  elif [ ${#detected[@]} -gt 1 ]; then
    module=$(printf '%s\n' "*" "${detected[@]}" | fzf --prompt="Multiple modules detected. Pick (* for all): " --height=15 --reverse | head -1)
  else
    local all_modules=("*" "SMC" "Pkg" "Helm" "CI" "Webspicy" "dbagent" "Emb" "E2E" "Mobile" "Kiln")
    module=$(printf '%s\n' "${all_modules[@]}" | fzf --prompt="Module (* for all): " --height=15 --reverse)
  fi

  [ -z "$module" ] && return 1

  git commit -m "[$module] $msg"
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

# ============================================
# Kubectl functions
# ============================================

function kwatch() {
  kubectl get pods -n "$1" --watch
}

function kscale() {
  if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
    echo "Usage: kscale <service> <replicas> <env>"
    echo "Example: kscale studio 1 stg-coverseal"
    return 1
  fi
  kubectl scale deployment/"$1" --replicas="$2" -n "$3"
}

function kmigrate() {
  if [[ -z "$1" ]]; then
    echo "Usage: kmigrate <env>"
    echo "Example: kmigrate stg-coverseal"
    return 1
  fi
  kscale dbagent 1 "$1"
  echo "Waiting for dbagent pod to be ready..."
  kubectl wait --for=condition=available deployment/dbagent -n "$1" --timeout=120s
  kubectl exec -it deployment/dbagent -n "$1" -- bundle exec rake db:migrate
  kscale dbagent 0 "$1"
}

function kscale-status() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: kscale-status <service> <env>"
    echo "Example: kscale-status studio stg-coverseal"
    return 1
  fi
  kubectl get deployment/"$1" -n "$2" -o jsonpath='{.spec.replicas}' && echo " replica(s)"
}

# ============================================
# Docker Sandbox
# ============================================

alias dsb="docker sandbox run claude"
alias dsls="docker sandbox ls"
alias dsrm="docker sandbox rm"

# ============================================
# Shell utilities
# ============================================

function reload() {
  source ~/.zshrc
  echo "ZSH configuration reloaded!"
}

# ============================================
# Project shortcuts
# ============================================

# Coverseal
function dbsync() {
  emb db.migrate --verbose && emb db.base && emb db.gen.types
}

# OpenClaw (Hetzner)
openclaw() {
  local server="${HETZNER_SSH:?Set HETZNER_SSH in zshrc.local}"
  local remote="sudo bash -c 'cd /root/openclaw && docker compose"
  case "$1" in
    start)   ssh $server "$remote up -d'" ;;
    stop)    ssh $server "$remote down'" ;;
    restart) ssh $server "$remote down && cd /root/openclaw && docker compose up -d'" ;;
    status)  ssh $server "$remote ps'" ;;
    logs)    ssh $server "$remote logs --tail 100 ${2:---all}'" ;;
    deploy)
      scp ~/openclaw-setup/docker-compose.yml $server:/tmp/ && \
      ssh $server "sudo bash -c 'cp /tmp/docker-compose.yml /root/openclaw/ && cd /root/openclaw && docker compose down && docker compose up -d' && rm /tmp/docker-compose.yml"
      ;;
    deploy-pipe)
      python3 ~/openclaw-setup/deploy-function.py
      ;;
    deploy-jobs)
      scp ~/openclaw-setup/daily-job-search.py $server:/tmp/ && \
      ssh $server "sudo cp /tmp/daily-job-search.py /root/openclaw/daily-job-search.py && sudo chmod +x /root/openclaw/daily-job-search.py && rm /tmp/daily-job-search.py" && \
      echo "Job search script deployed."
      ;;
    run-jobs)
      ssh $server "sudo python3 /root/openclaw/daily-job-search.py" && \
      echo "Job search triggered. Check log:" && \
      ssh $server "sudo tail -5 /var/log/daily-job-search.log"
      ;;
    jobs-log)
      ssh $server "sudo tail -${2:-20} /var/log/daily-job-search.log"
      ;;
    *)
      if type _openclaw_ext &>/dev/null; then
        _openclaw_ext "$@"
        return
      fi
      echo "Usage: openclaw {start|stop|restart|status|logs [container]|deploy|deploy-pipe|deploy-jobs|run-jobs|jobs-log}"
      ;;
  esac
}

# Alice's website
alice() {
  local server="${HETZNER_SSH:?Set HETZNER_SSH in zshrc.local}"
  local remote="sudo bash -c 'cd /opt/alices-website && docker compose -f docker-compose.prod.yml"
  case "$1" in
    start)   ssh $server "$remote up -d'" ;;
    stop)    ssh $server "$remote down'" ;;
    restart) ssh $server "$remote down && cd /opt/alices-website && docker compose -f docker-compose.prod.yml up -d'" ;;
    build)   ssh $server "$remote up -d --build'" ;;
    deploy)  ssh $server "cd /opt/alices-website && git pull && sudo docker compose -f docker-compose.prod.yml up -d --build" ;;
    status)  ssh $server "$remote ps'" ;;
    logs)    ssh $server "$remote logs --tail 100 ${2:---all}'" ;;
    dev)
      local dir=~/Work/Projects/alices-website
      docker compose -f "$dir/docker-compose.dev.yml" up -d && (cd "$dir" && pnpm dev)
      ;;
    *)
      echo "Usage: alice {start|stop|restart|build|deploy|dev|status|logs [container]}"
      ;;
  esac
}

# Ledgerbridge
lb() {
  local dir=~/Work/Projects/ledgerbridge
  case "$1" in
    up)      (cd "$dir" && docker compose up "${@:2}") ;;
    down)    (cd "$dir" && docker compose down "${@:2}") ;;
    reset)   (cd "$dir" && docker compose down -v && docker compose up "${@:2}") ;;
    status)  (cd "$dir" && docker compose ps) ;;
    logs)    (cd "$dir" && docker compose logs --tail 100 ${2:---all} -f) ;;
    test)    (cd "$dir/api" && ~/.local/bin/uv run pytest tests/ -v "${@:2}") ;;
    lint)    (cd "$dir/api" && ~/.local/bin/uv run ruff check app/) ;;
    migrate) (cd "$dir/api" && ~/.local/bin/uv run alembic upgrade head) ;;
    *)
      echo "Usage: lb {up|down|reset|status|logs [container]|test|lint|migrate}"
      ;;
  esac
}

# ============================================
# Key bindings
# ============================================

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^U" backward-kill-line

# ============================================
# Powerlevel10k theme config
# ============================================

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ============================================
# Platform-specific
# ============================================

if [[ "$(uname)" == "Darwin" ]]; then
  # macOS
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  command -v rbenv &>/dev/null && eval "$(rbenv init - zsh)"
  export CLOUDSDK_PYTHON=/opt/homebrew/bin/python3.12
else
  # Linux
  export TERMINAL="ghostty"
  export BROWSER="firefox"
  alias open='xdg-open'
  [[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"
  EMB_AC_ZSH_SETUP_PATH="$HOME/.cache/emb/autocomplete/zsh_setup" && test -f "$EMB_AC_ZSH_SETUP_PATH" && source "$EMB_AC_ZSH_SETUP_PATH"
fi

# ============================================
# Local overrides
# ============================================

for _zl in ~/Documents/{Me,"Obsidian Vault"}/Clive/OpenClaw/zshrc.local; do
  [ -f "$_zl" ] && source "$_zl" && break
done
unset _zl

# ============================================
# direnv
# ============================================

command -v direnv &>/dev/null && eval "$(direnv hook zsh)"
