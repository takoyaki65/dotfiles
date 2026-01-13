#!/bin/bash

set -e

echo "Installing OpenJDK 21 and sources..."
sudo apt update
sudo apt install -y openjdk-21-jdk openjdk-21-source

echo "Installing Coursier..."

ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
    curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" | gzip -d > cs
elif [ "$ARCH" = "aarch64" ]; then
    curl -fL "https://github.com/VirtusLab/coursier-m1/releases/latest/download/cs-aarch64-pc-linux.gz" | gzip -d > cs
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

chmod +x cs
./cs setup
rm cs

echo "Coursier installation complete!"
