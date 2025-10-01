# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository managed with GNU Stow for symlinking configuration files. It contains configurations for Hyprland, Waybar, Neovim, terminals (Alacritty/Ghostty), and various utilities, designed for the Omarchy distribution running on Asahi Linux (Apple Silicon).

## Hardware Context

This configuration is optimized for:
- **Device**: MacBook Pro 16-inch M1 Max (2021)
- **Architecture**: ARM64 (aarch64) running Asahi Linux
- **OS**: Arch Linux with Asahi kernel (6.16.8-asahi)
- **Memory**: 64GB RAM
- **Display**: Built-in 3456x2160 retina display (eDP-1) at 2x scaling

The system uses Asahi Linux, an Arch-based distribution specifically designed for Apple Silicon Macs. Several modules contain workarounds for ARM64/Asahi-specific issues.

## Kernel and Driver Status

### Asahi vs Mainline Kernels

This system **must use Asahi-specific kernel packages** (linux-asahi), not mainline/vanilla Linux kernels. The Asahi kernel contains approximately 1,000 downstream patches not yet in upstream Linux, including critical drivers for GPU, audio, and power management.

**Never install mainline kernels from kernel.org or compile custom kernels** - this will break GPU acceleration and many other features. Always update through the distribution package manager:

```bash
# Correct update method (Arch-based Asahi)
sudo pacman -Syu

# Fedora Asahi Remix
dnf upgrade --refresh
```

The Asahi team backports upstream improvements into their kernel releases. When mainline features like the Linux 6.17 SMC driver are announced, they're typically already integrated into Asahi kernels through backporting. Official Asahi releases lag mainline by design to ensure stability and full hardware support.

### GPU Acceleration Status

GPU acceleration is **fully functional** through Asahi's out-of-tree driver, providing conformant OpenGL 4.6, OpenGL ES 3.2, and Vulkan 1.4 support. This driver is not in mainline Linux and won't be until Rust language support is complete in the kernel (estimated 2026 or later).

**Current capabilities:**
- Full desktop compositing (Wayland/X11)
- Hardware-accelerated rendering in applications
- Gaming via FEX + Wine + DXVK translation layers
- Professional applications (Blender, CAD tools)

**Current limitations:**
- No hardware video decode/encode acceleration (software decode works)
- Driver remains downstream/out-of-tree

Device tree bindings for the M1 Max GPU were stabilized in Linux 6.17 (September 2025), providing infrastructure for future upstreaming, but the actual driver integration is a separate multi-year effort.

### Battery Monitoring Integration

The battery monitoring script uses UPower with a stable device path that persists across kernel updates:

```bash
# Stable paths - do not change with kernel versions
/org/freedesktop/UPower/devices/battery_macsmc_battery  # UPower device
/sys/class/power_supply/macsmc-battery/                 # sysfs interface
```

No modifications needed to the battery-monitor script during normal system updates. The macsmc_power driver has been in Asahi kernels since 6.3 and is stable.

**Known quirk:** UPower calculates watt-hour (Wh) values using minimum voltage instead of nominal voltage, showing ~41-42 Wh for a 52.6 Wh battery at 80% charge limit. This doesn't affect percentage readings or alert thresholds (20%, 10%, 5%), which work correctly.

### Future Mainline Migration

Full mainline kernel support for all Apple Silicon features is projected for 2026-2027. Major milestones: Apple SMC driver merged (September 2025), GPU driver upstreaming dependent on Rust infrastructure (2026+). Continue using linux-asahi packages exclusively until the Asahi team announces mainstream kernel viability.

## Commands

### Deployment
```bash
# Deploy all dotfiles (creates symlinks in home directory)
./bootstrap.sh

# Deploy specific modules manually
stow hypr waybar nvim    # Deploy multiple modules
stow -D hypr             # Remove Hyprland configs
stow -n hypr             # Test without creating symlinks
```

### Theme Management
```bash
# Switch themes (applies to all apps: Hyprland, terminals, browsers, editors)
omarchy-theme-set <theme-name>

# Theme files are in omarchy/.local/share/omarchy/themes/
# Current theme symlinked at ~/.config/omarchy/current/theme/
```

### System Font Sync
```bash
# Sync terminal font to GTK/GNOME (runs automatically via systemd user service)
sync-system-font

# Override config at ~/.config/sync-system-font.conf
```

### Asahi-Specific Utilities
```bash
# Figma with trackpad workarounds (disables "disable_while_typing" for space bar hand tool)
figma-chromium-trackpad-fix

# Battery monitoring with multi-level alerts
battery-monitor
```

## Architecture

### Stow Structure
- Each top-level directory is a "stow package" (e.g., `hypr/`, `waybar/`, `nvim/`)
- Inside each package, mirror the exact `$HOME` directory structure
- Stow creates symlinks: `~/.config/hypr/` → `~/.dotfiles/hypr/.config/hypr/`
- **Exception**: Zed's `settings.json` is copied (not symlinked) for hot-reload compatibility

### Omarchy Integration
The configuration uses Omarchy's layered config system:

1. **Base defaults**: `~/.local/share/omarchy/default/` (Omarchy-provided, don't edit)
2. **Theme layer**: `~/.config/omarchy/current/theme/` (symlink to active theme)
3. **User overrides**: `~/.config/hypr/`, `~/.config/waybar/`, etc. (this dotfiles repo)

Hyprland sources configs in this order:
```bash
# From hypr/.config/hypr/hyprland.conf
source = ~/.local/share/omarchy/default/hypr/*.conf  # Base defaults
source = ~/.config/omarchy/current/theme/hyprland.conf  # Theme
source = ~/.config/hypr/*.conf  # User overrides (highest priority)
```

### Theme System
Themes are stored in `omarchy/.local/share/omarchy/themes/<theme-name>/`:
- Each theme contains config files for multiple applications (Hyprland, Waybar, terminals, browsers, editors)
- `omarchy-theme-set` creates a symlink at `~/.config/omarchy/current/theme/` pointing to the active theme
- Theme changes trigger restarts of Waybar, SwayOSD, Hyprland reload, and apply to browsers/editors via helper scripts

### Asahi Linux Workarounds

**Figma trackpad fix** (`figma/.local/bin/figma-chromium-trackpad-fix`):
- Temporarily disables `disable_while_typing` in Hyprland input config
- Allows space bar hand tool to work with trackpad gestures
- Restores original config on exit using trap cleanup
- Uses Windows user agent to bypass Figma's Linux blocking

**Battery monitor** (`scripts/.local/bin/battery-monitor`):
- Uses UPower to monitor `/org/freedesktop/UPower/devices/battery_macsmc_battery`
- Multi-level alerts (20%, 10%, 5%) with persistent flags in `/run/user/$UID`
- Prevents unexpected shutdowns on MacBook hardware

**Font sync** (`scripts/.local/bin/sync-system-font`):
- Extracts font from Alacritty config and syncs to GTK/GNOME settings
- Supports override via `~/.config/sync-system-font.conf`
- Runs automatically via systemd user service (`systemd/.config/systemd/user/sync-system-font.service`)

### Module Organization

**Core modules**:
- `hypr/` - Hyprland window manager (modular configs: autostart, bindings, input, monitors, etc.)
- `waybar/` - Status bar with theme integration
- `nvim/` - Neovim with Claude Code integration plugin (`lua/plugins/claude-integration.lua`)
- `ghostty/`, `alacritty/` - Terminal emulators
- `zsh/` - Shell configuration

**Utility modules**:
- `omarchy/` - Theme files and theme management scripts
- `scripts/` - System utilities (battery-monitor, sync-system-font, keyboard backlight)
- `figma/` - Figma launcher with Asahi workarounds
- `gtk/` - GTK3/4 configurations
- `systemd/` - User systemd services

### Adding New Modules

1. Create directory: `mkdir -p <module>/.config/<module>/`
2. Add config files mirroring home structure
3. Add to `bootstrap.sh` stow commands
4. For theme support: add theme file to each theme in `omarchy/.local/share/omarchy/themes/*/`
5. If Zed-like hot reload issues exist, add copy logic to `bootstrap.sh`

## Key Conventions

### Configuration Syntax
- Hyprland `.conf` files: `key = value` with `#` comments
- TOML files (Alacritty, Ghostty): TOML syntax
- Lua files (Neovim): LazyVim plugin specifications

### Display Scaling
- Default: 2x scaling for 3456x2160 retina display (effective 1728x1080 workspace)
- Monitor configs in `hypr/.config/hypr/monitors.conf` with commented alternatives for external displays

### Neovim Claude Integration
Keybindings in `nvim/.config/nvim/lua/plugins/claude-integration.lua`:
- `<leader>ac` - Toggle Claude Code panel
- `<leader>ab` - Add current buffer to context
- `<leader>as` - Send selection to Claude (visual mode)
- `<leader>aa` - Accept diff
- Split configured at 30% width on right side