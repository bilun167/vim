install: vundle symlink 

symlink: 
	ln -sf `pwd`/vimrc ~/.vimrc;
	ln -sf `pwd`/vimrc.bundles ~/.vimrc.bundles;
	ln -sf `pwd`/syntax ~/.vim/syntax
	ln -sf `pwd`/plugin ~/.vim/plugin

vundle: 
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

