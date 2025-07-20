#!/bin/bash

WALL_DIR="$HOME/Pictures/Makima"
CMD="$(pwd)"
cd "$WALL_DIR" || exit
IFS=$'\n'

SELECTED_WALL=$(for a in *.jpg *.png; do
    echo -e "$a\x1ficon\x1f$WALL_DIR/$a"
done | wofi --dmenu -p "Choose wallpaper")

if [ -n "$SELECTED_WALL" ]; then
    matugen generate "$WALL_DIR/$SELECTED_WALL"
fi

cd "$CMD"

