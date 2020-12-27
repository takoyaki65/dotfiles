#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install language-pack-ja -y
sudo apt install build-essential gdb -y
sudo apt install x11-apps x11-utils x11-xserver-utils dbus-x11 -y
sudo apt install libboost-all-dev libeigen3-dev -y
sudo apt install libgtest-dev -y

# Gitの設定
git config --global user.name "takoyaki65"
git config --global user.email "takoyaki65@users.noreply.github.com"