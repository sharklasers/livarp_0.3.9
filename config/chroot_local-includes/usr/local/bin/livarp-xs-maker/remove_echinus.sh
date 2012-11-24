#!/bin/bash
# livarp-xs maker
# echinus section

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

# echinus stuff
# ----------------------------------------------------------------------
echo ""
echo " ---delete echinus session----------------------------------------"
echo ""
echo " remove echinus system files."
sleep 2s
rm /usr/local/bin/echinus
rm /usr/local/bin/echinus_keys.sh
rm -R -f /usr/share/doc/echinus
rm /usr/share/man/man1/echinus.1
rm -R -f /etc/skel/.echinus
echo ""
echo " remove startup script, dzenbar and conky."
sleep 2s
rm $HOME/bin/start/echinus_start.sh
rm $HOME/bin/dzenbar.sh
rm $HOME/bin/dzenbar_reload.sh
rm $HOME/.conky/.conkyrc_dzen
echo ""
echo " echinus session removed "
sleep 2s

#eof--------------------------------------------------------------------
