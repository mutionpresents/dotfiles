#!/usr/bin/env bash

# Set location (URL-encoded format)
LOCATION="Los Angeles"  # Default location
[ -n "$1" ] && LOCATION="$1"

# Try multiple times (5 attempts)
for i in {1..5}; do
    # Get compact weather (for status bar)
    text=$(curl -s "https://wttr.in/${LOCATION}?format=%c+%t+%w" 2>/dev/null)
    
    # Get detailed weather (for tooltip)
    tooltip=$(curl -s "https://wttr.in/${LOCATION}?format=%l\n%c+%t\n💧%h\n🌬️%w\n🌧️%p\n🛰️%m" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        # Clean up the output
        text=$(echo "$text" | sed -E "s/\s+/ /g; s/°C/°C/; s/°F/°F/")
        tooltip=$(echo "$tooltip" | sed -E "s/\s+/ /g; s/°C/°C/; s/°F/°F/")
        
        # Output JSON for Waybar
        echo "{\"text\":\"$text\", \"tooltip\":\"$tooltip\"}"
        exit 0
    fi
    
    sleep 2
done

# Fallback output if all attempts fail
echo "{\"text\":\"⚠ Weather\", \"tooltip\":\"Failed to get weather data\"}"