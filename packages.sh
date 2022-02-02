#!/bin/bash
# Arch Linux post-installation script
# By LeKSuS

cd /tmp

echo
echo "Installing pacman packages"
echo
echo "Updating system"
sudo pacman -Syyu --noconfirm

PACMAN_PKGS=(
    # ===== Screen =====
    'brightnessctl'         # Brightness controller

    # ===== Audio =====
    'alsa-utils'            # Utilities for better sound control
    'pulseaudio'            # Sound server
    'pulseaudio-alsa'       # Pulseaudio to manage ALSA

    # ===== General purpose =====
    'alacritty'             # Terminal emulator
    'ranger'                # File manager
    'rofi'                  # Window switcher & application launcher
)
for PKG in "${PACMAN_PKGS[@]}"; do
    echo
    echo "Installing ${PKG} [pacman]"
    sudo pacman -S "${PKG}" --noconfirm --needed
done
echo
echo "Pacman packages are installed :)"


echo
echo "Installing AUR packages"
echo
echo "Installing yay"
git clone https://aur.archlinux.org/yay.git 
cd yay
makepkg -si

AUR_PKGS=(
    # ===== Screen =====
    'picom-jonaburg-git'    # Picom fork with extra functionality

    # ===== Audio =====
    'pacmixer'              # CLI audio mixer

    # ===== Graphics =====
    'aseprite'              # Pixel-art editor

    # ===== Misc CLI tools =====
    'ufetch'                # Fetching system information
    'unimatrix'             # Scipt to simulate terminal from "The Matrix"

    # ===== General purpose =====
    'mons'                      # Utility for dual-monitor control
    'nerd-fonts-complete'       # Font pack
    'spotify'                   # Music player
    'visual-studio-code-bin'    # Superiour text editor
)
for PKG in "${AUR_PKGS[@]}"; do
    echo 
    echo "Installing ${PKG} [AUR]"
    yay -S "${PKG}" --noconfirm --needed
done
echo
echo "AUR packages are installed :)"
