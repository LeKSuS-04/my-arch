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
    'brightnessctl'     # Brightness controller
    'bspwm'             # Window manager
    'lightdm'           # Light display manager
    'lightdm-gtk-greeter'   # Display manager greeter
    'nitrogen'          # Wallpaper manager
    'xorg'              # Display server

    # ===== Audio =====
    'pulseaudio'        # Sound server
    'pulseaudio-alsa'   # Pulseaudio to manage ALSA

    # ===== Misc =====
    'alacritty'         # Terminal emulator
    'ranger'            # File manager
    'rofi'              # Window switcher & application launcher
    'sxhkd'             # Hotkey daemon
    'wget'              # Tool for fetching data
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
    # ===== Audio =====
    'pacmixer'          # CLI audio mixer

    # ===== Graphics =====
    'aseprite'          # Pixel-art editor

    # ===== Misc CLI tools =====
    'ufetch-git'        # Fetching system information
    'unimatrix'         # Scipt to simulate terminal from "The Matrix"

    # ===== Misc =====
    'mons'              # Utility for dual-monitor control
    'spotify'           # Music player
    'visual-studio-code-bin'    # Superiour text editor
)
for PKG in "${AUR_PKGS[@]}"; do
    echo 
    echo "Installing ${PKG} [AUR]"
    yay -S "${PKG}" --noconfirm --needed
done
echo
echo "AUR packages are installed :)"


echo
echo "Configuring packages"

echo
echo "Configuring lightdm"
systemctl enable lightdm
echo "Done!"

echo
echo "Configuring ..."
echo "Done!"

echo
echo "Finished configuring packages"