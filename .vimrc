"    .vimrc
"
"    Morten Bojsen-Hansen <morten@alas.dk>
"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-plug plugin manager
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible' " sensible defaults
Plug 'bling/vim-airline' " pretty prompt
Plug 'kien/ctrlp.vim' " fuzzy search for files, buffers etc.
Plug 'nanotech/jellybeans.vim' " dark color scheme
Plug 'tpope/vim-commentary' " easily comments using gc
Plug 'moll/vim-bbye' " delete buffers without messing up your layout
Plug 'airblade/vim-gitgutter' " show added, deleted and modified lines from Git
Plug 'rking/ag.vim' " the_silver_surfer 'ag'
Plug 'kana/vim-textobj-user' " user-defined text objects
Plug 'Julian/vim-textobj-variable-segment' " snake_case and camelCase (v)
Plug 'sgur/vim-textobj-parameter' " function arguments (,)
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
set splitbelow " new window appears below in horizontal split
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
colorscheme jellybeans " My favourite color scheme

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text formatting and layout
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set cindent " enable C-style indention (works for other languages too)
set noexpandtab " do not expand tabs to spaces.
set shiftwidth=3 " number of spaces to use for each step of (auto)indent.
set tabstop=3 " set the number of spaces a TAB counts for.
set nowrap " disable wrapping of lines.
set pastetoggle=<F11> " toggle paste-mode with F11
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
" Backup
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set backup " always keep a backup of edited files
set backupdir=~/.backup/ " Directory to store backup files in
set updatetime=750 " how often to save swap file in ms (and update gitgutter signs)

" suffix all backups with the current date and time
au BufWritePre * let &backupext = ' ~ ' . strftime("%d-%m-%Y %X")

" create ~/.backup/ if it doesn't already exist
if has("unix")
    if !isdirectory(expand("~/.backup/"))
        !mkdir -p ~/.backup/
    endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Convenience mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

nnoremap <S-h> :bp<CR>
nnoremap <S-l> :bn<CR>
nnoremap <C-d> :Bdelete<CR>
nnoremap <C-c> <C-w><C-c>
nnoremap <F8> :Make<CR>

nnoremap <C-b> :CtrlPBuffer<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug-ins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" airline
let g:airline_powerline_fonts = 1 " use powerline fonts
let g:airline#extensions#tabline#enabled = 1 " show buffers

" csupport |DATE| format
let g:C_FormatDate = "%d-%m-%Y"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" avoid stupid 'hit enter' prompt on :make
"command! Make silent make | redraw!

" use waf for :make if available
if filereadable(getcwd() . "/waf")
  set makeprg=./waf\ release_build
endif

" use C++-style comments
autocmd FileType cpp set commentstring=\/\/%s
