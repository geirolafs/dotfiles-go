#!/bin/bash

# MacBook Pro Keyboard Backlight Auto Control for Asahi Linux
# Uses swayidle for timeout AND resume detection

set -euo pipefail

# Configuration
readonly TIMEOUT_SECONDS=10
readonly DEFAULT_BRIGHTNESS="1%"

# IMPORTANT: This script saves the current brightness to /tmp/kbd_saved_brightness
# when turning OFF, and restores that saved value when turning ON.
#
# If you change DEFAULT_BRIGHTNESS above but it doesn't seem to work:
# 1. Delete the saved file: sudo rm /tmp/kbd_saved_brightness
# 2. Restart the script to use your new default setting
#
# Manual brightness control:
# - Set brightness: brightnessctl --device=kbd_backlight set XX%
# - Check current: brightnessctl --device=kbd_backlight get
# - Turn off: brightnessctl --device=kbd_backlight set 0
#
# The DEFAULT_BRIGHTNESS is only used when no saved brightness file exists.

# Function to log with timestamp
log_message() {
  echo "[$(date '+%H:%M:%S')] $1"
}

# Check if swayidle is available
if ! command -v swayidle >/dev/null 2>&1; then
  echo "Error: swayidle not found. Please install it: sudo pacman -S swayidle"
  exit 1
fi

# Check if brightnessctl can control keyboard backlight
if ! brightnessctl --device=kbd_backlight get >/dev/null 2>&1; then
  echo "Error: Cannot control keyboard backlight with brightnessctl"
  exit 1
fi

log_message "Starting keyboard backlight auto-control using swayidle"
log_message "Timeout: ${TIMEOUT_SECONDS}s, Brightness: $DEFAULT_BRIGHTNESS"

# Use swayidle with both timeout AND resume
exec swayidle -w \
  timeout "$TIMEOUT_SECONDS" 'bash -c "
    current=\$(brightnessctl --device=kbd_backlight get 2>/dev/null || echo \"0\")
    if [[ \"\$current\" -gt 0 ]]; then
      echo \"\$current\" > /tmp/kbd_saved_brightness
      brightnessctl --device=kbd_backlight set 0 >/dev/null 2>&1
      echo \"[\$(date +%H:%M:%S)] Keyboard backlight turned OFF after '"$TIMEOUT_SECONDS"'s idle\"
    fi
  "' \
  resume 'bash -c "
    if [[ -f /tmp/kbd_saved_brightness ]]; then
      brightness=\$(cat /tmp/kbd_saved_brightness)
      brightnessctl --device=kbd_backlight set \"\$brightness\" >/dev/null 2>&1
      echo \"[\$(date +%H:%M:%S)] Keyboard backlight restored to: \$brightness\"
    else
      brightnessctl --device=kbd_backlight set '"$DEFAULT_BRIGHTNESS"' >/dev/null 2>&1
      echo \"[\$(date +%H:%M:%S)] Keyboard backlight turned ON ('"$DEFAULT_BRIGHTNESS"')\"
    fi
  "'
