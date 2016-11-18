set nocompatible 
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'rking/ag.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'klen/python-mode'
Plugin 'Townk/vim-autoclose'
Plugin 'ap/vim-css-color'

call vundle#end() 
filetype plugin indent on

syntax on
set fileencodings=utf-8
set fileencoding=utf-8
set encoding=utf-8
set tenc=utf-8
set ruler
set number
set incsearch
set hlsearch
set t_Co=256
set hidden " hide buffers, not close
set backspace=indent,eol,start
set autoindent
set cindent
set copyindent
set showmatch
set history=200
set undolevels=200
set pastetoggle=<F2>

" Whitespace stuff
set tabstop=4
set shiftwidth=4
set softtabstop=4
" set list listchars=tab:▸\ ,eol:¬,trail:·
set noeol
set shiftround
set smarttab
