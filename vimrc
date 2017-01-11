filetype off
set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set showmatch
set history=200
set undolevels=200
set pastetoggle=<F2>
set relativenumber
set number
" ==============LEADER============
let mapleader = ','
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
nnoremap <leader>a :Ag<space>
nnoremap <Leader>q :Bdelete<CR>
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>CC :CtrlPClearCache<CR>:CtrlP<CR>
nnoremap <leader>] :TagbarToggle<CR>
nnoremap <leader>g :GitGutterToggle<CR>
nnoremap <leader>u :UndotreeToggle<cr>
noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
nnoremap <leader>bq :Bdelete<CR>

" in case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %

if filereadable(expand("~/.vimrc.bundles"))
	source ~/.vimrc.bundles
endif
" ===Set Filetype After Plug===
filetype plugin indent on
syntax on
set fileencodings=utf-8
set encoding=utf-8
set tenc=utf-8
" ===========COLOR SCHEME============
" au BufReadPost,BufNewFile *.twig colorscheme koehler
" au BufReadPost,BufNewFile *.css colorscheme slate
" au BufReadPost,BufNewFile *.js colorscheme slate2
" au BufReadPost,BufNewFile *.py colorscheme molokaiyo
" au BufReadPost,BufNewFile *.html colorscheme monokai
" au BufReadPost,BufNewFile *.java colorscheme monokai
" ====Commenting blocks of code=====
" This specifies the comment character when specifying block comments.
autocmd FileType c,cpp,java,scala let b:comment_leader = '//'
autocmd FileType sh,ruby,python   let b:comment_leader = '#'
autocmd FileType conf,fstab       let b:comment_leader = '#'
autocmd FileType tex              let b:comment_leader = '%'
autocmd FileType mail             let b:comment_leader = '>'
autocmd FileType vim              let b:comment_leader = '"'
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
		" nnoremap \ :Ag<SPACE>
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

" =========AIRLINE==========
let g:airline_powerline_fonts = 1
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" Show buffer number
let g:airline#extensions#tabline#buffer_nr_show = 0

" =========NERD TREE=============
" open NERDTree automatically when vim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") &&b:NERDTree.isTabTree()) | q | endif

set guifont=Hurmit\ Nerd\ Font

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
let g:WebDevIconsUnicodeGlyphDoubleWidth = 0
" whether or not to show the nerdtree brackets around flags 
let g:webdevicons_conceal_nerdtree_brackets = 1
" the amount of space to use after the glyph character (default ' ')
let g:WebDevIconsNerdTreeAfterGlyphPadding = ''
" Force extra padding in NERDTree so that the filetype icons line up vertically 
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1

" ==========NERD COMMENTER==========
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
set laststatus=2
set statusline=
set statusline +=%1*\ %n\ %*            "buffer number
set statusline +=%5*%{&ff}%*            "file format
set statusline +=%3*%y%*                "file type
set statusline +=%4*\ %<%F%*            "full path
set statusline +=%2*%m%*                "modified flag
set statusline +=%1*%=%5l%*             "current line
set statusline +=%2*/%L%*               "total lines
set statusline +=%1*%4v\ %*             "virtual column number
set statusline +=%2*0x%04B\ %*          "character under cursor"

let g:ycm_register_as_syntastic_checker = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" ==========CTRLP==========
" If a file is already open, open it again in a new pane 
" instead of switching to the existing pane
let g:ctrlp_switch_buffer = 'et'
" Look for filenames
let g:ctrlp_by_filename = '1'
" Use the nearest .git directory as the cwd
" This makes a lot of sense if you are working on a project that is in version
" control. It also supports works with .svn, .hg, .bzr.
let g:ctrlp_working_path_mode = 'r'

" Ignore files
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
" let g:ctrlp_user_command = 'find %s -type f'
let g:ctrlp_match_window = 'order:ttb,max:20'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}
" Make CTRL+B open buffers
nnoremap <C-b> :CtrlPBuffer<CR>
" Make CTRL+F open Most Recently Used files
nnoremap <C-f> :CtrlPMRU<CR>
"============TMUX============
" Enable basic mouse behavior such as resizing buffers.
set mouse=a
if exists('$TMUX')  " Support resizing in tmux
  set ttymouse=xterm2
endif
" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" Fix Cursor in TMUX
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

autocmd FileType java setlocal omnifunc=javacomplete#Complete

let &titlestring = expand('%:p')
set title

set tags=./.git/tags,tags;$HOME
set tags+=$HOME/tags/java.tags
set autochdir

" ============MARKDOWN=============
let g:vim_markdown_folding_style_pythonic = 4
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_json_frontmatter = 1

" ===========JSX==================
" you would like JSX in .js files
let g:jsx_ext_required = 0
" Restrict JSX to files with the pre-v0.12 @jsx React.DOM pragma
let g:jsx_pragma_required = 1
" =====For plugin/autoswap.vim===
set title titlestring=
" ========XML Highlighting=======
au BufReadPost *.jxml set syntax=javascript

"enable keyboard shortcuts
let g:tern_map_keys=1
"show argument hints
let g:tern_show_argument_hints='on_hold'

" Highlight current line number {{{
hi CursorLineNR cterm=bold ctermfg=220
augroup CLNRSet
	autocmd! ColorScheme * hi CursorLineNR cterm=bold ctermfg=220
	augroup END
" }}}
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

nmap <leader>jI <Plug>(JavaComplete-Imports-AddMissing)
nmap <leader>jR <Plug>(JavaComplete-Imports-RemoveUnused)
nmap <leader>ji <Plug>(JavaComplete-Imports-AddSmart)
nmap <leader>jii <Plug>(JavaComplete-Imports-Add)

imap <C-j>I <Plug>(JavaComplete-Imports-AddMissing)
imap <C-j>R <Plug>(JavaComplete-Imports-RemoveUnused)
imap <C-j>i <Plug>(JavaComplete-Imports-AddSmart)
imap <C-j>ii <Plug>(JavaComplete-Imports-Add)

nmap <leader>jM <Plug>(JavaComplete-Generate-AbstractMethods)

imap <C-j>jM <Plug>(JavaComplete-Generate-AbstractMethods)

nmap <leader>jA <Plug>(JavaComplete-Generate-Accessors)
nmap <leader>js <Plug>(JavaComplete-Generate-AccessorSetter)
nmap <leader>jg <Plug>(JavaComplete-Generate-AccessorGetter)
nmap <leader>ja <Plug>(JavaComplete-Generate-AccessorSetterGetter)
nmap <leader>jts <Plug>(JavaComplete-Generate-ToString)
nmap <leader>jeq <Plug>(JavaComplete-Generate-EqualsAndHashCode)
nmap <leader>jc <Plug>(JavaComplete-Generate-Constructor)
nmap <leader>jcc <Plug>(JavaComplete-Generate-DefaultConstructor)

imap <C-j>s <Plug>(JavaComplete-Generate-AccessorSetter)
imap <C-j>g <Plug>(JavaComplete-Generate-AccessorGetter)
imap <C-j>a <Plug>(JavaComplete-Generate-AccessorSetterGetter)

vmap <leader>js <Plug>(JavaComplete-Generate-AccessorSetter)
vmap <leader>jg <Plug>(JavaComplete-Generate-AccessorGetter)
vmap <leader>ja <Plug>(JavaComplete-Generate-AccessorSetterGetter)

" Python
set foldmethod=indent
set foldnestmax=2
set foldlevel=4
let g:pymode = 1
let g:pymode_warnings = 1
let g:pymode_trim_whitespaces = 1
let g:pymode_options = 1
let g:pymode_options_max_line_length = 79
let g:pymode_folding = 4
let g:pymode_motion = 1
let g:pymode_doc = 1
let g:pymode_virtualenv = 1
let g:pymode_virtualenv_path = $VIRTUAL_ENV
let g:pymode_run = 1
let g:pymode_run_bind = '<leader>r'
let g:pymode_breakpoint_bind = '<leader>b'
let g:pymode_breakpoint_cmd = ''
let g:pymode_lint = 1
let g:pymode_lint_unmodified = 0
let g:pymode_lint_on_fly = 0
let g:pymode_lint_message = 1
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mccabe']
let g:pymode_lint_sort = ['E', 'C', 'I']
let g:pymode_lint_cwindow = 1
let g:pymode_lint_signs = 1

let g:pymode_rope = 1
" Completion
let g:pymode_rope_completion = 1
let g:pymode_rope_completion_bind = '<C-Space>'
let g:pymode_rope_complete_on_dot = 1
let g:pymode_rope_autoimport_modules = ['os', 'shutil', 'datetime']
let g:pymode_rope_autoimport_import_after_complete = 0

" Follow symlinks when opening a file {{{
" NOTE: this happens with directory symlinks anyway
\ (due to Vim's chdir/getcwd magic when getting filenames).
" Sources:
"  https://github.com/tpope/vim-fugitive/issues/147#issuecomment-7572351
"  http://www.reddit.com/r/vim/comments/yhsn6/is_it_possible_to_work_around_the_symlink_bug/c5w91qw
function! MyFollowSymlink(...)
	if exists('w:no_resolve_symlink') && w:no_resolve_symlink
		return
	endif
	let fname = a:0 ? a:1 : expand('%')
	if fname =~ '^\w\+:/'
		" Do not mess with 'fugitive://' etc.
		return
	endif
	let fname = simplify(fname)

	let resolvedfile = resolve(fname)
	if resolvedfile == fname
		return
	endif
	let resolvedfile = fnameescape(resolvedfile)
	let sshm = &shm
	set shortmess+=A  " silence ATTENTION message about swap file (would get displayed twice)
	exec 'file ' . resolvedfile
	let &shm=sshm

	" Re-init fugitive.
	call fugitive#detect(resolvedfile)
	if &modifiable
		" Only display a note when editing a file, especially not for `:help`.
		redraw  " Redraw now, to avoid hit-enter prompt.
		echomsg 'Resolved symlink: =>' resolvedfile
	endif
endfunction
command! FollowSymlink call MyFollowSymlink()
command! ToggleFollowSymlink let w:no_resolve_symlink = !get(w:, 'no_resolve_symlink', 0) | echo "w:no_resolve_symlink =>" w:no_resolve_symlink
au BufReadPost * nested call MyFollowSymlink(expand('%'))
"}}}
