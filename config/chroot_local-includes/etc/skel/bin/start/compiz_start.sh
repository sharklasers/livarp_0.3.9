#! /bin/bash
# livarp_0.3.9 compiz start-up script
#####################################

## post-install script ## ----------------------------------------------
## safe to remove after execution
if ! [ -d /home/user ]; then
    if ! [ -e /usr/share/livarp/livarpfirstlog ]; then
        (sleep 10s && urxvtc -e su-to-root -c /usr/local/bin/livarp_postinstall.sh) &
    fi
fi

## launch mail-checker ## edit if needed -------------------------------
#if ping -c 1 -w 1 194.2.0.20 &>/dev/null; then
#    sleep 5 && claws-mail &
#fi

## change caps_lock into super key - for old laptop --------------------
#xmodmap ~/.Xmodmap

## launch panel --------------------------------------------------------
sleep 5 && fbpanel -p compiz &

## setup auto-mounting -------------------------------------------------
sleep 10 && udisks-glue --session &

## set compiz wallpaper ------------------------------------------------
#nitrogen --restore ## uncomment to display our favorite wallpaper
feh --no-xinerama --bg-fill /usr/share/backgrounds/livarp_0.3.9_compiz.png

## launch conky --------------------------------------------------------
sleep 3 && conky -q -c ~/.conky/.conkyrc_compiz &

## setup network -------------------------------------------------------
nm-applet &

## dock minimal --------------------------------------------------------
#sleep 10s && ~/bin/tabdock.sh &

## launch compiz -------------------------------------------------------
exec compiz ccp
