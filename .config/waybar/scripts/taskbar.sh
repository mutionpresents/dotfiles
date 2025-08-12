#!/bin/bash

# Get all windows and group by class
windows=$(hyprctl clients -j | jq -r '
    group_by(.class) | 
    map({
        class: .[0].class,
        count: length,
        title: .[0].title,
        workspace: .[0].workspace.id
    }) | 
    map(select(.count > 0)) |
    map("\(.class):\(.count)")[]
')

# Format for Waybar
output=""
for window in $windows; do
    class=$(echo $window | cut -d: -f1)
    count=$(echo $window | cut -d: -f2)
    
    if [ $count -gt 1 ]; then
        output+="$class($count) "
    else
        output+="$class "
    fi
done

echo "{\"text\":\"$output\", \"tooltip\":\"Click to focus windows\"}"
