#!/bin/bash

sudo apt update && sudo apt upgrade -y
#sudo apt install language-pack-ja -y
sudo apt install build-essential gdb -y
sudo apt install texlive-full -y
sudo apt install libgtest-dev -y
# install fish shell
sudo apt install fish -y
chsh -s /usr/bin/fish

# install trash-cli
sudo apt install trash-cli -y

# Gitの設定
git config --global user.name "takoyaki65"
git config --global user.email "takoyaki65@users.noreply.github.com"
