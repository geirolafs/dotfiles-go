# Getting macOS-Like Sound on Asahi Linux

## The Problem

Asahi Linux **intentionally does not try to sound like macOS**. From their documentation:

> "We do not want to clone the full/exact macOS audio experience. macOS speaker DSP processing is... too tryhard... We believe a more objectively neutral and balanced sound is a better baseline."

**macOS uses:**
- Exaggerated Harman curve (heavy bass, bright highs)
- Psychoacoustic bass enhancement
- Aggressive dynamic range compression
- Spatialization/stereo widening effects

**Asahi uses:**
- Neutral, balanced baseline
- Minimal bass enhancement (Bankstown plugin)
- Speaker protection and safety
- Loudness compensation

## The Solution

The `MacBook_Pro_macOS-Like` preset adds macOS-style processing **on top** of Asahi's neutral baseline.

### Load the Preset

```bash
easyeffects-manage load "MacBook_Pro_macOS-Like"
```

### What It Does

1. **Harman Curve EQ** (10-band)
   - **32-250Hz**: +4.5 to +1.5 dB (heavy bass boost)
   - **500-1000Hz**: -0.5 to -1.0 dB (slight mid scoop for clarity)
   - **2000Hz**: +0.5 dB (presence boost)
   - **4000-8000Hz**: +2.0 to +2.5 dB (bright, crisp highs like macOS)
   - **16000Hz**: +1.5 dB (air and sparkle)

2. **Bass Enhancer**
   - Psychoacoustic bass extension
   - Adds perceived low-end without overdriving woofers
   - Similar to macOS's bass processing (but without Apple's bugs)

3. **Compressor** (macOS-style dynamics)
   - Ratio: 3.5:1
   - Threshold: -18 dB
   - Fast attack (10ms), medium release (80ms)
   - Makes everything sound "punchy" and full

4. **Stereo Widening**
   - Side level: +1.8 dB
   - SC level: +1.2 dB
   - Creates the "spacious" sound macOS has

5. **Limiter** (protection)
   - Threshold: -2 dB
   - Prevents clipping from all the processing

## Comparison

Test these back-to-back:

```bash
# macOS-like (full processing)
easyeffects-manage load "MacBook_Pro_macOS-Like"

# Asahi baseline (bypass EasyEffects)
easyeffects-manage toggle

# Your custom preset
easyeffects-manage load "MacBook_Pro_Enhanced"
```

## Tuning to Your Taste

The preset is **aggressive** to match macOS. If it's too much:

### Reduce Bass
Open EasyEffects GUI and reduce:
- 32Hz: 4.5 → 3.0 dB
- 64Hz: 4.0 → 2.5 dB
- Bass Enhancer amount: 6.0 → 4.0

### Reduce Brightness
- 8kHz: 2.5 → 1.5 dB
- 16kHz: 1.5 → 0.5 dB

### Reduce Compression
- Threshold: -18 → -22 dB (less aggressive)
- Ratio: 3.5:1 → 2.5:1 (gentler)

### Reduce Stereo Width
- Side level: 1.8 → 1.0 dB
- SC level: 1.2 → 1.0 dB

## Why It Still Won't Sound Exactly Like macOS

1. **Speaker Calibration**: Apple has factory measurements of each individual unit's speakers. Asahi uses general measurements for the j316 model.

2. **Low-Level DSP**: macOS processes audio at the CoreAudio level before it hits the speakers. Some of this processing is in firmware/hardware.

3. **Asahi's Bankstown Plugin**: Already doing bass enhancement. The preset adds MORE on top, which may be too much.

4. **Room Acoustics**: Your listening environment affects the sound more than you'd think.

5. **Psychoacoustics**: Apple uses proprietary algorithms we can't fully replicate.

## The Closest You'll Get

This preset gets you **70-80%** of the way there. It mimics:
- ✓ The bass-heavy, bright tonality
- ✓ The "punchy" compressed dynamics
- ✓ The wide stereo image
- ✗ Apple's exact calibration
- ✗ Apple's proprietary algorithms

## Alternative Approach: Boost Asahi's Bass

Instead of using EasyEffects, you can increase Asahi's built-in bass enhancement:

1. Edit: `~/.config/wireplumber/wireplumber.conf.d/99-custom-j316.conf`
2. Add:
```lua
rule = {
  matches = {
    {
      { "node.name", "equals", "audio_effect.j316-convolver" },
    },
  },
  apply_properties = {
    ["filter.graph"] = {
      nodes = {
        {
          type = "lv2",
          name = "bassex_custom",
          plugin = "https://chadmed.au/bankstown",
          control = {
            bypass = 0,
            amt = 2.5,  -- default is 1.8, increase for more bass
            blend = 1.0,
          },
        },
      },
    },
  },
}
```
3. Restart audio: `systemctl --user restart wireplumber`

**Warning**: Excessive bass can damage speakers. Start conservatively.

## Recommended Workflow

1. **Start with macOS-Like preset**
   ```bash
   easyeffects-manage load "MacBook_Pro_macOS-Like"
   ```

2. **Test with various content**
   - Music (multiple genres)
   - YouTube videos
   - Movies
   - Podcasts

3. **Fine-tune in EasyEffects GUI**
   ```bash
   easyeffects-manage gui
   ```

4. **Save as new preset** if you make changes
   - File → Save Preset As...
   - Name it: "MacBook_Pro_macOS-Like_Custom"

5. **Compare with macOS** (if you dual-boot)
   - Same track, same volume
   - Note differences
   - Adjust EQ accordingly

## Community Help

If you want to further improve this preset:
1. Measure your speakers with REW (Room EQ Wizard)
2. Share your measurements on the Asahi Discord
3. Someone might create a better calibration profile

## Disclaimer

**Use at your own risk.** Heavy bass and compression can:
- Reduce speaker lifespan
- Cause distortion at high volumes
- Trigger Asahi's speaker protection

Start at **50-60% volume** and gradually increase while listening for distortion.

## Automatic Startup (Already Configured!)

The `MacBook_Pro_macOS-Like` preset is **already set as your default** and will load automatically on every boot.

**What's configured:**
1. ✓ EasyEffects autostart enabled (via `~/.config/autostart/`)
2. ✓ Default preset: `MacBook_Pro_macOS-Like`
3. ✓ Bypass disabled (effects always on)
4. ✓ Systemd service ensures preset loads after login

**To change the default preset:**
```bash
# Set a different preset as default
easyeffects-set-default "PresetName"

# For example, switch back to neutral sound
easyeffects-set-default "MacBook_Pro_Enhanced"
```

## Quick Commands

```bash
# Show current status (should show macOS-Like)
easyeffects-manage status

# Load macOS-like preset manually
easyeffects-manage load "MacBook_Pro_macOS-Like"

# Set as default (already done, but if you change it)
easyeffects-set-default "MacBook_Pro_macOS-Like"

# Toggle on/off for comparison
easyeffects-manage toggle

# Open GUI for fine-tuning
easyeffects-manage gui

# List all presets
easyeffects-manage list
```

## Troubleshooting Autostart

If the preset doesn't load on boot:

```bash
# Check service status
systemctl --user status easyeffects-preset-loader.service

# Manually trigger the preset loader
systemctl --user start easyeffects-preset-loader.service

# Check if EasyEffects is running
easyeffects-manage status

# Re-enable autostart if needed
systemctl --user enable easyeffects-preset-loader.service
```
