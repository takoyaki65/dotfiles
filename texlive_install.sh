#!/bin/bash

# texliveをインストールするためのスクリプト
# 参考: https://qiita.com/momomo_rimoto/items/ea83f6e703bceff69914
# 参考: https://tug.org/texlive/doc/texlive-ja/texlive-ja.pdf#c
wget https://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/install-tl-unx.tar.gz
tar xzf install-tl-unx.tar.gz
./install-tl-2021*/install-tl
echo 'export PATH="$PATH:/usr/local/texlive/2021/bin/x86_64-linux"' >> ~/.bashrc
echo 'export MANPATH="$MANPATH:/usr/local/texlive/2021/texmf-dist/doc/man"' >> ~/.bashrc
echo 'export INFOPATH="$INFOPATH:/usr/local/texlive/2021/texmf-dist/doc/info"' >> ~/.bashrc
source ~/.bashrc
rm -rf install-tl-*