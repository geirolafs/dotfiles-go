# ZSH Environment Variables
# This file is sourced on all zsh invocations

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Ensure our custom bin directories are in PATH
typeset -U PATH path
path=(
  "$HOME/.local/bin"
  "$HOME/.local/share/omarchy/bin"
  $path
)
export PATH
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
