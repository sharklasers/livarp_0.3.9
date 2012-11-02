#!/bin/bash
# livarp-xs maker
# fluxbox section

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

# fluxbox stuff
# ----------------------------------------------------------------------
echo ""
echo " ---delete fluxbox session----------------------------------------"
echo ""
echo " remove fluxbox system files."
sleep 2s
apt-get autoremove -y --force-yes fluxbox
rm -R -f /usr/share/fluxbox
echo ""
echo " remove startup script, config and conky."
sleep 2s
rm $HOME/bin/start/fluxbox_start.sh
rm -R -f $HOME/.fluxbox
rm $HOME/.conky/.conkyrc_fluxbox
echo ""
echo " fluxbox session removed "
sleep 2s

#eof--------------------------------------------------------------------
