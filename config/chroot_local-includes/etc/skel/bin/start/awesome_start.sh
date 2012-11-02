#! /bin/bash
# arpinux awesome start-up script
#################################

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

## launch composite manager --------------------------------------------
#xcompmgr -fF &
#xcompmgr -cCfF -I20 -O10 -D1 -t-5 -l-5 -r4.2 -o.82

## setup auto-mounting -------------------------------------------------
sleep 10 && udisks-glue --session &

## set awesome wallpaper -----------------------------------------------
#nitrogen --restore ## uncomment to display our favorite wallpaper
feh --no-xinerama --bg-fill /usr/share/backgrounds/livarp_0.3.9_awesome.png

## launch conky --------------------------------------------------------
conky -q -c ~/.conky/.conkyrc_awesome &

## setup network -------------------------------------------------------
nm-applet &

## launch auto-hide text dock ------------------------------------------
#sleep 10s && ~/bin/tabdock.sh &

## launch awesome ------------------------------------------------------
exec awesome
