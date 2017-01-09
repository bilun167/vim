#!/bin/sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

git clone https://github.com/bilun167/vim.git ~/.vim
cd ~/.vim; make install;
