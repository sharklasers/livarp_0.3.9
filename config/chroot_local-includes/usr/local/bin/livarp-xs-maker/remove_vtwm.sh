#!/bin/bash
# livarp-xs maker
# vtwm section

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

# vtwm stuff
# ----------------------------------------------------------------------
echo ""
echo " ---delete vtwm session-------------------------------------------"
echo ""
echo " remove vtwm system files."
sleep 2s
apt-get autoremove -y --force-yes vtwm
rm /usr/local/bin/vtwm_keys.sh
echo ""
echo " remove startup script, config and conky."
sleep 2s
rm $HOME/bin/start/vtwm_start.sh
rm $HOME/.vtwmrc
rm $HOME/.conky/.conkyrc_vtwm
echo ""
echo " vtwm session removed "
sleep 2s

#eof--------------------------------------------------------------------
