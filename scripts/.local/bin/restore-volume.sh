#!/bin/bash

# Volume restoration script for MacBook Pro J316 Speakers
# Ensures volume is set to desired level after Hyprland starts

# Wait for PipeWire and WirePlumber to fully initialize
sleep 2

# Target volume (42% matches your current WirePlumber setting)
TARGET_VOLUME="40%"

# Device name for MacBook Pro speakers
DEVICE="MacBook Pro J316 Speakers"

# Set volume using pactl
pactl set-sink-volume @DEFAULT_SINK@ "$TARGET_VOLUME"

# Log the action (optional, for debugging)
echo "$(date): Set volume to $TARGET_VOLUME for $DEVICE" >> /tmp/volume-restore.log
