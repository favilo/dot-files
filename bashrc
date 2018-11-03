# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1
HISTFILESIZE=-1

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
    xterm) color_prompt=yes;;
    screen) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    if [[ -e ~/.short.pwd.py ]]; then
        PROMPT_COMMAND='PS1="$(python ~/.short.pwd.py)"'
    else
	PS1='${debian_chroot:+($debian_chroot)}\D{%F %R} \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\D{%F %R} \u@\h:\w\n\$ '
fi
unset color_prompt force_color_prompt

PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ -f ~/.config/exercism/exercism_completion.bash ]; then
  . ~/.config/exercism/exercism_completion.bash
fi


# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias tmux='TERM=xterm-256color tmux -2'
alias ta='TERM=xterm-256color tmux -2 attach-session'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

PAGER=less


alias hex='printf "%x\n"'



bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOC":forward-word'
bind '"\eOD":backward-word'


export GOPATH=$HOME/go
export LGOPATH=$HOME/lgo
export PATH=$PATH:/usr/games
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:~/bin:~/.local/bin
export PATH=$PATH:/opt/android-studio/bin
export PATH=$JAVA_HOME/jre/bin:$PATH
export PATH=$PATH:/usr/lib/go-1.8/bin
export PATH="$PATH:$HOME/istio-0.6.0/bin"
export PATH="$PATH:/usr/local/cuda-9.1/bin"

export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

if [ -n "$DISPLAY" ] ; then export G4MULTIDIFF=1 ; fi
export P4MERGE='bash -c "chmod u+w \$1 ; meld \$2 \$1 \$3 ; cp \$1 \$4" padding-to-occupy-argv0'

export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export EDITOR=vim

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [ -d "$HOME/google-cloud-sdk" ]; then
    # The next line updates PATH for the Google Cloud SDK.
    source "$HOME/google-cloud-sdk/path.bash.inc"

    # The next line enables shell command completion for gcloud.
    source "$HOME/google-cloud-sdk/completion.bash.inc"
fi

# Codi
# Usage: codi [filetype] [filename]
codi() {
  local syntax="${1:-python}"
  shift
  vim -c \
    "let g:startify_disable_at_vimenter = 1 |\
    set bt=nofile ls=0 noru nonu nornu |\
    hi ColorColumn ctermbg=NONE |\
    hi VertSplit ctermbg=NONE |\
    hi NonText ctermfg=0 |\
    Codi $syntax" "$@"
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f /home/klah/google-cloud-sdk/path.bash.inc ]; then
  source '/home/klah/google-cloud-sdk/path.bash.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /home/klah/google-cloud-sdk/completion.bash.inc ]; then
  source '/home/klah/google-cloud-sdk/completion.bash.inc'
fi

gaiafromemail() {
 command /home/build/static/projects/gaia/gaiaclient/GaiaClient.par --gaia_instance=prod LookupUser $1 | grep UserID
}

gaiafromdevemail() {
 command /home/build/static/projects/gaia/gaiaclient/GaiaClient.par --gaia_instance=test LookupUser $1 | grep UserID
}


emailfromgaia() {
 command /home/build/static/projects/gaia/gaiaclient/GaiaClient.par --gaia_instance=prod LookupUserByID $1 | grep "^Email\:"
}

PSH_VLC=vlc
vlc2mp3 () 
{ 
   ( set -x;
   local stream=$1;
   local output=$2;
   ${PSH_VLC} -vvv "${stream}" --sout="#transcode{acodec=mp3,ab=128,vcodec=dummy}:std{access=file,mux=raw,dst=${output}" vlc://quit )
}
source <(kubectl completion bash)

##
# Load any extra Bash profile scripts
##
if [[ -d ~/.profile.d ]]; then
	for f in ~/.profile.d/*.bash; do
		. "$f"
	done
fi

source /home/klah/git/games/emsdk/emsdk_env.sh
export ANDROID_NDK_ROOT=/home/klah/Android/Sdk/ndk-bundle/
export ANDROID_HOME=/home/klah/Android/Sdk/
. /home/klah/miniconda3/etc/profile.d/conda.sh
