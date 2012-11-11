# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias starwars="telnet towel.blinkenlights.nl"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

complete -cf sudo

## extra functions -----------------------------------------------------

# extract archives -----------------------------------------------------
function extract()      
{
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xvjf $1     ;;
             *.tar.gz)    tar xvzf $1     ;;
             *.bz2)       bunzip2 $1      ;;
             *.rar)       unrar x $1      ;;
             *.gz)        gunzip $1       ;;
             *.tar)       tar xvf $1      ;;
             *.tbz2)      tar xvjf $1     ;;
             *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
             *.Z)         uncompress $1   ;;
             *.7z)        7z x $1         ;;
             *.xz)        unxz $1         ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# infos box ------------------------------------------------------------
# text colors
red='\e[0;31m'
blue='\e[0;34m'
cyan='\e[0;36m'
green='\e[0;32m'
yellow='\e[0;33m'
NC='\e[0m'              # No Color
# background colors
RED='\e[41m'
BLUE='\e[44m'
CYAN='\e[46m'
GREEN='\e[42m'
YELLOW='\e[43m'

function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }

function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }

function my_ip()
{ MY_IP=$(/sbin/ifconfig eth0 | awk '/inet/ { print $2 } ' | sed -e s/addr://) ; }
EXTIP=`wget -q -O - checkip.dyndns.org | sed -e 's/[^[:digit:]\|.]//g'`

function ii()
{
    echo -e "${RED} You are logged on:$NC " ; hostname
    echo -e "${RED} Additionnal information:$NC " ; uname -a
    echo -e "${RED} Users logged on:$NC " ; w -h
    echo -e "${RED} Current date :$NC " ; date
    echo -e "${CYAN} Machine stats :$NC " ; uptime
    echo -e "${GREEN} Memory stats :$NC " ; free
    my_ip 2>&- ;
    echo -e "${BLUE} Local IP Address :$NC" ; echo ${MY_IP:-"Not connected"}
    echo -e "${BLUE} External IP Address :$NC" ; echo ${EXTIP:-"Not connected"}
    echo -e "${BLUE} Open connections :$NC "; netstat -pan --inet;
    echo
}

# find -----------------------------------------------------------------
function ff() { find . -type f -iname '*'$*'*' -ls ; }

# generate space report ------------------------------------------------
function space() { du -skh * | sort -nr > $HOME/space_report.txt ; }

# generate a dated .bak from file --------------------------------------
function bak() { cp $1 $1_`date +%Y-%m-%d_%H:%M:%S`.bak ; }

# 
## ------------------------------------------------- end of functions ##

## prompt --------------------------------------------------------------
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
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
## chars
## ├ └ ┌ │ ─ ┬ 
#LOAD=`uptime | awk '{print $8 $9 $10}'`
#UPT=`uptime | awk '{print $3}'`
#DATE=`date +"%a%d/%m"`
#TIME=`date +"%H:%M:%S"`
# replace "sda3" by your root or home partition
#ROOT=`df -h|grep sda2|awk '{print $5}'`
#MEMU=`free -m | sed -n 's|^-.*:[ \t]*\([0-9]*\) .*|\1|gp'`
#MEMT=`free -m | sed -n 's|^M.*:[ \t]*\([0-9]*\) .*|\1|gp'`

if [ "$color_prompt" = yes ]; then
    # uncomment to enable custom-prompt
    #echo -en "┌─[\e[01;36m$DATE\e[m]─[\e[01;34m$UPT\e[m]─[\e[01;33m$(t | wc -l)tasks\e[m]\n└─[\e[1;32m$MEMU\e[m/\e[0;32m$MEMT\e[m]─[\e[01;31m$LOAD\e[m]\n"
    echo -en "\e[1;37mlivarp\e[m0.3.9\e[0;32mGNU/Linux\e[01;34mDebian\e[m\n"
    PS1='${debian_chroot:+($debian_chroot)}┌─[\e[01;32m\u\e[m@\e[0;36m\h\e[m]─[\e[01;34m\w\e[m]\n└─|$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
## -------------------------------------------- end of prompt section ##

export EDITOR="vim"
export BROWSER="luakit"
export PAGER="most"

PATH=$PATH:/usr/local/bin/
PATH=$PATH:/home/$USER/bin/
