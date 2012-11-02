#!/bin/sh

ACTION=`zenity --width=90 --height=255 --list --radiolist --text="Select an action" --title="Logout" --column "Choice" --column "Action" TRUE Shutdown FALSE Reboot FALSE Suspend FALSE Hibernate FALSE Lock FALSE Logout`

if [ -n "${ACTION}" ];then
  case $ACTION in
  Shutdown)
    dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop
    ;;
  Reboot)
    dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart
    ;;
  Lock)
    xscreensaver-command -lock
    ;;
  Suspend)
   dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Suspend
   ;;
  Hibernate)
   dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Hibernate
   ;;
  Logout)
   xdotool key Ctrl+Alt+BackSpace
   ;;
  esac
fi
