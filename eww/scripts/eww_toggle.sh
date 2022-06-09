#!/bin/bash

windows=$(eww windows)

while IFS= read -r line; do
    if [[ $line == "$1" ]]; then
        eww open $1
    elif [[ $line == "*${1}" ]]; then
        eww close $1
    fi
done <<< "$windows"
