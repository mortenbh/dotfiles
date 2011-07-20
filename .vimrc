"    .vimrc
"
"    Morten Bojsen-Hansen <morten@alas.dk>
"
"    Last modified: 20-07-2011 18:31:05
"
"    This requires Debian packages:
"    * vim-addon-manager
"    * vim-scripts
"    
"    $ aptitude install vim-addon-manager vim-scripts
"    
"    And requires vim addons:
"    * colors sampler pack
"    * minibufexplorer
"    
"    $ vim-addons install "colors sampler pack" minibufexplorer    

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible " don't emulate vi's limitations and quirks
set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
filetype plugin indent on " automatically load indent and plugins for detected filetype
"set clipboard=unnamed " yank and put to OS-wide clipboard

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
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set listchars=tab:»·,trail:· " how to display tabs and trailing spaces in list mode (:set list)
set statusline=%t\ (%Y)%=\ %m%r\ %c-%l/%L\ (%P) " status-line format 
set laststatus=2 " always show the status-line
set guioptions-=T " remove toolbar

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
"set autoindent " copy indent from current line when starting a new line.
set cindent " enable C-style indention (works for other languages too)
set noexpandtab " do not expand tabs to spaces.
set shiftwidth=3 " number of spaces to use for each step of (auto)indent.
set tabstop=3 " set the number of spaces a TAB counts for.
set nowrap " disable wrapping of lines.
"set textwidth=110 " automatically insert newline after 110 characters
set smarttab " hmm.. :)
set pastetoggle=<F11> " toggle paste-mode with F11
let c_space_errors = 1 " highlight trailing spaces and more for c/cpp

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File format, encoding and types
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set fileformat=unix " default file format
set encoding=utf-8 " default encoding

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
nnoremap <C-right> :bn<CR>
nnoremap <C-left> :bp<CR>
nnoremap <C-w>c :bd<CR>
nnoremap <C-w>q :bd<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" workaround for messed up background colour when quitting vim in screen
if !has("gui_running")
	au VimLeave * :set term=screen
endif

" make selected tab in minibufexpl stand out more
highlight link MBEVisibleNormal Error
highlight link MBEVisibleChanged Error

" updates last modified date and time within the first 10 lines
function! UpdateLastModified()
	let m = 1
	let n = min([10,line('$')])
	let cmd = 's/\(Last modified:\).*/\="Last modified: ".strftime("%d-%m-%Y %X")/e'
	exe m . ',' . n . cmd
endfunction
au BufWritePre * call UpdateLastModified()

" tabline silliness
"set guioptions-=e " non-gui tabline
"set showtabline=2 " always show tabline
"let g:TabLineSet_buffers_list=1
