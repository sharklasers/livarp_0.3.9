#! /bin/bash
##############################
# ~/.xinitrc by arpinux 2012 #
##############################

## D-Bus ##
if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
        eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

## clean-up conky deamon ##
killall conky &
killall conkyd &

## dualscreen ##
#~/bin/dualdetect.sh

## trackpad ## tapbutton off by default ##
if egrep -iq 'touchpad' /proc/bus/input/devices; then
    synclient VertTwoFingerScroll=1
    synclient HorizTwoFingerScroll=1
    synclient TapButton1=0
fi

## read ~.Xresources file ##
xrdb -merge ~/.Xresources

## enable snap font ##
xset fp+ /usr/share/fonts/livarp_fonts/artwiz-latin1/
xset fp rehash

## launch terminal deamon ##
urxvtd -q -f -o

## launch screensaver ##
xscreensaver-command -exit
xscreensaver -no-splash &

## set cursor ##
xsetroot -cursor_name left_ptr

## set ctrl_alt_bksp as session-killer ##
setxkbmap -option terminate:ctrl_alt_bksp

## startup-wall - customize your start-screen ##
feh --no-xinerama --bg-fill /usr/share/backgrounds/livarp_start.png

## keyboard-selector ##
## safe to remove after installation
if [ -d /home/user ]; then
    zenity --entry --title='keyboard-selector' --text='livarp keyboard selector\nselect or type your country code' \fr be es gb us ru | xargs setxkbmap
fi

#-----------------------------------------------------------------------

## launch single session ##
## replace "your-wm" by your favorite window-manager
#exec ck-launch-session ~/bin/start/your-wm_start.sh

## launch session selector script
exec /usr/local/bin/session_selector.sh
