#!/bin/bash

# turn on sudo mode
sudo su

apt update && apt upgrade -y
#apt install language-pack-ja -y
apt install build-essential gdb -y
apt install texlive-full -y
apt install unzip -y

# install fish shell
# TODO: repository of fish-shell/release-3 is not found in the latest version of Ubuntu.
# apt-add-repository ppa:fish-shell/release-3 -y
# apt update
# apt install fish -y
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
rm HackGen_v2.9.0.zip
rm -r HackGen_v2.9.0

# install trash-cli
apt install trash-cli -y

# turn back to user mode
exit

# Gitの設定
git config --global user.name "Takuya Mizokami"
git config --global user.email "takoyaki65@users.noreply.github.com"

USER_HOME=$(eval echo ~${SUDO_USER: -$USER})

# initialize .bashrc
rm "$USER_HOME/.bashrc"
ln -s "$USER_HOME/dotfiles/.bashrc" "$USER_HOME/.bashrc"

#initialize fish.config
#TODO: .config/fish/config.fish file doesn't exist until fish is executed.
#       So, I need to execute fish before executing this script.
# rm "$USER_HOME/.config/fish/config.fish"
# ln -s "$USER_HOME/dotfiles/config.fish" "$USER_HOME/.config/fish/config.fish"

# install rye
curl -sSf https://rye-up.com/get | bash
