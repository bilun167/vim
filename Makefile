install: vundle symlink 

symlink: 
	ln -sf `pwd`/vimrc ~/.vimrc;

vundle: 
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

