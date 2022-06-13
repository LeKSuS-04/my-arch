#!/bin/bash

windows=$(~/.local/bin/eww windows)

while IFS= read -r line; do
    if [[ $line == "$1" ]]; then
        ~/.local/bin/eww open "$1"
    elif [[ $line == "*${1}" ]]; then
        ~/.local/bin/eww close "$1"
    fi
done <<< "$windows"
