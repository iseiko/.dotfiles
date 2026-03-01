#!/bin/sh

CONF="~/.config"

# this script should remove the config directories and then stow the new ones

rm -rf $CONF/hypr $CONF/zsh $CONF/kitty $CONF/ranger $CONF/starship.toml ~/Pictures 

cd ~
cd ~/.dotfiles/configs 

stow -t ~ hypr
stow -t ~ zsh 
stow -t ~ kitty 
stow -t ~ ranger 
stow -t ~ starship 
stow -t ~ Pfp
stow -t ~ Wallpapers
stow -t ~ dunst
stow -t ~ neovim
stow -t ~ waybar 
stow -t ~ wpaperd
stow -t ~ scripts
stow -t ~ rofi 
stow -t ~ kew
