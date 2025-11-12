#!/usr/bin/env bash

# Shell environment variables
# Sourced by .zshrc and .bashrc

# Oh My Zsh configuration
export MK_USER_PLUGINS_DIR=$HOME/.mkplugins
export ZSH="$HOME/.oh-my-zsh"

# Terminal and browser (Linux-specific, override in macOS)
export TERMINAL="warp-terminal"
export BROWSER="firefox"

# Editor configuration
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  export VISUAL='vim'
else
  export EDITOR='code'
  export VISUAL='code'
fi

# Git commit editor (needs wait flag for VS Code)
export GIT_EDITOR='code -w'

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# RVM - Add to PATH for scripting (keep this last for PATH changes)
export PATH="$PATH:$HOME/.rvm/bin"
