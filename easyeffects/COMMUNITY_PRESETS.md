# Community EasyEffects Presets

This directory contains high-quality community presets from various creators. All presets are optimized for speaker output and can help enhance your MacBook Pro audio experience.

## Quick Start

Load any preset:
```bash
easyeffects-manage load "EasyPulse-hifi-max"
easyeffects-manage load "Bundy01-Music"
easyeffects-manage load "HeavyBass-Mid"
```

## Preset Collections

### EasyPulse by p-chan5 (14 presets)
High-quality genre-specific presets with minimal (-min) and maximal (-max) processing variants.

**Best for MacBook speakers: Try the -max variants first for fuller sound**

- **EasyPulse-hifi-max/min**: Balanced, accurate reproduction for high-quality audio
- **EasyPulse-classical-max/min**: Optimized for classical music, emphasizes clarity
- **EasyPulse-rock-max/min**: Punchy mids and clear vocals for rock music
- **EasyPulse-edm-max/min**: Enhanced bass and crisp highs for electronic music
- **EasyPulse-indie-max/min**: Warm, intimate sound for indie/alternative music
- **EasyPulse-kpop-max/min**: Bright, energetic tuning for K-pop and J-pop
- **EasyPulse-lofi-max/min**: Warm, nostalgic sound for lo-fi hip-hop

**Recommended for MacBook speakers:**
- General listening: `EasyPulse-hifi-max`
- Electronic/Pop: `EasyPulse-edm-max`
- Acoustic/Vocal: `EasyPulse-indie-max`

**Source**: https://github.com/p-chan5/EasyPulse

---

### Bundy01 Presets (4 presets)
Device-inspired tuning profiles for different audio scenarios.

- **Bundy01-Music**: Warm, balanced tuning for general music listening
- **Bundy01-Video**: Enhanced dialogue clarity for movies and videos
- **Bundy01-Sony**: Sony-inspired sound signature (warm bass, clear mids)
- **Bundy01-Bose**: Bose-inspired sound signature (punchy bass, smooth highs)

**Recommended for MacBook speakers:**
- Music: `Bundy01-Music`
- Movies/YouTube: `Bundy01-Video`

**Source**: https://github.com/Bundy01/EasyEffects-Presets

---

### HeavyBass by Rabcor (4 presets)
Bass enhancement presets with varying intensity levels.

- **HeavyBass-Full**: Maximum bass enhancement (use with caution on small speakers)
- **HeavyBass-Mid**: Moderate bass boost - good balance for MacBook speakers
- **HeavyBass-Lite**: Subtle bass enhancement without overwhelming mids
- **HeavyBass-Flat**: Minimal processing baseline

**Recommended for MacBook speakers:**
- Best balance: `HeavyBass-Mid` or `HeavyBass-Lite`
- Avoid: `HeavyBass-Full` (may cause distortion on small speakers)

**Source**: https://github.com/Rabcor/Heavy-Bass-EE

---

### Digitalone1 Loudness Equalizer (6 presets)
Sophisticated loudness compensation and dynamic EQ presets.

- **Digitalone1-LoudnessEqualizer**: Main loudness compensated EQ
- **Digitalone1-LoudnessEqualizer-PE**: PulseEffects-compatible variant
- **Digitalone1-LoudnessEqualizer-GTK**: GTK4-compatible variant
- **Digitalone1-LoudnessEqualizer-OldGate**: Legacy gate configuration
- **Digitalone1-LoudnessCrystalEqualizer**: Enhanced clarity with loudness compensation
- **Digitalone1-LoudnessCrystalEqualizer-GTK**: GTK4-compatible crystal variant

**Recommended for MacBook speakers:**
- Best overall: `Digitalone1-LoudnessEqualizer`
- Extra clarity: `Digitalone1-LoudnessCrystalEqualizer`

**Source**: https://github.com/Digitalone1/EasyEffects-Presets

---

## Usage Tips

### Finding the Best Preset

1. Start with `EasyPulse-hifi-max` as baseline
2. Try genre-specific presets for your music library
3. Compare with your custom `MacBook_Pro_Enhanced` preset
4. A/B test by toggling bypass: `easyeffects-manage toggle`

### Combining with Custom Presets

These community presets work independently. To combine elements:
1. Load community preset in EasyEffects GUI
2. Add additional effects from your custom presets
3. Save as new preset

### Speaker Protection

Small speakers like MacBook's can distort with excessive bass. If you hear:
- Crackling at higher volumes
- Buzzing/rattling
- Muffled sound

**Solution**: Use lighter bass variants or reduce EQ gain by 2-3dB.

### A/B Testing

Test presets side-by-side:
```bash
easyeffects-manage load "EasyPulse-hifi-max"
# Listen for 30 seconds

easyeffects-manage load "Bundy01-Music"
# Compare

easyeffects-manage toggle  # Compare with preset off
```

## Performance Notes

- **Most CPU intensive**: EasyPulse presets (indie variants use most plugins)
- **Lightest**: HeavyBass-Flat, Digitalone1-PE variants
- On M1 Max, all presets should run without issues

Check CPU usage: `pw-top` (press 'q' to quit)

## Troubleshooting

### Preset Not Loading
```bash
easyeffects-manage restart
easyeffects-manage load "PresetName"
```

### Sound Too Harsh/Boomy
- Try -min variants instead of -max
- Reduce bass presets (use Lite instead of Full)
- Check volume - some presets have gain boost

### Crackling/Distortion
See main README.md - this is likely Asahi audio issue, not preset-related.

## Recommendations by Use Case

### General Listening (All Genres)
1. `EasyPulse-hifi-max`
2. `Bundy01-Music`
3. `Digitalone1-LoudnessEqualizer`

### Movies/Videos/Podcasts
1. `Bundy01-Video`
2. `Digitalone1-LoudnessCrystalEqualizer`

### Electronic/Pop/Hip-Hop
1. `EasyPulse-edm-max`
2. `HeavyBass-Mid`

### Rock/Metal
1. `EasyPulse-rock-max`
2. `Bundy01-Sony`

### Classical/Jazz
1. `EasyPulse-classical-max`
2. `EasyPulse-hifi-max`

### Acoustic/Singer-Songwriter
1. `EasyPulse-indie-max`
2. `Bundy01-Music`

### Low Volume Listening
1. `Digitalone1-LoudnessEqualizer` (compensates for Fletcher-Munson curve)
2. `EasyPulse-hifi-max`

## Credits

- **JackHack96**: Original preset collection (in parent directory)
- **p-chan5**: EasyPulse genre-specific presets
- **Bundy01**: Device-inspired presets
- **Rabcor**: Heavy Bass presets
- **Digitalone1**: Loudness Equalizer presets

All presets are open source and licensed under their respective repositories.
