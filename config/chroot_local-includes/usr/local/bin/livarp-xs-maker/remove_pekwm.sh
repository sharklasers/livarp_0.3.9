#!/bin/bash
# livarp-xs maker
# pekwm section

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

# pekwm stuff
# ----------------------------------------------------------------------
echo ""
echo " ---delete pekwm session------------------------------------------"
echo ""
echo " remove pekwm system files."
sleep 2s
apt-get autoremove -y --force-yes pekwm
rm -R -f /usr/share/pekwm
rm /usr/local/bin/pekwm_keys.sh
rm -R -f /etc/skel/.pekwm
echo ""
echo " remove startup script, config and conky."
sleep 2s
rm $HOME/bin/start/pekwm_start.sh
rm -R -f $HOME/.pekwm
rm $HOME/.conky/.conkyrc_pekwm
rm $HOME/.conky/.pek_rings.lua
echo ""
echo " pekwm session removed "
sleep 2s

#eof--------------------------------------------------------------------
