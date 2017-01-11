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
set pastetoggle=<f2>
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
nnoremap <leader>CC :CtrlPClearCache<CR>:CtrlP<CR>
nnoremap <leader>] :TagbarToggle<CR>
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
set backspace=indent,eol,start
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

set laststatus=2
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

" Delete all hidden buffers
nnoremap <silent> <Leader><BS> :call DeleteHiddenBuffers()<CR>
function! DeleteHiddenBuffers() " {{{
  let tpbl=[]
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    silent execute 'bwipeout' buf
  endfor
endfunction " }}}
