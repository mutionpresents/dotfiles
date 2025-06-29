#!/bin/bash

ICON=""  # Folder icon (from Nerd Font)

# On left-click, open Thunar
if [ "$BLOCK_BUTTON" == "1" ]; then
    thunar --no-desktop &
fi

# Print icon with Pango markup
echo "<span font='JetBrainsMono Nerd Font 12'>$ICON</span>"

