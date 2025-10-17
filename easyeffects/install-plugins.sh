#!/usr/bin/env bash

# Install additional audio plugins for EasyEffects
# Run this script to enhance available DSP effects

set -euo pipefail

echo "Installing EasyEffects audio plugins..."
echo ""

# Core audio plugin packages
PLUGINS=(
    "calf"              # Calf Studio Gear plugins
    "mda.lv2"           # MDA plugins
    "swh-plugins"       # Steve Harris plugins (LADSPA)
    "rubberband"        # Pitch shifter
    "soundtouch"        # Time/pitch manipulation
    "zita-convolver"    # Convolution reverb
    "gxplugins.lv2"     # Guitarix plugins (tube amp, EQ, reverb)
    "infamousplugins"   # Infamous plugins (multiband compressor, etc)
    "fomp.lv2"          # FOMP plugins (additional filters/EQ)
)

# Check which are already installed
TO_INSTALL=()
for plugin in "${PLUGINS[@]}"; do
    if ! pacman -Qi "$plugin" &>/dev/null; then
        TO_INSTALL+=("$plugin")
        echo "  [+] Will install: $plugin"
    else
        echo "  [✓] Already installed: $plugin"
    fi
done

echo ""

if [ ${#TO_INSTALL[@]} -eq 0 ]; then
    echo "All plugins already installed!"
    exit 0
fi

echo "Installing ${#TO_INSTALL[@]} plugins..."
sudo pacman -S --needed --noconfirm "${TO_INSTALL[@]}"

echo ""
echo "✓ Plugin installation complete!"
echo ""
echo "Restart EasyEffects to detect new plugins:"
echo "  easyeffects-manage restart"
