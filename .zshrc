#    .zshrc
#
#    Morten Bojsen-Hansen <morten@alas.dk>
#
#    Last modified: 06-03-2011 03:15:36 PM

################################################################################
# Prompt
################################################################################
setopt PROMPTSUBST
autoload -U promptinit
autoload -U vcs_info
promptinit
prompt physosvcs magenta magenta blue white

################################################################################
# History
################################################################################
HISTFILE=~/.histfile # history file
HISTSIZE=10000 # in-memory history
SAVEHIST=1000 # history to save
setopt INC_APPEND_HISTORY # append to history incrementally instead of overwriting
setopt HIST_FCNTL_LOCK # lock using fcntl if available
setopt HIST_IGNORE_ALL_DUPS # no duplicates in history (old deleted)

################################################################################
# Misc
################################################################################
setopt AUTOCD # omitting a command automatically assumes cd
setopt EXTENDEDGLOB # extended glob patterns
unsetopt BEEP # no beeping
#bindkey -v # vim-style key bindings
bindkey -e # emacs-style key bindings

# compinit stuff...
zstyle :compinstall filename '/home/mortenbh/.zshrc'
autoload -Uz compinit
compinit

################################################################################
# Aliases
################################################################################
alias ls='ls --color=always'
alias ll='ls -lh'
alias lla='ll -a'

alias grep='grep --color=always'
alias fgrep='fgrep --color=always -n'

alias less='zless' # use zless always
alias zless='zless -R' # display piped colors

alias rsync='rsync --partial --progress --human-readable'
