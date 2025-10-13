# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository managed with GNU Stow for symlinking configuration files. It contains configurations for Hyprland, Waybar, Neovim, terminals (Alacritty/Ghostty), and various utilities, designed for the Omarchy distribution running on x86_64.

## Hardware Context

This configuration is optimized for:
- **Device**: iMac 2015 (Intel)
- **Architecture**: x86_64 (Intel 64-bit)
- **OS**: Arch Linux (standard x86_64 kernel)
- **Display**: Multiple display support

This is a desktop workstation configuration without laptop-specific features (no battery monitoring, keyboard backlight, or trackpad workarounds).

## Branch Structure

This repository uses git branches for architecture-specific configurations:
- **`x86_64`** - This branch: iMac Intel desktop configuration
- **`asahi-arm64`** - MacBook Pro M1 Max ARM64 configuration (reference)

Common improvements can be cherry-picked between branches.

## Commands

### Environment Variables

Some scripts require environment variables. These are set in `hypr/.config/hypr/envs.conf` (gitignored).

**Setup:**
```bash
# Copy template to create your local envs.conf
cd ~/.dotfiles/hypr/.config/hypr/
cp envs.conf.example envs.conf

# Edit with your values
nano envs.conf
# Example:
#   env = TERMINAL,ghostty
#   env = IMAC_IP,<your-tailscale-ip>
#   env = IMAC_USER,<your-username>

# Deploy with stow
cd ~/.dotfiles
stow -R hypr

# Reload Hyprland
hyprctl reload
```

**Note:** `envs.conf` is gitignored to keep sensitive values (IPs, usernames) out of version control. Environment variables set here are available to all applications launched from Hyprland.

### Deployment
```bash
# Deploy all dotfiles (creates symlinks in home directory)
./bootstrap.sh

# Deploy specific modules manually
stow hypr waybar nvim    # Deploy multiple modules
stow -D hypr             # Remove Hyprland configs
stow -n hypr             # Test without creating symlinks
stow -R hypr             # Re-stow (remove and recreate symlinks)
```

### Theme Management
```bash
# Switch themes (applies to all apps: Hyprland, terminals, browsers, editors)
omarchy-theme-set <theme-name>

# Available themes: go, go-matt-blk
# Theme files are in omarchy/.local/share/omarchy/themes/
# Current theme symlinked at ~/.config/omarchy/current/theme/
```

### Font Management
The font management system allows selective activation of fonts from a large library stored in Dropbox. Fonts are stored in `~/Dropbox/Sync/Fontfiles/` and activated by creating symlinks in `~/.local/share/fonts/_active/`.

```bash
# List currently activated fonts
font-list-active           # Simple list
font-list-active -v        # Verbose with stats
font-list-active -p        # Show source paths
font-list-active -b        # Find broken symlinks

# Activate fonts (creates symlinks in _active/)
font-activate Inter-4.0                    # Activate Inter font family
font-activate SF-Mono SF-Pro NY            # Activate multiple Apple fonts
font-activate "Foundries/Grilli Type"      # Activate all fonts from foundry
font-activate --refresh Inter-4.0          # Activate and refresh cache
font-activate --dry-run "Foundries/*"      # Preview what would be activated

# Deactivate fonts (removes symlinks)
font-deactivate Inter-4.0              # Deactivate specific font
font-deactivate SF-Mono SF-Pro         # Deactivate multiple fonts
font-deactivate "Switzer*"             # Pattern matching
font-deactivate --all                  # Deactivate all fonts
font-deactivate --refresh Inter-4.0    # Deactivate and refresh cache

# Refresh font cache and restart apps
font-refresh                           # Rebuild cache and restart Obsidian
font-refresh --apps obsidian,discord   # Restart specific apps
font-refresh --skip-apps               # Only rebuild cache
font-refresh --skip-cache              # Only restart apps

# Font library structure
# ~/Dropbox/Sync/Fontfiles/           # Master font library
# ├── Foundries/                      # Commercial foundry fonts
# ├── System/                         # System fonts (Apple, Inter, etc.)
# ├── Trials/                         # Trial/demo fonts
# └── _Active/                        # Empty (lowercase symlink deprecated)
#
# ~/.local/share/fonts/_active/       # Activated fonts (symlinks)
# └── SF-Mono -> ~/Dropbox/Sync/Fontfiles/System/Apple/SF-Mono
```

**Workflow:**
1. Activate fonts: `font-activate Inter-4.0 SF-Mono`
2. Refresh cache and apps: `font-refresh`
3. Restart app manually (e.g., Obsidian) to detect new fonts
4. Check font picker in app - fonts should appear

**Why refresh is needed:**
- fontconfig caches font lists in `~/.cache/fontconfig/`
- Electron apps (Obsidian, VS Code, Discord) cache fonts at startup
- Apps must be restarted after activating fonts to rebuild their internal font lists

**Troubleshooting:**
- If fonts don't appear after refresh, check: `fc-list | grep <font-name>`
- Clean broken symlinks: `font-list-active -b` then remove manually
- Verify activation: `font-list-active -v` shows detailed stats

### Browser Extension Management
Chromium extensions are documented in the dotfiles but cannot be automatically installed. The extension list serves as a reference for setting up browsers on new systems.

```bash
# List currently installed extensions (human-readable)
chromium-list-extensions

# Generate markdown documentation
chromium-list-extensions markdown

# Update extensions.md after installing/removing extensions
chromium-list-extensions markdown > ~/.dotfiles/chromium/.config/chromium/extensions.md

# View documented extensions
cat ~/.dotfiles/chromium/.config/chromium/extensions.md
```

**Extension installation methods:**
1. **Chrome Web Store** (recommended): Visit URLs in `extensions.md` and click "Add to Chrome"
2. **Manual CRX**: Download `.crx` file, enable Developer mode in `chrome://extensions`, drag and drop
3. **Load unpacked** (development): Add `--load-extension=/path/to/extension` to `chromium-flags.conf`

**Extension configuration:**
- Some extensions support exporting settings to JSON
- Store exported settings in `chromium/.config/chromium/extension-settings/`
- Import manually on new systems

**Extension list location:**
- `chromium/.config/chromium/extensions.md` - Documented list with names, IDs, versions, and URLs
- Includes 16 extensions: 1Password, SEO tools (Ahrefs, BuiltWith, Wappalyzer), design tools (CSS Peeper, Stylebot), and developer utilities

### System Utilities
```bash
# Dropbox/cloud storage (via rclone)
dropbox-mount              # Mount Dropbox via rclone
dropbox-unmount            # Unmount Dropbox
dropbox-sync-all           # Sync all Dropbox content
dropbox-sync-fonts         # Sync fonts from Dropbox

# VNC server (for remote access to this iMac)
imac-vnc-start             # Start optimized VNC server
imac-vnc-stop              # Stop VNC and restart hypridle

# Figma with local font access
figma-chromium             # Launch Figma with local font server
figma-setup.sh             # Build and configure figma-agent

# Tailscale diagnostics
tailscale status           # Show all devices on tailnet
tailscale ping <ip>        # Check connection type and latency
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

# Service debugging
systemctl --user list-units --type=service --state=running
journalctl --user -u <service-name> -f
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

### Module Organization

**Core modules**:
- `hypr/` - Hyprland window manager (modular configs: autostart, bindings, input, monitors, looknfeel, windows, envs)
- `waybar/` - Status bar with theme integration
- `nvim/` - Neovim (LazyVim-based) with Claude Code integration
  - Core config: `lua/config/` (lazy.lua, options.lua, keymaps.lua, autocmds.lua)
  - Plugins: `lua/plugins/` (claude-integration, editor-extras, language-extras, theme, web-development, which-key-extras)
- `ghostty/`, `alacritty/` - Terminal emulators (TOML configs)
- `zsh/` - Shell configuration with 1Password CLI shortcuts
- `starship/` - Shell prompt configuration (`.config/starship.toml`)
- `brave/` - Brave browser Wayland flags (`.config/brave-flags.conf`)
- `chromium/` - Chromium browser configuration:
  - Wayland flags (`.config/chromium-flags.conf`)
  - Extension documentation (`.config/chromium/extensions.md`)
  - Extension management utility (`.local/bin/chromium-list-extensions`)

**Utility modules**:
- `omarchy/` - Theme files (`.local/share/omarchy/themes/`) and theme management scripts (`.local/share/omarchy/bin/omarchy-theme-set`)
- `scripts/` - System utilities:
  - `font-activate`, `font-deactivate` - Selective font activation from large library
  - `font-list-active`, `font-refresh` - Font management and cache refresh
  - `imac-vnc-start`, `imac-vnc-stop` - VNC server management
  - `omarchy-launch-wifi`, `omarchy-launch-bluetooth` - Network utilities
  - `twitch-chromium` - Twitch launcher with Chromium
  - `restore-volume.sh` - Volume restoration
  - `remove-duplicate-fonts`, `compare-fontlib` - Font library maintenance
  - `stremio-optimized` - Stremio launcher
  - `theme-showcase`, `ultimate-showcase` - Theme testing utilities
  - `test-mpv-streaming` - MPV streaming test
- `figma/` - Figma launcher with local font server support (figma-agent)
- `rclone/` - Cloud storage (Dropbox) sync via rclone:
  - `dropbox-mount`, `dropbox-unmount` - Mount/unmount operations
  - `dropbox-sync-all`, `dropbox-sync-fonts` - Sync utilities
- `gtk/` - GTK3/4 configurations (bookmarks, mimeapps)
- `systemd/` - User systemd services (figma-agent, dropbox-sync-all timer)
- `yazi/` - Terminal file manager (yazi.toml, keymap.toml)
- `lazygit/` - Git TUI (config.yml placeholder for future customization)
- `lazydocker/` - Docker TUI (config.yml placeholder for future customization)
- `mise/` - Runtime version manager
- `fastfetch/` - System info tool
- `applications/` - .desktop entries for app launcher
- `walker/` - App launcher configuration
- `mpv/` - Media player configuration
- `xcompose/` - X compose key sequences
- `bash/` - Bash shell configuration
- `markdownlint/` - Markdown linter configuration

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
- **Scripts in `bin/`** - can be replaced with symlinks to dotfiles versions (already done for `omarchy-theme-set`)

### What to Never Modify
- `default/` directory - Omarchy-provided defaults, will conflict on updates
- Core configuration structure

### Current Local Modifications (Committed)
1. `themes/everforest/ghostty.conf` - Fixed typo in theme name (if applicable)
2. `bin/omarchy-theme-set` - Replaced with symlink to dotfiles version
3. `.gitignore` - Ignores custom theme symlinks managed in dotfiles

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

### Systemd User Services
Services managed by this dotfiles repo (organized by module):
- `figma/` - `figma-agent.service` + `.socket` - Local font server for Figma
- `rclone/` - `dropbox-sync-all.service` + `.timer` - Periodic Dropbox sync (every 30 minutes)

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

### Figma Font Issues
```bash
# Check figma-agent service
systemctl --user status figma-agent

# Test font server
curl http://localhost:18412/figma/font-files

# Verify fonts are activated
font-list-active -v

# Rebuild figma-agent
cd ~/.dotfiles
./figma-setup.sh
```

### Font Not Appearing
```bash
# Check if font is activated
font-list-active | grep <font-name>

# Activate font if needed
font-activate <font-name>

# Refresh cache and apps
font-refresh

# Verify with fontconfig
fc-list | grep <font-name>
```
