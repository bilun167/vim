install: vundle symlink 

symlink: 
	ln -sf `pwd`/vimrc ~/.vimrc;
	ln -sf `pwd`/vimrc.bundles ~/.vimrc.bundles;

vundle: 
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

