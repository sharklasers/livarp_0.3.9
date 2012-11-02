# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set human
# HUMAN=`w -h | tail -n1 | awk '{print $1}'`

# Si on est dans une console, et qu'aucune
# instance de X n'est détecté, demander si
# startx doit être lancé
#if [[ -t 0 && $(tty) =~ /dev/tty ]] && ! pgrep -u $USER startx &> /dev/null; then
#    echo " bienvenue sur livarp, $HUMAN"
#    echo " on lance X [O|n] >>"
#    read choix
#	case $choix in
#	O)
#		startx
#		;;
#    n)
#		clear
#		echo "if there is a shell ... there is a way"
#		echo ""
#		;;
#	*)
#		startx
#		;;
#	esac
#fi

# startx automatique
if [[ -t 0 && $(tty) =~ /dev/tty ]] && ! pgrep -u $USER startx &> /dev/null; then
    startx
fi
