"    .vimrc
"
"    Morten Bojsen-Hansen <morten@alas.dk>
"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-plug plugin manager
call plug#begin('~/.vim/plugged')
if !has("nvim")
  Plug 'tpope/vim-sensible' " sensible defaults
endif

Plug 'tpope/vim-repeat' " more versatile repeat (.) command
Plug 'itchyny/lightline.vim' " light-weight prompt
Plug 'junegunn/fzf' " fzf fuzzy search for files, buffers etc.
Plug 'junegunn/fzf.vim' " fzf fuzzy search for files, buffers, inside files using :Ag etc.
Plug 'nanotech/jellybeans.vim' " dark color scheme
Plug 'tpope/vim-commentary' " comments using gc
Plug 'moll/vim-bbye' " delete buffers without messing up your layout
Plug 'cespare/vim-sbd' " alternative to vim-bbye
Plug 'airblade/vim-gitgutter' " show added, deleted and modified lines from Git
Plug 'noscript/vim-sleuth' " automatically detect and adjust indentation method
Plug 'justinmk/vim-sneak' " replacement for f and t (overrides s)
Plug 'tpope/vim-vinegar' " netrw enhancements
Plug 'jamessan/vim-gnupg' " transparently edit GnuPG (gpg|pgp|asc) encrypted files
Plug 'edkolev/promptline.vim' " zsh and fish airline integration
Plug 'SirVer/ultisnips' " snippit engine
" Plug 'myusuf3/numbers.vim' " relative line numbers in normal mode
Plug 'wellle/targets.vim' " overhaul text objects; e.g. da, or cin)
Plug 'tpope/vim-unimpaired' " ]q for :cnext, [b for :bprev, ]a for :next etc.
Plug 'tpope/vim-surround' " edit surrounds (cs, ds, ys etc.)
" Plug 'terryma/vim-expand-region' " press v repeatedly to expand visual mode selection
Plug 'Mizuchi/STL-Syntax' " C++ STL syntax highlighting
Plug 'leafgarland/typescript-vim' " Typscript syntax highlighting
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'junegunn/vim-peekaboo' " sidebar for ", @ and <CR-R>
Plug 'glts/vim-magnum' " big integer library (requirement for radical.vim)
Plug 'glts/vim-radical' " crd, crx, cro, crb converts the number under the cursor to decimal, hex, octal, binary, respectively.
" Plug 'Shougo/echodoc.vim' " show completions below the status bar
" Plug 'kopischke/vim-stay' " remember folds, cursor position, ...
" Plug 'kopischke/vim-fetch' " make vim understand file.ext:12:3, useful for gF

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim behaviour and UI
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildmode=full:longest " when auto-completing, show navigatable list and longest common prefix
set wildignore=CVS,.svn,.git,.hg,*.o,*.a,*.class,*.so,*.obj,*.swp,*.jpg,*.png,*.gif " ignore when auto-completing
set shellslash " always use forward slashes in command-line auto-completion
set lazyredraw " do not redraw while executing macros; much faster
set hidden " can change buffers without saving
set icon " let vim set the text of the window icon
set mouse=a " enable the use of mouse clicks in all modes
set number " line numbers
set showfulltag " show full tag pattern when completing tag from tagsfile (shows e.g. C parameters)
set showmode " show the active mode in the command-line
set scrolloff=10 " minimum number of screen lines to keep above and below the cursor
set cursorline " highlight line currently under the cursor
set guioptions-=T " remove toolbar
"set splitbelow " new window appears below in horizontal split
set splitright " new window appears to the right in vertical split

" automatically open/close quickfix window in full-width horizontal
au QuickFixCmdPost [^l]* nested botright cwindow
au QuickFixCmdPost    l* nested botright lwindow

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" History, marks and search
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set showmatch " show matching bracket
set nohlsearch " do not highlight searched for phrases
set smartcase " overrides ignorecase if search pattern contains upper-case
set ignorecase " ignore case in searches

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Themes and colours
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" use the terminal's background color (for transparency)
let g:jellybeans_overrides = {
\    'background': { 'ctermbg': 'none', '256ctermbg': 'none', 'guibg': 'none', },
\}
set termguicolors " true color support
" let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=dark
colorscheme jellybeans " My favourite color scheme

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text formatting and layout
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" filetype plugin indent on
set expandtab " expand tabs to spaces.
set tabstop=4 " set the number of spaces a TAB counts for.
set shiftwidth=0 " use tabstop value
set nowrap " disable wrapping of lines.
set pastetoggle=<F11> " toggle paste-mode with F11
set cindent " good idea?
let c_space_errors = 1 " highlight trailing spaces and more for c/cpp

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File format, encoding and types
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set fileformat=unix " default file format
set autowrite " automatically write current file on :make

au BufRead,BufNewFile *.tex set textwidth=78 nocindent spell
au BufRead,BufNewFile *.markdown set filetype=mkd textwidth=78 nocindent spell
au BufRead,BufNewFile *.cl set filetype=opencl
au BufRead,BufNewFile wscript set filetype=python

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Backup, undo and swap
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set backup " always keep a backup of edited files
set backupdir=~/.vim/backup// " where to store backups
set directory=~/.vim/swap// " where to store swap files
set updatetime=750 " how often to save swap file in ms (and update gitgutter signs)
set undofile " persistent undo
set undodir=~/.vim/undo// " where to store undo files

" suffix all backups with the current date and time
au BufWritePre * let &backupext = '-' . strftime("%Y%m%d-%H%M%S")

" create ~/.backup/ if it doesn't already exist
if has("unix")
  if !isdirectory(expand("~/.vim/swap"))
    :silent !mkdir -p ~/.vim/swap/ > /dev/null 2>&1
  endif
  if !isdirectory(expand("~/.vim/backup"))
    :silent !mkdir -p ~/.vim/backup/ > /dev/null 2>&1
  endif
  if !isdirectory(expand("~/.vim/undo"))
    :silent !mkdir -p ~/.vim/undo/ > /dev/null 2>&1
  endif
endif

" store cursors and folds with :mkview (or with vim-stay)
set viewoptions=cursor,folds,slash,unix

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Convenience mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" make Y behave like C and D
map Y y$

let mapleader = "\<Space>"

nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

" save current file
nnoremap <leader>w :w<CR>
" nnoremap <leader>W :w!<CR>

" quitting
nnoremap <silent> <leader>q :Sbd<CR>

nnoremap <S-h> :vertical resize -3<cr>
nnoremap <S-j> :resize +5<cr>
nnoremap <S-k> :resize -5<cr>
nnoremap <S-l> :vertical resize +3<cr>

"nnoremap <C-b> :CtrlPBuffer<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>a :Ag<CR>

" mirror mappings from normal mode; useful when using block visual mode in vimdiff
xnoremap <silent> <leader>do :diffget<CR>:diffupdate<CR>
xnoremap <silent> <leader>dp :diffput<CR>:diffupdate<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug-ins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" csupport |DATE| format
let g:C_FormatDate = "%d-%m-%Y"

" 90% fuzz on hard/soft heuristics
let g:sleuth_trigger_ratio = 10
set completeopt-=preview

" Lightline
let g:lightline = {
\ 'colorscheme': 'wombat',
\ 'active': {
\   'left': [['mode', 'paste'], ['filename', 'modified']],
\   'right': [['lineinfo'], ['percent'], ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok']]
\ },
\ 'component_expand': {
\   'linter_warnings': 'LightlineLinterWarnings',
\   'linter_errors': 'LightlineLinterErrors',
\   'linter_ok': 'LightlineLinterOK'
\ },
\ 'component_type': {
\   'readonly': 'error',
\   'linter_warnings': 'warning',
\   'linter_errors': 'error'
\ },
\ }

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓ ' : ''
endfunction

autocmd User ALELint call s:MaybeUpdateLightline()

" Update and show lightline but only if it's visible (e.g., not in Goyo)
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" avoid stupid 'hit enter' prompt on :make
" (no longer a problem with vim-dispatch)
" command! -nargs=* Make silent make <args> | redraw!
command! -bang -nargs=* -complete=file Make AsyncRun -program=make -save=1 @ <args>
augroup vimrc
  autocmd User AsyncRunStart call asyncrun#quickfix_toggle(8, 1)
  autocmd User AsyncRunStart if &autowrite || &autowriteall | silent! wall | endif
augroup END

augroup QuickfixStatus
  au! BufWinEnter quickfix setlocal
	\ statusline=%t\ [%{g:asyncrun_status}]\ %{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}\ %=%-15(%l,%c%V%)\ %P
augroup END

" use waf for :make if available
if filereadable(getcwd() . "/waf")
  set makeprg=./waf
endif

" use C++-style comments
autocmd FileType cpp set commentstring=\/\/%s

" yank to system clipboard (e.g. <leader>yaW in normal mode)
nmap <leader>y "+y
vmap <leader>y "+y

" generate a password with pwgen
command! Pwgen execute 'normal i' . substitute(system('pwgen -sy 25 1'), '[\r\n]*$', '', '')

let g:netrw_list_hide= netrw_gitignore#Hide()

if !has('nvim')
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw
endif

set timeout ttimeoutlen=50

" hide quickfix from :bnext, :bprev
augroup QFix
  autocmd!
  autocmd FileType qf setlocal nobuflisted
augroup END
