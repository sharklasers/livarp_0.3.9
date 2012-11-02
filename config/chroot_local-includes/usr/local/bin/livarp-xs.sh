#!/bin/bash
# livarp-xs
# a simple script to launch livarp-xs-maker
# depends on zenity
# arpinux@2012

# this script is not available in live-session
# ----------------------------------------------------------------------
if [ -d /home/user ]; then
    zenity --info --text "this script is not available in live session" &
    exit
fi

# run only once
# ----------------------------------------------------------------------
if [ -e /usr/share/livarp/livarp-xs ]; then
    zenity --info --text "this script has been executed\n you are in livarp-xs :)" &
    exit
fi

# launch livarp-xs-maker
# ----------------------------------------------------------------------
exec urxvtc -e su-to-root -c /usr/local/bin/livarp-xs-maker/livarp-xs-maker.sh

# eof ------------------------------------------------------------------
