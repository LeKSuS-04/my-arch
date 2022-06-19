#!/bin/bash

save_path="$HOME/Pictures/Screenshots"
screenshot_path="$save_path/$(date +'%d-%b-%Y_%H-%M-%S').png"

maim --select \
     --nodrag \
     --bordersize=2 \
     --color=0.5,0.73,0.7 \
     --hidecursor \
     --quiet \
     --quality=3 \
     --format='png' \
     --delay=0.1 \
     "$screenshot_path"

xclip -selection clipboard -target 'image/png' -in "$screenshot_path"
