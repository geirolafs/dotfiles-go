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
stow zed
stow nvim
stow starship
stow brave
# stow git

# Special handling for Zed settings.json - copy instead of symlink
# (Zed's file watcher doesn't work properly with symlinked settings)
if [ -L "$HOME/.config/zed/settings.json" ]; then
  ZED_SETTINGS_TARGET=$(readlink -f "$HOME/.config/zed/settings.json")
  rm "$HOME/.config/zed/settings.json"
  cp "$ZED_SETTINGS_TARGET" "$HOME/.config/zed/settings.json"
  chmod 600 "$HOME/.config/zed/settings.json"
  echo "  → Zed settings.json copied (not symlinked) for hot-reload compatibility"
fi

echo "Done. Symlinks created. 🎉"

