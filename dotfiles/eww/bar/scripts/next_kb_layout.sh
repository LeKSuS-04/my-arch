#!/bin/bash

current_layout=$(xkb-switch)
all_layouts=($(xkb-switch -l))

i=0
for layout in ${all_layouts[@]}
do
    i=$((i + 1))
    if [ "$layout" = "$current_layout" ]; then
        break
    fi
done

len=${#all_layouts[@]}
xkb-switch -s ${all_layouts[$i % len]}

