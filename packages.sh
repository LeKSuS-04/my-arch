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
    'bspwm'                 # Window manager
    'lightdm'               # Light display manager
    'lightdm-gtk-greeter'   # Display manager greeter
    'nitrogen'              # Wallpaper manager
    'scrot'                 # Taking screenshots
    'xorg'                  # Display server
    'xclip'                 # Clipboard utility

    # ===== Audio =====
    'alsa-utils'            # Utilities for better sound control
    'pulseaudio'            # Sound server
    'pulseaudio-alsa'       # Pulseaudio to manage ALSA

    # ===== Development =====
    'python-pip'            # Package installer for python

    # ===== General purpose =====
    'alacritty'             # Terminal emulator
    'ranger'                # File manager
    'rofi'                  # Window switcher & application launcher
    'sxhkd'                 # Hotkey daemon
    'wget'                  # Tool for fetching data
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
    'ufetch-git'                # Fetching system information
    'unimatrix'             # Scipt to simulate terminal from "The Matrix"

    # ===== General purpose =====
    'brave'                 # Web browser
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
