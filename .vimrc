"    .vimrc
"
"    Morten Bojsen-Hansen <morten@alas.dk>
"
"    Last modified: 21-05-2014 08:40:55
"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible " don't emulate vi's limitations and quirks
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()
filetype plugin indent on " automatically load indent and plugins for detected filetype

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim behaviour and UI
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildmenu " enhanced command-line auto-completion
set wildmode=full:longest " when auto-completing, show navigatable list and longest common prefix
set wildignore=CVS,.svn,.git,.hg,*.o,*.a,*.class,*.so,*.obj,*.swp,*.jpg,*.png,*.gif " ignore when auto-completing
set shellslash " always use forward slashes in command-line auto-completion
set lazyredraw " do not redraw while executing macros; much faster
set hidden " can change buffers without saving
set icon " let vim set the text of the window icon
set mouse=a " enable the use of mouse clicks in all modes
set number " line numbers
set showcmd " show (partial) commands as they are typed in right-most part of command-line
set showfulltag " show full tag pattern when completing tag from tagsfile (shows e.g. C parameters)
set showmode " show the active mode in the command-line
set scrolloff=10 " minimum number of screen lines to keep above and below the cursor
set cursorline " highlight line currently under the cursor
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set listchars=tab:»·,trail:· " how to display tabs and trailing spaces in list mode (:set list)
set statusline=%t\ (%Y)%=\ %m%r\ %c-%l/%L\ (%P) " status-line format 
set laststatus=2 " always show the status-line
set guioptions-=T " remove toolbar
set splitbelow " new window appears below in horizontal split
set splitright " new window appears to the right in vertical split

" automatically open/close quickfix window in full-width horizontal
au QuickFixCmdPost [^l]* nested botright cwindow
au QuickFixCmdPost    l* nested botright lwindow

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" History, marks and search
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set history=1000 " number of commands and search patterns remembered (and stored in viminfo)
set viminfo='1000 " number of files to store marks for in viminfo (see history)
set showmatch " show matching bracket
set nohlsearch " do not highlight searched for phrases
set incsearch " highlight match *while* typing search pattern
set smartcase " overrides ignorecase if search pattern contains upper-case
set ignorecase " ignore case in searches

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Themes and colours
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable " Enable syntax highlighting.
colorscheme jellybeans " My favourite color scheme

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text formatting and layout
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set cindent " enable C-style indention (works for other languages too)
set noexpandtab " do not expand tabs to spaces.
set shiftwidth=3 " number of spaces to use for each step of (auto)indent.
set tabstop=3 " set the number of spaces a TAB counts for.
set nowrap " disable wrapping of lines.
set smarttab " hmm.. :)
set pastetoggle=<F11> " toggle paste-mode with F11
let c_space_errors = 1 " highlight trailing spaces and more for c/cpp

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File format, encoding and types
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set fileformat=unix " default file format
set encoding=utf-8 " default encoding
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
" updates last modified date and time within the first 10 lines
function! UpdateLastModified()
	let m = 1
	let n = min([10,line('$')])
	let cmd = 's/\(Last modified:\).*/\="Last modified: ".strftime("%d-%m-%Y %X")/e'
	exe m . ',' . n . cmd
endfunction
au BufWritePre * call UpdateLastModified()

" avoid stupid 'hit enter' prompt on :make
"command! Make silent make | redraw!

" use waf for :make if available
if filereadable(getcwd() . "/waf")
  set makeprg=./waf\ release_build
endif

" use C++-style comments
autocmd FileType cpp set commentstring=\/\/%s
