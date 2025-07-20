#!/bin/bash
full=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "energy-full:" | awk '{print $2}')
design=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "energy-full-design:" | awk '{print $2}')
health=$(echo "$full / $design * 100" | bc -l)
printf "Health: %.0f%%\n" "$health"