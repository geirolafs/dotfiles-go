#!/usr/bin/env bash
set -euo pipefail

# 1) ensure stow is installed (Arch)
if ! command -v stow >/dev/null 2>&1; then
  sudo pacman -S --noconfirm stow
fi

cd "$HOME/.dotfiles"

# 2) stow the modules you want
stow hypr
stow zsh
stow alacritty
stow ghostty
# stow nvim
# stow git

echo "Done. Symlinks created. 🎉"

