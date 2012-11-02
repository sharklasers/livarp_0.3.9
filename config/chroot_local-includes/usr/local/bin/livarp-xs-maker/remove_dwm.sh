#!/bin/bash
# livarp-xs maker
# dwm section

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

# dwm stuff
# ----------------------------------------------------------------------
echo ""
echo " ---delete dwm session--------------------------------------------"
echo ""
echo " remove dwm system files."
sleep 2s
rm /usr/local/bin/dwm
rm /usr/local/bin/dwm_keys.sh
rm /usr/share/applications/dwm.desktop
rm /usr/share/man/man1/dwm.1
echo ""
echo " remove startup script and conky."
sleep 2s
rm $HOME/bin/start/dwm_start.sh
rm $HOME/.conky/.conkyrc_dwm
echo ""
echo " dwm session removed "
sleep 2s

#eof--------------------------------------------------------------------
