# EasyEffects Configuration

[EasyEffects](https://github.com/wwmm/easyeffects) is a powerful audio effects processor for PipeWire. This module contains custom presets optimized for the MacBook Pro M1 Max speakers and headphones.

## Overview

EasyEffects runs as a D-Bus activated service and automatically starts when needed. It processes all audio output through PipeWire, allowing for system-wide equalization, limiting, compression, and more.

## Features

- **Custom Presets**: Multiple EQ presets optimized for MacBook hardware
- **Impulse Responses**: Headphone correction profiles from various sources
- **Asahi Linux Optimized**: Presets designed to work around known audio issues on Apple Silicon
- **Management Script**: Easy command-line control via `easyeffects-manage`

## Presets

### Custom Presets (Root Directory)

#### MacBook_Pro_macOS-Like ⭐ (NEW - For macOS Sound)
**Get as close to macOS audio quality as possible on Asahi Linux.**

Adds macOS-style processing on top of Asahi's neutral baseline:
- **Harman curve EQ**: Heavy bass (32-250Hz), bright highs (4-16kHz)
- **Psychoacoustic bass enhancer**: Extends perceived low-end
- **Aggressive compression**: Punchy, dynamic macOS-style sound
- **Stereo widening**: Spacious, wide soundstage like macOS
- **Limiter**: Protection from clipping

**Start here if you want macOS sound!** See `MACOS_SOUND_GUIDE.md` for details.

```bash
easyeffects-manage load "MacBook_Pro_macOS-Like"
```

#### MacBook_Pro_Enhanced (Balanced - Recommended for Neutral Sound)
Primary preset for built-in MacBook speakers with Asahi's neutral philosophy:
- **10-band EQ** addressing frequency response issues
- **Notch at 200Hz** to reduce documented Asahi audio distortion
- **Enhanced bass** (cleaner than Asahi's Bankstown plugin)
- **Reduced harsh treble** (8kHz/16kHz cuts)
- **Limiter** to smooth transients and prevent clipping

#### MacBook_Pro_Stock
Minimal processing for MacBook speakers - good baseline for comparison.

#### Other Custom Presets
- `gogo.json` - Personal customization
- `Perfect EQ.json` - Alternative EQ curve
- `Bass Boosted.json` - Enhanced low-end
- `Boosted.json` - Overall volume boost
- `Bass Enhancing + Perfect EQ.json` - Combined profile
- `Loudness+Autogain.json` - Dynamic loudness with auto-gain
- `Advanced Auto Gain.json` - Sophisticated auto-leveling

### Community Presets

**30+ high-quality presets from the EasyEffects community** optimized for speaker output.

See `COMMUNITY_PRESETS.md` for detailed information on all presets.

**Quick recommendations for MacBook speakers:**
- General listening: `EasyPulse-hifi-max`
- Electronic/Pop: `EasyPulse-edm-max`
- Movies: `Bundy01-Video`
- Bass boost: `HeavyBass-Mid`
- Low volume: `Digitalone1-LoudnessEqualizer`

Load community presets:
```bash
easyeffects-manage load "EasyPulse-hifi-max"
```

**Collections included:**
- **EasyPulse** (14): Genre-specific presets (rock, classical, EDM, indie, K-pop, lo-fi, hi-fi)
- **Bundy01** (4): Device-inspired profiles (Music, Video, Sony, Bose)
- **HeavyBass** (4): Bass enhancement (Full, Mid, Lite, Flat)
- **Digitalone1** (6): Loudness equalizers with dynamic compensation

## Management Commands

Use the `easyeffects-manage` script for easy control:

```bash
# List all available presets
easyeffects-manage list

# Load a specific preset
easyeffects-manage load MacBook_Pro_Enhanced

# Show current status
easyeffects-manage status

# Toggle bypass (enable/disable effects)
easyeffects-manage toggle

# Restart EasyEffects
easyeffects-manage restart

# Open GUI
easyeffects-manage gui
```

## Integration with Audio Stack

EasyEffects integrates with the PipeWire/WirePlumber audio system:

```
Audio Source → PipeWire → EasyEffects → Output Device
```

**Important**: Do **NOT** set EasyEffects virtual devices as default. Let your hardware remain the default device.

Check integration:
```bash
wpctl status | grep -i easy
# Should show:
#   79. easyeffects
#   116. Easy Effects Sink
#   160. Easy Effects Source
```

## Interaction with Asahi Audio

This configuration works **alongside** Asahi's speaker DSP (`asahi-audio`), not instead of it:

1. **Hardware DSP** (asahi-audio): Speaker protection and basic tuning
2. **EasyEffects**: Additional EQ and processing on top

See the `pipewire/`, `wireplumber/`, and `asahi-audio-custom/` modules for low-level audio configuration.

## File Structure

```
easyeffects/
├── .config/easyeffects/
│   ├── output/                  # Output (playback) presets (38 total)
│   │   ├── MacBook_Pro_Enhanced.json   # Custom presets
│   │   ├── MacBook_Pro_Stock.json
│   │   ├── *.json
│   │   ├── EasyPulse-*.json    # Community: Genre-specific (14)
│   │   ├── Bundy01-*.json      # Community: Device-inspired (4)
│   │   ├── HeavyBass-*.json    # Community: Bass boost (4)
│   │   └── Digitalone1-*.json  # Community: Loudness EQ (6)
│   └── irs/                     # Impulse response files (16 files)
│       └── *.irs
├── README.md                    # This file
├── COMMUNITY_PRESETS.md         # Detailed community preset docs
└── install-plugins.sh           # Plugin installation script
```

## Adding New Presets

1. Open EasyEffects GUI: `easyeffects`
2. Create/modify your preset in the interface
3. Save it - it will appear in `~/.config/easyeffects/output/`
4. Copy to dotfiles: `cp ~/.config/easyeffects/output/YourPreset.json ~/.dotfiles/easyeffects/.config/easyeffects/output/`
5. Stow to apply: `cd ~/.dotfiles && stow -R easyeffects`

## Troubleshooting

### EasyEffects not starting
Check if it's running:
```bash
easyeffects-manage status
```

If not running, start it:
```bash
easyeffects-manage restart
```

### No audio processing
1. Check bypass status: `easyeffects-manage status`
2. Toggle bypass: `easyeffects-manage toggle`
3. Verify preset loaded: `easyeffects-manage list`

### Crackling/distortion
Despite EasyEffects optimization, Asahi audio has known crackling issues. Try:
1. Lower quantum in PipeWire config (see `pipewire/` module)
2. Reduce EQ gains (especially bass)
3. Disable limiter temporarily
4. Use external DAC/headphones to bypass onboard DSP

### GUI not opening
```bash
# Check if EasyEffects package is installed
which easyeffects
easyeffects --version

# Install if missing
sudo pacman -S easyeffects
```

## Technical Details

**D-Bus Activation**: EasyEffects uses D-Bus service activation instead of systemd. The service file is at `/usr/share/dbus-1/services/com.github.wwmm.easyeffects.service`.

**State Storage**: Settings and presets are stored in:
- Presets: `~/.config/easyeffects/output/` (JSON)
- Active settings: dconf database at `/com/github/wwmm/easyeffects/`

**Current Configuration**:
```bash
# View current preset
dconf read /com/github/wwmm/easyeffects/streamoutputs/output-preset-name

# View bypass state
dconf read /com/github/wwmm/easyeffects/streamoutputs/bypass
```

## Known Issues

See CLAUDE.md "Audio Configuration" section for details on:
- Crackling/popping during audio transitions
- Asahi audio DSP limitations
- Relationship with custom PipeWire/WirePlumber configs

## Resources

- **Project**: https://github.com/wwmm/easyeffects
- **Documentation**: https://github.com/wwmm/easyeffects/wiki
- **Presets Community**: https://github.com/wwmm/easyeffects/wiki/Community-presets
- **Impulse Responses**: AutoEQ project (headphone corrections)
