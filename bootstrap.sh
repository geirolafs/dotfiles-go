#!/usr/bin/env bash
set -euo pipefail

# 1) ensure stow is installed (Arch)
if ! command -v stow >/dev/null 2>&1; then
  sudo pacman -S --noconfirm stow
fi

cd "$HOME/.dotfiles"

# 2) stow the modules you want
stow hypr
stow waybar
stow zsh
stow alacritty
stow ghostty
stow scripts
stow rclone
stow figma
stow applications
stow yazi
stow gtk
stow systemd
stow mise
stow omarchy
stow zed
stow nvim
# stow git

echo "Done. Symlinks created. 🎉"

