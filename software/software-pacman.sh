#!/usr/bin/env bash
#
# Created by LeKSuS
#
# With help from rickellis/ArchMatic scripts
# https://github.com/rickellis/ArchMatic

echo
echo "Installing pacman software..."

PACKAGES=(
    'kitty'             # Terminal emulator
    'ranger'            # File manager
)

for PACKAGE in "${PACKAGES[@]}"; do
    echo
    echo "Installing ${PACKAGE}"
    sudo pacman -S "${PACKAGE}" --noconfirm --needed
done

echo 
echo "Pacman scripts installed :)"
