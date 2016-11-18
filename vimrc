set nocompatible
filetype plugin indent on

" set the runtime path to include Pathogen
"execute pathogen#infect()

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
	Plugin 'rking/ag.vim'
	Plugin 'terryma/vim-multiple-cursors'
	Plugin 'hynek/vim-python-pep8-indent'
	Plugin 'klen/python-mode'
	Plugin 'ap/vim-css-color'
	Plugin 'Valloric/YouCompleteMe'
	Plugin 'file:///Users/thuynh/Code/zopim/vim-jxml'
	Plugin 'MarcWeber/vim-addon-mw-utils'
	Plugin 'tomtom/tlib_vim'
	Plugin 'garbas/vim-snipmate'
	Plugin 'honza/vim-snippets'
	Plugin 'artur-shaik/vim-javacomplete2'
	Plugin 'tpope/vim-fugitive'
	Plugin 'ctrlpvim/ctrlp.vim'
	Plugin 'scrooloose/nerdtree'
call vundle#end() 

filetype plugin indent on
set backspace=2
syntax on
set fileencodings=utf-8
set fileencoding=utf-8
set encoding=utf-8
set tenc=utf-8
set ruler
set number

set incsearch
set hlsearch
nnoremap <silent> n n:call HLNext(0.4)<cr> 
nnoremap <silent> N N:call HLNext(0.4)<cr>
"=====[ Blink the matching line ]=============
function! HLNext (blinktime) 
	set invcursorline
	redraw
	exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm' 
	set invcursorline
	redraw 
endfunction

set t_Co=256
set hidden " hide buffers, not close
set backspace=indent,eol,start
set autoindent
set smartindent
set cindent
set copyindent

" And no shift magic on comments
nnoremap <silent> >> :call ShiftLine()<CR>|
function! ShiftLine()
	set nosmartindent
	normal! >>
	set smartindent
endfunction

"=====[ Make Visual modes work better ]==================
" Visual Block mode is far more useful that Visual mode (so swap the commands).
nnoremap v <C-V>
nnoremap <C-V> v

vnoremap v <C-V>
vnoremap <C-V> v

" Square up visual selections...
set virtualedit=block

" Make BS/DEL work as expected in visual modes (i.e. delete the selected text)
vmap <BS> x

" Make vaa select the entire file...
vmap aa VGo1G

"=====[ Make arrow keys move visual blocks around ]======================
vmap <up>    <Plug>SchleppUp
vmap <down>  <Plug>SchleppDown
vmap <left>  <Plug>SchleppLeft
vmap <right> <Plug>SchleppRight

vmap D       <Plug>SchleppDupLeft
vmap <C-D>   <Plug>SchleppDupLeft

set showmatch
set history=200
set undolevels=200
set pastetoggle=<F2>

" Whitespace stuff
set tabstop=2
set shiftwidth=2
set softtabstop=2
exec "set listchars=tab:\uB7\uB7,trail:\uB7,nbsp:~" 
	set list

set noeol
set shiftround
set smarttab

if executable('ag')
	" Use Ag over Grep
	set grepprg=ag\ --nogroup\ --nocolor
	set grepformat=%f:%l:%c:%m
	
	" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
	let g:ctrlp_user_command = 'ag -Q -l --nocolor --hidden -g "" %s'
	" ag is fast enough that CtrlP doesn't need to cache
	let g:ctrlp_use_caching = 0
	
	if !exists(":Ag")
		command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
		nnoremap \ :Ag<SPACE>
	endif
endif

" Make it obvious where 80 characters is
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

" Tab completion will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	else
		return "\<c-p>"
	endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

augroup PatchDiffHighlight
	autocmd!
	autocmd FileType diff syntax enable
augroup END

augroup VimReload
	autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

augroup AutoMkdir
	autocmd!
	autocmd  BufNewFile  *  :call EnsureDirExists()
augroup END

function! EnsureDirExists ()
	let required_dir = expand("%:h")
	if !isdirectory(required_dir)
		call AskQuit("Parent directory '" . required_dir . "' doesn't exist.",
				\       "&Create it\nor &Quit?", 2)

		try
			call mkdir( required_dir, 'p' )
		catch
			call AskQuit("Can't create '" . required_dir . "'",
			\            "&Quit\nor &Continue anyway?", 1)
		endtry
	endif
endfunction

" Comments are important
highlight Comment term=bold ctermfg=white

set title           "Show filename in titlebar of window
set titleold=

set nomore          "Don't page long listings

set autowrite       "Save buffer automatically when changing files
set autoread        "Always reload buffer when external changes detected

"           +--Disable hlsearch while loading viminfo
"           | +--Remember marks for last 500 files
"           | |    +--Remember up to 10000 lines in each register
"           | |    |      +--Remember up to 1MB in each register
"           | |    |      |     +--Remember last 1000 search patterns
"           | |    |      |     |     +---Remember last 1000 commands
"           | |    |      |     |     |
"           v v    v      v     v     v
set viminfo=h,'500,<10000,s1000,/1000,:1000
set updatecount=10                  "Save buffer every 10 chars typed

" ==========JAVA stuffs===========
autocmd FileType java setlocal omnifunc=javacomplete#Complete
" F4 trying to guess import option
nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
imap <F4> <Plug>(JavaComplete-Imports-AddSmart)
" F5 will ask for import option
nmap <F5> <Plug>(JavaComplete-Imports-Add)
imap <F5> <Plug>(JavaComplete-Imports-Add)
" F6 add all missing imports
nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
imap <F6> <Plug>(JavaComplete-Imports-AddMissing)
" F7 remove unused imports
nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
imap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
