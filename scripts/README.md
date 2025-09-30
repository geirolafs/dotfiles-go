# Scripts Module

Custom scripts for MacBook Pro on Asahi Linux.

## Contents

### Battery Monitor

**Location:** `.local/bin/battery-monitor`

**Purpose:** Prevents unexpected shutdowns by providing multi-level battery alerts.

**Features:**
- **3-tier alert system:**
  - 🔋 20% or below: Heads-up notification (consider charging)
  - ⚠️  10% or below: Warning notification (charge soon)
  - 🚨 5% or below: Critical alert with sound (plug in immediately)
- Automatic flag management (clears when charging)
- Time-to-empty estimates
- Runs as systemd user service

**Service:**
```bash
# Status
systemctl --user status battery-monitor

# View logs
journalctl --user -u battery-monitor -f

# Restart if needed
systemctl --user restart battery-monitor

# Stop/disable
systemctl --user stop battery-monitor
systemctl --user disable battery-monitor
```

**Configuration:**

Edit thresholds in `/home/go/.local/bin/battery-monitor`:
```bash
readonly CRITICAL_THRESHOLD=5   # Default: 5%
readonly LOW_THRESHOLD=10       # Default: 10%
readonly MEDIUM_THRESHOLD=20    # Default: 20%
```

After editing, restart the service:
```bash
systemctl --user restart battery-monitor
```

### Keyboard Backlight Auto-Control

**Location:** `.local/bin/keyboard-backlight-swayidle.sh`

**Purpose:** Automatically turns off keyboard backlight after 10 seconds of inactivity.

**Features:**
- Auto-off after 10s idle
- Saves brightness level before turning off
- Restores saved brightness on resume
- Configurable timeout and default brightness

**Manual Control:**
```bash
# Set brightness
brightnessctl --device=kbd_backlight set 50%

# Turn off
brightnessctl --device=kbd_backlight set 0

# Reset saved brightness (if auto-restore acts weird)
sudo rm /tmp/kbd_saved_brightness
```

### Sync System Font

**Location:** `.local/bin/sync-system-font`

**Purpose:** Syncs terminal font from Alacritty config to GTK/GNOME settings.

**Usage:**
```bash
sync-system-font
```

Run after changing your Alacritty font to update Nautilus and other GTK apps.

## Installation

Included in `bootstrap.sh` via:
```bash
stow scripts
```

This creates symlinks:
- `~/.local/bin/battery-monitor` → `/home/go/.dotfiles/scripts/.local/bin/battery-monitor`
- `~/.local/bin/keyboard-backlight-swayidle.sh` → `/home/go/.dotfiles/scripts/.local/bin/keyboard-backlight-swayidle.sh`
- `~/.local/bin/sync-system-font` → `/home/go/.dotfiles/scripts/.local/bin/sync-system-font`
- `~/.config/systemd/user/battery-monitor.service` → `/home/go/.dotfiles/scripts/.config/systemd/user/battery-monitor.service`

After stowing, enable the battery monitor:
```bash
systemctl --user daemon-reload
systemctl --user enable --now battery-monitor
```

## Troubleshooting

### Battery notifications not appearing

1. Check service status:
   ```bash
   systemctl --user status battery-monitor
   ```

2. Check logs:
   ```bash
   journalctl --user -u battery-monitor -n 50
   ```

3. Test notifications manually:
   ```bash
   notify-send "Test" "Testing notifications" -u normal
   ```

4. Verify battery device:
   ```bash
   upower -e | grep -i bat
   upower -i /org/freedesktop/UPower/devices/battery_macsmc_battery
   ```

### Keyboard backlight not turning off

1. Check if script is running:
   ```bash
   ps aux | grep keyboard-backlight
   ```

2. Test manual control:
   ```bash
   brightnessctl --device=kbd_backlight set 0
   brightnessctl --device=kbd_backlight set 50%
   ```

3. Restart from autostart (log out/in) or run manually:
   ```bash
   ~/.local/bin/keyboard-backlight-swayidle.sh
   ```

## Mac-Specific Notes

These scripts are optimized for MacBook Pro on Asahi Linux:
- Battery device: `battery_macsmc_battery` (Apple SMC)
- Keyboard backlight device: `kbd_backlight` (Apple keyboard)
- Display backlight: `apple-panel-bl` (use brightnessctl for display)

For more Mac-specific configuration, see `/home/go/.dotfiles/CLAUDE.md`.