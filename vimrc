set nocompatible
filetype plugin indent on

" set the runtime path to include Pathogen
"execute pathogen#infect()

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
	Plugin 'rking/ag.vim'
	Plugin 'terryma/vim-multiple-cursors'
	Plugin 'Yggdroot/indentLine'
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
	Plugin 'Xuyuanp/nerdtree-git-plugin'
	Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
	Plugin 'vim-airline/vim-airline'
	Plugin 'vim-airline/vim-airline-themes'
	Plugin 'ryanoasis/vim-devicons'
	Plugin 'majutsushi/tagbar'
	Plugin 'scrooloose/nerdcommenter'
	Plugin 'sjl/gundo.vim'
	Plugin 'vim-syntastic/syntastic'
	Plugin 'christoomey/vim-tmux-navigator'
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
" ===========SEARCH=================
set incsearch
set ignorecase
set hlsearch
nnoremap <silent> n n:call HLNext(0.4)<cr>
nnoremap <silent> N N:call HLNext(0.4)<cr>
" Blink the matching line
function! HLNext (blinktime) 
	set invcursorline
	redraw
	exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm' 
	set invcursorline
	redraw 
endfunction

set t_Co=256
" ============INDENTATION==============
let g:indentLine_color_term = 239
let g:indentLine_char = '┆'
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2
set backspace=indent,eol,start
set autoindent
set smartindent
set cindent
set copyindent

" Whitespace stuff
set tabstop=2
set shiftwidth=2
set softtabstop=2
:set list lcs=tab:\┆\ ,trail:·,nbsp:⚋
set noeol
set shiftround
set smarttab

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

"=====[ Make arrow keys move visual blocks around ]=====
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

" ===========BUFFER==============
" This allows buffers to be hidden if has been modified
set hidden
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

" =========TAG BAR===============
nmap <F8> :TagbarToggle<CR>

" =========NERD TREE=============
" open NERDTree automatically when vim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") &&b:NERDTree.isTabTree()) | q | endif

set guifont=Hurmit\ Nerd\ Font
let g:airline_powerline_fonts = 1
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" loading the plugin 
let g:webdevicons_enable = 1
" adding the flags to NERDTree 
let g:webdevicons_enable_nerdtree = 1
" adding the custom source to unite 
let g:webdevicons_enable_unite = 1
" adding the column to vimfiler 
let g:webdevicons_enable_vimfiler = 1
" adding to vim-airline's tabline 
let g:webdevicons_enable_airline_tabline = 1
" adding to vim-airline's statusline 
let g:webdevicons_enable_airline_statusline = 1
" ctrlp glyphs
let g:webdevicons_enable_ctrlp = 1
" adding to flagship's statusline 
let g:webdevicons_enable_flagship_statusline = 1
" turn on/off file node glyph decorations (not particularly useful)
let g:WebDevIconsUnicodeDecorateFileNodes = 1
" use double-width(1) or single-width(0) glyphs 
" only manipulates padding, has no effect on terminal or set(guifont) font
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1
" whether or not to show the nerdtree brackets around flags 
let g:webdevicons_conceal_nerdtree_brackets = 1
" the amount of space to use after the glyph character (default ' ')
let g:WebDevIconsNerdTreeAfterGlyphPadding = '  '
" Force extra padding in NERDTree so that the filetype icons line up vertically 
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1

" ==========NERD COMMENTER==========
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code
" indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" ==========CTRLP==========
" Setup some default ignores
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}
" If a file is already open, open it again in a new pane 
" instead of switching to the existing pane
let g:ctrlp_switch_buffer = 'et'

" Use the nearest .git directory as the cwd
" This makes a lot of sense if you are working on a project that is in version
" control. It also supports works with .svn, .hg, .bzr.
let g:ctrlp_working_path_mode = 'r'

" Ignore files
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|swp)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Use a leader instead of the actual named binding
nmap <leader>p :CtrlP<cr>

" Easy bindings for its various modes
nmap <leader>bb :CtrlPBuffer<cr>
nmap <leader>bm :CtrlPMixed<cr>
nmap <leader>bs :CtrlPMRU<cr>
