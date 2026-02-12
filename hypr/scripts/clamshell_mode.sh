#!/bin/bash

LAPTOP="eDP-1"
EXTERNAL="HDMI-A-1"

# Check if external monitor is connected
EXTERNAL_CONNECTED=$(hyprctl monitors | grep -c "$EXTERNAL")

if [[ $EXTERNAL_CONNECTED -gt 0 ]]; then
  if [[ "$1" == "open" ]]; then
    # Lid open: Enable both displays
    # External monitor on top, laptop on bottom
    hyprctl keyword monitor "$EXTERNAL,1920x1080,0x-1080,1"
    hyprctl keyword monitor "$LAPTOP,1920x1080,0x0,1"
    
    # Focus on laptop display
    hyprctl dispatch focusmonitor "$LAPTOP"
    
  else
    # Lid closed: External only (becomes main display)
    # Disable laptop display first
    hyprctl keyword monitor "$LAPTOP,disable"
    
    for i in {1..10}; do
        hyprctl dispatch moveworkspacetomonitor "$i" "$EXTERNAL"
    done

    # Focus on external monitor
    hyprctl dispatch focusmonitor "$EXTERNAL"
  fi
else
  # No external monitor: Always enable laptop
  hyprctl keyword monitor "$LAPTOP,1920x1080,0x0,1"
  hyprctl dispatch focusmonitor "$LAPTOP"
fi
