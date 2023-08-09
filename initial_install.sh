#!/bin/bash

apt update && apt upgrade -y
#apt install language-pack-ja -y
apt install build-essential gdb -y
apt install texlive-full -y
apt install libgtest-dev -y
# install fish shell
apt-add-repository ppa:fish-shell/release-3 -y
apt update
apt install fish -y
# set fish as default shell
#chsh -s /usr/bin/fish

# install fisher
#curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
# install oh-my-fish/theme-bobthefish
# theme-bobthefish makes fish slow, so I don't use it now.
#fisher install oh-my-fish/theme-bobthefish

# install HackGen_v2.9.0
wget https://github.com/yuru7/HackGen/releases/download/v2.9.0/HackGen_v2.9.0.zip
unzip HackGen_v2.9.0.zip
mkdir -p /usr/share/fonts/truetype/HackGen
cp HackGen_v2.9.0/*.ttf /usr/share/fonts/truetype/HackGen
fc-cache -fv

# install trash-cli
apt install trash-cli -y

# Gitの設定
git config --global user.name "takoyaki65"
git config --global user.email "takoyaki65@users.noreply.github.com"

# initialize .bashrc
rm ~/.bashrc
ln -s ~/dotfiles/.bashrc ~/.bashrc

#initialize fish.config
rm ~/.config/fish/config.fish
ln -s ~/dotfiles/config.fish ~/.config/fish/config.fish
