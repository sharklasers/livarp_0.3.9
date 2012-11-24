#!/bin/bash
# livarp-xs maker
# wmfs section

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

# wmfs stuff
# ----------------------------------------------------------------------
echo ""
echo " ---delete wmfs session-------------------------------------------"
echo ""
echo " remove wmfs system files."
sleep 2s
rm /usr/local/bin/wmfs
rm /usr/local/bin/shortcuts_help.sh
rm /usr/local/bin/keybind_help.sh
rm /usr/share/applications/wmfs.desktop
rm /usr/share/man/man1/wmfs.1
rm -R -f /etc/xdg/wmfs
rm -R -f /etc/skel/.config/wmfs
echo ""
echo " remove startup script, config and conky."
sleep 2s
rm $HOME/bin/start/wmfs_start.sh
rm -R -f $HOME/.config/wmfs
rm $HOME/.conky/.conkyrc_wmfs
echo ""
echo " wmfs session removed "
sleep 2s

#eof--------------------------------------------------------------------
