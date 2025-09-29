#!/usr/bin/env bash
set -euo pipefail

# Figma Font Helper Setup for Asahi Linux (ARM64)
# This script sets up the complete Figma solution with local font support

echo "🎨 Setting up Figma with local font support for Asahi Linux..."

# Check if we're on ARM64
if [[ $(uname -m) != "aarch64" ]]; then
    echo "⚠️  Warning: This setup is optimized for ARM64/aarch64 architecture"
fi

# Ensure required packages are installed
echo "📦 Installing required packages..."
sudo pacman -S --needed --noconfirm chromium rust cargo git

# Build figma-agent-linux if not already present
if [[ ! -f ~/.local/bin/figma-agent ]]; then
    echo "🔨 Building figma-agent-linux..."
    cd /tmp
    if [[ -d figma-agent-linux ]]; then
        rm -rf figma-agent-linux
    fi
    git clone https://github.com/neetly/figma-agent-linux.git
    cd figma-agent-linux
    cargo build --release
    cp target/release/figma-agent ~/.local/bin/
    echo "✅ figma-agent built and installed"
fi

# Enable and start figma-agent service
echo "🔧 Setting up figma-agent systemd service..."
systemctl --user daemon-reload
systemctl --user enable figma-agent.service
systemctl --user start figma-agent.service

# Update desktop database
echo "🖥️  Updating desktop database..."
update-desktop-database ~/.local/share/applications 2>/dev/null || true

# Check if fonts need to be installed to system directory
echo "🔤 Checking font installation..."
FONT_COUNT=$(fc-list | grep -c "/usr/share/fonts/TTF/" || true)
if [[ $FONT_COUNT -lt 100 ]]; then
    echo "ℹ️  Consider copying your custom fonts to /usr/share/fonts/TTF/ for Figma access"
    echo "   Example: sudo cp /path/to/your/fonts/*.ttf /usr/share/fonts/TTF/"
    echo "   Then run: sudo fc-cache -fv"
fi

# Verify figma-agent is running
if systemctl --user is-active --quiet figma-agent.service; then
    echo "✅ figma-agent service is running"
else
    echo "❌ figma-agent service failed to start"
    echo "   Check status with: systemctl --user status figma-agent.service"
fi

echo ""
echo "🎉 Figma setup complete!"
echo ""
echo "📋 What was set up:"
echo "   • figma-chromium - Basic launcher with Windows user agent"
echo "   • figma-chromium-trackpad-fix - Launcher with trackpad override"
echo "   • figma-agent - Font helper service for local fonts"
echo "   • Figma.desktop - App launcher entry"
echo ""
echo "🚀 Usage:"
echo "   • Click 'Figma' in your app launcher"
echo "   • Or run: figma-chromium-trackpad-fix"
echo ""
echo "✨ Features:"
echo "   • Local font access (fonts in /usr/share/fonts/TTF/)"
echo "   • Space bar hand tool works with trackpad"
echo "   • Proper cursor scaling on Asahi Linux"
echo "   • Automatic trackpad setting restoration"