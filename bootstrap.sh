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
stow fastfetch
stow ghostty
stow scripts
stow rclone
stow figma
stow applications
stow yazi
stow gtk
stow systemd
stow pipewire
stow wireplumber
stow asahi-audio-custom
stow easyeffects
stow sync-system-font
stow mise
stow omarchy
stow nvim
stow starship
stow brave
stow chromium
stow lazygit
stow lazydocker
# stow git

echo "Done. Symlinks created. 🎉"

