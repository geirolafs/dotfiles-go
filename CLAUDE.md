# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository managed with GNU Stow for symlinking configuration files. Currently contains Hyprland window manager configurations with modular config files for the Omarchy distribution.

## Hardware Context

This configuration is optimized for:
- **Device**: MacBook Pro 16-inch M1 Max (2021)
- **Architecture**: ARM64 (aarch64) running Asahi Linux
- **OS**: Arch Linux with Asahi kernel (6.16.8-asahi)
- **Memory**: 64GB RAM
- **Storage**: 144GB allocated for Linux (dual-boot setup)
- **Display**: Built-in 3456x2160 retina display (eDP-1)

The system uses Asahi Linux, an Arch-based distribution specifically designed for Apple Silicon Macs, with specialized packages for hardware support.

## Commands

### Deployment
```bash
# Deploy all dotfiles (creates symlinks in home directory)
./bootstrap.sh

# Deploy specific modules manually
stow hypr    # Deploy Hyprland configs
stow -D hypr # Remove Hyprland configs

# Test symlink creation without actually creating them
stow -n hypr
```

### Adding New Modules
When adding new dotfile modules:
1. Create a directory for the module (e.g., `zsh/`, `nvim/`)
2. Mirror the exact home directory structure inside (e.g., `zsh/.config/zsh/`)
3. Update `bootstrap.sh` to include the new module in the stow commands

## Architecture

### Stow Structure
- Each top-level directory represents a "stow package" (e.g., `hypr/`)
- Inside each package, recreate the exact directory structure from `$HOME`
- Stow creates symlinks from `~/.config/hypr/` → `~/.dotfiles/hypr/.config/hypr/`

### Hyprland Configuration
The Hyprland configs are split into modular files for Omarchy distribution:
- `autostart.conf` - Services to launch at startup
- `bindings.config` - Keyboard shortcuts and application launchers
- `envs.conf` - Environment variables
- `input.conf` - Keyboard/mouse/touchpad settings
- `looknfeel.conf` - Visual customization (gaps, corners, layouts)
- `monitors.conf` - Display configuration and scaling

These configs integrate with Omarchy-specific utilities:
- `omarchy-launch-*` commands for application launching
- `uwsm app` for Wayland session management
- Web app launchers for various services

## Key Conventions

### Configuration Files
- `.conf` files use Hyprland's config syntax with `key = value` format
- `.config` files follow similar patterns but may have custom bindings
- Comments start with `#` in all config files

### Display Scaling
Monitor configurations default to 2x scaling which is optimal for the MacBook's 3456x2160 retina display, providing an effective workspace of 1728x1080. The monitors.conf includes commented alternatives for external 4K and 1080p displays.