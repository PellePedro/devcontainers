#!/bin/bash

alias libtoolize=glibtoolize

[ -f ~/.config/neovim.git ] && sudo rm ~/.config/neovim

git clone https://github.com/neovim/neovim.git ~/.config/neovim

[ -f /usr/local/bin/nvim ] && sudo rm /usr/local/bin/nvim
[ -d /usr/local/share/nvim ] && sudo rm -r /usr/local/share/nvim/

cd ~/.config/neovim

make CMAKE_BUILD_TYPE=Release

sudo make install

rm -rf /Users/pedro/.config/nvim/neovim
