#! /usr/bin/env python3
import os
from os import system
from os.path import isdir
from os.path import expanduser as eu
from time import sleep

from shutil import move

aur = "paru"
packages = "picom-jonaburg-git candy-icons-git alacritty xmonad-contrib flameshot betterlockscreen volumeicon playerctl polybar"
            

def main():
    print('Welcome to dotfiles installer')

    print("Doing a system update, cause stuff may break if it's not the latest version...")
    sleep(1)

    system("sudo pacman --noconfirm -Syu")

    print("########################")
    print("Will do stuff, get ready")
    print("########################")

    # install base-devel if not installed
    system("sudo pacman -S --noconfirm --needed base-devel wget git")

    print("1) xf86-video-intel 	2) xf86-video-amdgpu 3) nvidia 4) Skip")
    
    vid = input("Choose you video card driver(default 1)(will not re-install):")
    DRI = None

    if vid == 1:
        DRI = 'xf86-video-intel'
    elif vid == 2:
        DRI = 'xf86-video-amdgpu'
    elif vid == 3:
        DRI = 'nvidia nvidia-settings nvidia-utils'
    elif vid == 4:
        DRI = ""
    else:
        DRI = 'xf86-video-intel'

    system(f"sudo pacman -S --noconfirm --needed feh xorg xorg-xinit xorg-xinput {DRI} xmonad")
    print("Gib us a AUR Helper. It is essential. 1) paru        2) yay")
    num = input("What is the AUR helper of your choice? (Default is paru):")
    if num == 2:
        aur = "yay"
    else:
        aur = "paru"
    
    system(f"{aur} --noconfirm -S {packages}")

    # INSTALLATIONS BOI
    system("mkdir -p ~/.config")

    if isdir(eu("~/.config/alacritty")):
        print("Alacritty configs exist, backing up...")
        os.rename(eu("~/.config/alacritty/"), eu("~/.config/alacritty.old/"))


    else:
        move("../.config/alacritty/", "")

    if isdir(eu("~/.config/picom.conf")):
        print("Picom config exists, backing up...")

if __name__ == "__main__":
    main()
        
    
