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

### Audio Configuration

Audio uses the `asahi-audio` package (v3.4+) which provides speaker-specific DSP processing via PipeWire filter chains. The configuration includes custom tweaks to address known audio quality issues.

**Known Asahi Audio Issues (upstream bugs):**
- Crackling/popping during audio start/stop and bass transients
- "Trailing audio buffering" when switching sources
- Naive bass enhancement algorithm
- Potential distortion in 200Hz region
- Excessive DSP chain latency

**Custom configuration in this dotfiles repo:**

1. **Reduced PipeWire Quantum** (`pipewire/.config/pipewire/pipewire.conf.d/50-quantum.conf`):
   - Set to 128 frames @ 48kHz (~2.7ms latency) down from default 1024 frames (~21ms)
   - Reduces crackling during audio transitions
   - M1 Max has sufficient CPU headroom for this aggressive setting

2. **EasyEffects Audio Enhancement** (`easyeffects/.config/easyeffects/output/MacBook_Pro_Enhanced.json`):
   - 10-band EQ addressing frequency response issues
   - Notch at 200Hz to reduce documented distortion
   - Enhanced bass (cleaner than Asahi's Bankstown plugin)
   - Reduced harsh treble (8kHz/16kHz)
   - Limiter to smooth transients

3. **Custom DSP Graphs** (`asahi-audio-custom/.local/share/asahi-audio-custom/j316/`):
   - Simplified and minimal graph variants (experimental)
   - Intended to bypass problematic Bankstown bass plugin
   - **Status: May not be loading** - requires sudo to disable system config

**Remaining Issues:**
- Crackling persists despite all optimizations, suggesting deep driver/DSP issue
- May require waiting for upstream Asahi audio improvements
- Alternative: Use headphones/external DAC to bypass onboard DSP entirely

**To disable custom audio config:**
```bash
# Revert to stock Asahi audio
rm ~/.config/wireplumber/wireplumber.conf.d/99-custom-j316-graph.conf
systemctl --user restart wireplumber
```

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

# Check battery status manually
upower -i /org/freedesktop/UPower/devices/battery_macsmc_battery

# Keyboard backlight control
brightnessctl --device=kbd_backlight set 50%
brightnessctl --device=kbd_backlight get
```

### Debugging and Testing
```bash
# Check if configs are properly symlinked
stow -n <package-name>     # Dry run to see what would be linked
ls -la ~/.config/hypr/     # Verify symlinks point to .dotfiles

# Test Hyprland config syntax
hyprctl reload            # Reload config (shows errors if invalid)
hyprctl monitors          # List connected displays
hyprctl clients           # List open windows

# Theme system diagnostics
ls -la ~/.config/omarchy/current/theme/  # Check active theme
readlink ~/.config/omarchy/current/theme # Show theme path
ls ~/.local/share/omarchy/themes/        # List available themes

# Audio debugging
systemctl --user status wireplumber pipewire
pw-top                    # Monitor PipeWire graph
wpctl status             # Check WirePlumber devices

# Service debugging
systemctl --user status battery-monitor
journalctl --user -u battery-monitor -f
systemctl --user list-units --type=service --state=running
```

## Architecture

### Stow Structure
- Each top-level directory is a "stow package" (e.g., `hypr/`, `waybar/`, `nvim/`)
- Inside each package, mirror the exact `$HOME` directory structure
- Stow creates symlinks: `~/.config/hypr/` → `~/.dotfiles/hypr/.config/hypr/`

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
- **Note:** This is a custom replacement for Omarchy's `omarchy-battery-monitor` with enhanced features:
  - 3-tier alerting vs Omarchy's single threshold
  - Continuous monitoring loop vs timer-based polling
  - Asahi-specific battery path vs generic detection
  - Uses `set -euo pipefail` for strict error checking (requires `|| true` on grep commands that may not match)

**Font sync** (`scripts/.local/bin/sync-system-font`):
- Extracts font from Alacritty config and syncs to GTK/GNOME settings
- Supports override via `~/.config/sync-system-font.conf`
- Runs automatically via systemd user service (`systemd/.config/systemd/user/sync-system-font.service`)

### Module Organization

**Core modules**:
- `hypr/` - Hyprland window manager (modular configs: autostart, bindings, input, monitors, looknfeel, windows, envs)
- `waybar/` - Status bar with theme integration
- `nvim/` - Neovim (LazyVim-based) with Claude Code integration
  - Core config: `lua/config/` (lazy.lua, options.lua, keymaps.lua, autocmds.lua)
  - Plugins: `lua/plugins/` (claude-integration, editor-extras, language-extras, theme, web-development, which-key-extras)
- `ghostty/`, `alacritty/` - Terminal emulators (TOML configs)
- `zsh/` - Shell configuration

**Utility modules**:
- `omarchy/` - Theme files (`.local/share/omarchy/themes/`) and theme management scripts (`.local/share/omarchy/bin/omarchy-theme-set`)
- `scripts/` - System utilities:
  - `battery-monitor` - Multi-level battery alerts (20%, 10%, 5%)
  - `sync-system-font` - Alacritty → GTK font sync
  - `keyboard-backlight-swayidle.sh` - Auto-off backlight after 10s idle
  - `omarchy-launch-wifi`, `omarchy-launch-bluetooth` - Network utilities
  - `dropbox-mount`, `dropbox-unmount` - Cloud storage
  - `restore-volume.sh` - Volume restoration
- `figma/` - Figma launcher with Asahi workarounds (trackpad fix, font access)
- `gtk/` - GTK3/4 configurations (bookmarks, mimeapps)
- `systemd/` - User systemd services (battery-monitor, sync-system-font, figma-agent)
- `yazi/` - Terminal file manager (yazi.toml, keymap.toml)
- `rclone/` - Cloud storage sync config
- `mise/` - Runtime version manager
- `fastfetch/` - System info tool
- `applications/` - .desktop entries for app launcher

**Audio modules** (Asahi-specific):
- `pipewire/` - PipeWire config (`.config/pipewire/pipewire.conf.d/50-quantum.conf` - reduced to 128 frames)
- `wireplumber/` - WirePlumber config (`.config/wireplumber/wireplumber.conf.d/`)
- `asahi-audio-custom/` - Custom DSP graphs (`.local/share/asahi-audio-custom/j316/`)
- `easyeffects/` - EasyEffects presets (`.config/easyeffects/output/MacBook_Pro_Enhanced.json`)
- `sync-system-font/` - Font sync service configs

### Adding New Modules

1. Create directory: `mkdir -p <module>/.config/<module>/`
2. Add config files mirroring home structure
3. Add to `bootstrap.sh` stow commands
4. For theme support: add theme file to each theme in `omarchy/.local/share/omarchy/themes/*/`

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

## Configs Outside Dotfiles Management

Some configurations are intentionally **not** managed by this dotfiles repo:

### Application State/Cache (Never Track)
- Browser profiles: `~/.config/{chromium,Brave,discord,obsidian}` - contain auth tokens, cache
- 1Password, Typora, font-manager - contain app-specific state
- Application-specific databases and credentials

### System-Provided Configs (Omarchy-Managed)
These are provided by Omarchy and should not be duplicated in dotfiles:
- `~/.config/environment.d/fcitx.conf` - Input method config
- `~/.config/environment.d/flatpak.conf` - Flatpak app discovery
- `~/.config/{hypr/hypridle.conf,hypr/hyprlock.conf,hypr/hyprsunset.conf}` - Omarchy defaults

### User Configs Intentionally Outside Dotfiles
- `~/.config/git/config` - Contains personal email/name (privacy)
- `~/.config/gh/` - GitHub CLI with personal tokens
- `~/.config/btop/btop.conf` - Auto-generated, frequently changes
- `~/.config/walker/config.toml` - Omarchy-provided, may be customized
- `~/.config/swayosd/` - Omarchy-provided OSD settings
- `~/.config/kitty/kitty.conf` - Terminal config (using Ghostty primarily)

**Note:** If you customize any of these heavily, consider adding them to the dotfiles repo.

## Omarchy Local Modifications Strategy

The Omarchy installation at `~/.local/share/omarchy` is a git repo. Local modifications:

### What's Safe to Modify
- **Theme files** - but better to create custom themes in `~/.dotfiles/omarchy/.local/share/omarchy/themes/`
- **Scripts in `bin/`** - can be replaced with symlinks to dotfiles versions (already done for `omarchy-theme-set`, `omarchy-cmd-screenrecord`)

### What to Never Modify
- `default/` directory - Omarchy-provided defaults, will conflict on updates
- Core configuration structure

### Current Local Modifications (Committed)
1. `default/hypr/envs.conf` - Added `VK_ICD_FILENAMES` for ARM64 walker support
2. `themes/everforest/ghostty.conf` - Fixed typo in theme name
3. `bin/omarchy-theme-set` - Replaced with symlink to dotfiles version
4. `bin/omarchy-cmd-screenrecord` - Replaced with symlink to dotfiles version
5. `.gitignore` - Ignores custom theme symlinks managed in dotfiles

### Update Strategy
When running Omarchy updates (`omarchy-update`):
1. Committed changes will be preserved or create merge conflicts
2. Resolve conflicts by keeping customizations when needed
3. Custom theme symlinks are ignored and won't conflict

## Important Constraints

### Stow Package Isolation
When modifying configuration files:
1. **Never edit files in `~/.local/share/omarchy/default/`** - these are Omarchy-provided defaults
2. **Always edit files within their stow package directories** (e.g., `hypr/.config/hypr/`, not `~/.config/hypr/`)
3. **After editing, re-stow the package**: `stow -R <package-name>` to update symlinks
4. Changes to theme files go in `omarchy/.local/share/omarchy/themes/<theme-name>/`

### Theme Configuration Layer Priority
When a setting appears in multiple places, the priority order is:
1. User overrides in `~/.config/<app>/` (this dotfiles repo) - **highest priority**
2. Theme layer at `~/.config/omarchy/current/theme/` (symlink to active theme)
3. Omarchy defaults at `~/.local/share/omarchy/default/<app>/` - **lowest priority**

### Audio Configuration Warnings
- Custom audio configs require root privileges to fully override system configs
- Test audio changes carefully - crackling issues may persist despite optimizations
- Always keep backup of working audio configuration before experimenting
- Revert to stock: `rm ~/.config/wireplumber/wireplumber.conf.d/99-custom-j316-graph.conf && systemctl --user restart wireplumber`

### Systemd User Services
Services managed by this dotfiles repo:
- `battery-monitor.service` - Battery level alerts
- `sync-system-font.service` + `.path` - Automatic font synchronization
- `figma-agent.service` - Local font server for Figma

After modifying service files:
```bash
systemctl --user daemon-reload
systemctl --user restart <service-name>
```

### Waybar Script Changes
**Important:** When modifying scripts that Waybar calls (like `omarchy-launch-wifi`, `omarchy-launch-bluetooth`), you **must restart Waybar** to clear its cache:

```bash
killall waybar && waybar &
# Or use Hyprland reload (restarts all components)
hyprctl reload
```

Scripts called by Waybar's `on-click`:
- `omarchy-launch-wifi` - WiFi manager (Impala in Alacritty)
- `omarchy-launch-bluetooth` - Bluetooth manager
- Any custom Waybar module scripts

## Troubleshooting

### Symlinks Not Working
```bash
# Check stow conflicts
stow -n <package-name>  # Shows what would be linked
stow -D <package-name>  # Remove existing links
stow <package-name>     # Re-create links

# Common issues:
# 1. File exists but isn't a symlink - manually remove it first
# 2. Parent directory doesn't exist - create it: mkdir -p ~/.config/<app>
```

### Hyprland Config Errors
```bash
# Check syntax errors
hyprctl reload  # Shows error messages in terminal

# Find which config file has the error
hyprctl version
hyprctl getoption <option-name>

# Reset to defaults
mv ~/.config/hypr ~/.config/hypr.backup
stow -R hypr
```

### Theme Not Applying
```bash
# Verify theme symlink
readlink ~/.config/omarchy/current/theme
# Should point to: ~/.local/share/omarchy/themes/<theme-name>

# Re-apply theme
omarchy-theme-set <theme-name>

# Manual theme reload
hyprctl reload
killall waybar && waybar &
makoctl reload
```

### Audio Issues (Crackling/No Sound)
```bash
# Check PipeWire/WirePlumber status
systemctl --user status pipewire wireplumber
pw-top  # Monitor graph (q to quit)

# Restart audio stack
systemctl --user restart pipewire wireplumber

# Revert to stock Asahi audio
rm ~/.config/wireplumber/wireplumber.conf.d/99-custom-j316-graph.conf
rm ~/.config/pipewire/pipewire.conf.d/50-quantum.conf
systemctl --user restart wireplumber pipewire

# Check audio devices
wpctl status
pactl list sinks
```

### Battery Monitor Not Working
```bash
# Verify service is running
systemctl --user status battery-monitor

# Check logs
journalctl --user -u battery-monitor -n 50

# Test UPower access
upower -e  # List power devices
upower -i /org/freedesktop/UPower/devices/battery_macsmc_battery

# Manually trigger notification test
notify-send "Test" "Battery notification test" -u critical
```

**Common issue: Crash loop when battery is charging**

If you see rapid restarts in logs (service exiting immediately):
```bash
# Check restart counter in service status
systemctl --user status battery-monitor
# If restart counter is high (100+), the script is crash-looping

# Root cause: grep fails when "time to empty" field doesn't exist (battery charging)
# Solution: Ensure get_time_to_empty() has || true:
grep -E "time to empty" ... || true

# This was fixed in commit adding || true to line 56
# Service should run continuously with 30s sleep cycles
```

### Figma Font/Trackpad Issues
```bash
# Check figma-agent service
systemctl --user status figma-agent

# Test font server
curl http://localhost:18412/figma/font-files

# Verify fonts in system directory
ls /usr/share/fonts/TTF/

# Check trackpad setting
hyprctl getoption input:touchpad:disable_while_typing

# Use basic launcher (no trackpad fix)
figma-chromium
```