# Figma Font Helper for Asahi Linux

A complete solution for using Figma with local fonts on Asahi Linux (ARM64).

## Problem Solved

- **Local fonts not visible in Figma web app** - Figma blocks Linux user agents from accessing local fonts
- **Space bar hand tool not working** - Hyprland's "disable while typing" setting blocks trackpad during space key press
- **Cursor scaling issues** - DPI scaling problems in Chromium on Asahi Linux

## Components

### Scripts (`~/.local/bin/`)

- **`figma-chromium`** - Basic Figma launcher with Windows user agent spoofing
- **`figma-chromium-trackpad-fix`** - Advanced launcher that temporarily disables trackpad blocking
- **`figma-agent`** - Local font server (compiled for ARM64)

### Services (`~/.config/systemd/user/`)

- **`figma-agent.service`** - Systemd service for the font helper

### Configuration

- **Hyprland input.conf modification** - Sets `disable_while_typing = false` for trackpad

## How It Works

1. **Font Access**:
   - `figma-agent` serves local fonts on localhost:18412
   - Chromium launched with spoofed Windows user agent
   - Figma web app can access fonts from `/usr/share/fonts/TTF/`

2. **Trackpad Fix**:
   - Temporarily disables Hyprland's "disable while typing" setting
   - Allows space bar + trackpad drag for hand tool
   - Automatically restores original setting when Figma closes

3. **Input Optimization**:
   - Uses native Wayland input handling
   - Fixes cursor scaling with `--gtk-version=4` flag

## Installation

```bash
# From dotfiles root
./figma-setup.sh
```

## Manual Setup

```bash
# 1. Install figma-agent
git clone https://github.com/neetly/figma-agent-linux.git
cd figma-agent-linux
cargo build --release
cp target/release/figma-agent ~/.local/bin/

# 2. Start font service
systemctl --user enable --now figma-agent.service

# 3. Copy fonts to system directory (for Figma access)
sudo cp /path/to/your/fonts/*.ttf /usr/share/fonts/TTF/
sudo fc-cache -fv

# 4. Deploy dotfiles
stow figma
stow applications
```

## Usage

Launch Figma from:
- **App launcher** - Click "Figma" icon
- **Terminal** - `figma-chromium-trackpad-fix`

## Troubleshooting

### Fonts not appearing
- Check if fonts are in `/usr/share/fonts/TTF/`
- Verify figma-agent is running: `systemctl --user status figma-agent.service`
- Check font helper response: `curl http://localhost:18412/figma/font-files`

### Space bar hand tool not working
- Ensure you're using `figma-chromium-trackpad-fix` launcher
- Check if Hyprland input config has `disable_while_typing = false`
- Try external mouse instead of trackpad

### Performance issues
- GPU errors in console are normal on Asahi Linux
- Consider adding `--ozone-platform=x11` if Wayland has issues

## Technical Details

- **Architecture**: ARM64 (Apple Silicon)
- **OS**: Asahi Linux with Hyprland
- **Browser**: Chromium with Wayland backend
- **Font Server**: figma-agent-linux (Rust-based)
- **User Agent**: Spoofed Windows Chrome to bypass Figma's Linux restrictions

## Credits

- [figma-agent-linux](https://github.com/neetly/figma-agent-linux) by neetly
- Community solutions for Linux font access workarounds
- Asahi Linux project for Apple Silicon support