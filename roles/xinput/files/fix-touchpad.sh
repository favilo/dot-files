#!/bin/bash
# Script to configure touchpad with natural scrolling and tapping enabled

# Find touchpad device ID (looking for common touchpad names)
TOUCHPAD_ID=$(xinput list | grep -i 'touchpad\|synaptics\|elan' | grep -v 'Virtual' | head -1 | grep -oP 'id=\K\d+')

if [ -z "$TOUCHPAD_ID" ]; then
    echo "Error: Could not find touchpad device"
    exit 1
fi

echo "Found touchpad device ID: $TOUCHPAD_ID"

# Enable natural scrolling
xinput set-prop "$TOUCHPAD_ID" "libinput Natural Scrolling Enabled" 1
if [ $? -eq 0 ]; then
    echo "Natural scrolling enabled"
else
    echo "Warning: Could not enable natural scrolling"
fi

# Enable tapping
xinput set-prop "$TOUCHPAD_ID" "libinput Tapping Enabled" 1
if [ $? -eq 0 ]; then
    echo "Tapping enabled"
else
    echo "Warning: Could not enable tapping"
fi

echo "Touchpad configuration complete"
