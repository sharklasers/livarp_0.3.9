#!/bin/bash
# livarp-xs maker
# compiz section

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

# compiz stuff
# ----------------------------------------------------------------------
echo ""
echo " ---delete compiz session-----------------------------------------"
echo ""
echo " remove compiz system files."
sleep 2s
apt-get autoremove -y --force-yes compiz compiz-fusion-plugins-main compiz-fusion-plugins-extra compizconfig-settings-manager libdecoration0
echo ""
echo " remove emerald system files."
sleep 2s
rm /usr/bin/emerald
rm /usr/bin/emerald-theme-manager
rm -R -f /usr/lib/emerald
rm /usr/lib/libemeraldengine.so.0
rm /usr/lib/libemeraldengine.so.0.0.0
rm /usr/lib/mime/packages/emerald
rm -R -f /usr/share/emerald
rm -R -f /usr/share/doc/emerald
rm -R -f /usr/share/doc/libemeraldengine0
rm /usr/share/man/man1/emerald-theme-manager.1.gz
rm /usr/share/man/man1/emerald.1.gz
rm /usr/share/mime-info/emerald.mime
echo ""
echo " remove startup script, config and conky."
sleep 2s
rm $HOME/bin/start/compiz_start.sh
rm $HOME/.conky/.conkyrc_compiz
rm -R -f $HOME/.config/compiz/compizconfig
rm -R -f $HOME/.emerald
echo ""
echo " compiz session removed "
sleep 2s

#eof--------------------------------------------------------------------
