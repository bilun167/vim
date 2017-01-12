install:
	mkdir -p ~/.vim/autoload && cd ~/.vim/autoload && curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

symlink: 
	ln -sf `pwd`/vimrc ~/.vimrc;
	ln -sf `pwd`/vimrc.bundles ~/.vimrc.bundles;
	ln -sf `pwd`/syntax ~/.vim/
	ln -sf `pwd`/plugin ~/.vim/
	ln -sf `pwd`/colors ~/.vim/

vundle: 
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

