#!/bin/bash
sudo systemctl enable --now sshd.service
git clone https://aur.archlinux.org/yay.git
sudo pacman -S --needed base-devel debugedit
cd yay
makepkg -si
cd ..

sudo reflector --verbose --sort rate -l 15 -p https --save /etc/pacman.d/mirrorlist
