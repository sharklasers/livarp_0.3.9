#!/bin/bash
# livarp-xs maker
# awesome section

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

# awesome stuff
# ----------------------------------------------------------------------
echo ""
echo " ---delete awesome session----------------------------------------"
echo ""
echo " remove awesome system files."
sleep 2s
apt-get autoremove -y --force-yes awesome awesome-extra
echo ""
echo " remove startup script, config and conky."
sleep 2s
rm $HOME/bin/start/awesome_start.sh
rm $HOME/bin/awesome_calendar.sh
rm $HOME/.conky/.conkyrc_awesome
rm -R -f $HOME/.config/awesome
rm -R -f /etc/skel/.config/awesome
echo ""
echo " awesome session removed "
sleep 2s

#eof--------------------------------------------------------------------
