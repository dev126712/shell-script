#!/bin/bash

####################
# Author: Alexandre St-fort
# Last modified: 11/11/25
#
# This script performs a full system package update. Compatible with Debian/Ubuntu/Mint, RHEL/CentOS/Fedora, Arch/Manjaro 
####################

echo "--- Starting Full System Update ---"

# (Debian/Ubuntu/Mint)
if command -v apt &> /dev/null
then
    echo "Detected Debian/Ubuntu-based system (using apt)."
    sudo apt update -y
    sudo apt full-upgrade -y
    sudo apt autoremove -y
    sudo apt clean
    echo "apt update complete."

# (RHEL/CentOS/Fedora)
elif command -v dnf &> /dev/null
then
    echo "Detected RHEL/Fedora-based system (using dnf)."
    sudo dnf check-update
    sudo dnf upgrade -y
    sudo dnf autoremove -y
    sudo dnf clean all
    echo "dnf update complete."

# (Arch/Manjaro)
elif command -v pacman &> /dev/null
then
    echo "Detected Arch-based system (using pacman)."
    sudo pacman -Syu --noconfirm
    sudo pacman -Qtdq | sudo pacman -Rns -
    echo "pacman update complete."

else
    echo "ERROR"
    exit 1
fi

echo "--- Full System Updated ---"
