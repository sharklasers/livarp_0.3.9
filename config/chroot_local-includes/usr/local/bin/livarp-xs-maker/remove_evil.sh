#!/bin/bash
# livarp-xs maker
# evilwm section

# this script is not available in live-session
# ----------------------------------------------------------------------
if [ -d /home/user ]; then
    zenity --info --text "this script is not available in live session" &
    exit
fi

# are you root ?
# ----------------------------------------------------------------------
if [ "`whoami`" != "root" ]; then
    zenity --info --text "this script need admin power
    launch it as root" &
    exit
fi

# evil stuff
# ----------------------------------------------------------------------
echo ""
echo " ---delete evilwm session-----------------------------------------"
echo ""
echo " remove evilwm system files."
sleep 2s
apt-get autoremove -y --force-yes evilwm
rm /usr/local/bin/evil_keys.sh
rm /usr/share/applications/evilwm.desktop
rm /usr/share/man/man1/evilwm.1
echo ""
echo " remove startup script and conky."
sleep 2s
rm $HOME/bin/start/evil_start.sh
rm $HOME/.conky/.conkyrc_evil
echo ""
echo " evilwm session removed "
sleep 2s

#eof--------------------------------------------------------------------
