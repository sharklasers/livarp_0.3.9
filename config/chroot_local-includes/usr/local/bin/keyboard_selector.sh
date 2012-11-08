#! /bin/bash
# simple keyboard-selector
# launch it from ~/.xinitrc
ACTION=`zenity --width=0 --height=176 --list\
            --title "SelectKbd" --text "select your keyboard"\
            --column "layout"\
            "fr"\
            "gb"\
            "us"\
            "de"`

if [ -n "${ACTION}" ]; then
    case $ACTION in
        fr)
            setxkbmap fr
            ;;
        gb)
            setxkbmap gb
            ;;
        us)
            setxkbmap us
            ;;
        de)
            setxkbmap de
            ;;
    esac
fi
