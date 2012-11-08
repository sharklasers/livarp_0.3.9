#! /bin/bash
# simple session-selector
# launch it from ~/.xinitrc
# delete/add a section to remove/add a session
# --------------------------------------------
# set username
# ------------
HUMAN=`w -h | tail -n1 | awk '{print $1}'`
# configure dialog window
# -----------------------
ACTION=`zenity --width=325 --height=355 --list\
            --title "Select your Wm" --text "Welcome to Livarp_0.3.9 $HUMAN \n pick or edit a session -->>"\
            --column "sessions" --column "  what?"\
            "vtwm" "virtual tabbed window manager"\
            "wmfs" "window manager from scratch v2"\
            "dwm" "the dynamic window manager reloaded"\
            "echinus" "the easy tiling"\
            "awesome" "the powerfull tiling"\
            "evilwm" "they sold their soul to X"\
            "pekwm" "the only one"\
            "fluxbox" "the famous one"\
            "compiz" "standalone session (testing)"\
            "" ""\
            "edit" "configure startup scripts"\
            "" ""\
            "reboot" "restart your computer"\
            "halt" "shutdown your computer"`
# session launchers
# -----------------
if [ -n "${ACTION}" ]; then
    case $ACTION in
        vtwm)
            exec ck-launch-session $HOME/bin/start/vtwm_start.sh
            ;;
        dwm)
            exec ck-launch-session $HOME/bin/start/dwm_start.sh
            ;;
        echinus)
            exec ck-launch-session $HOME/bin/start/echinus_start.sh
            ;;
        evilwm)
            exec ck-launch-session $HOME/bin/start/evil_start.sh
            ;;
        wmfs)
            exec ck-launch-session $HOME/bin/start/wmfs_start.sh
            ;;
        awesome)
            exec ck-launch-session $HOME/bin/start/awesome_start.sh
            ;;
        pekwm)
            exec ck-launch-session $HOME/bin/start/pekwm_start.sh
            ;;
        fluxbox)
            exec ck-launch-session $HOME/bin/start/fluxbox_start.sh
            ;;
        compiz)
            exec ck-launch-session $HOME/bin/start/compiz_start.sh
            ;;
        edit)
            geany -s $HOME/bin/start/*_start.sh
            session_selector.sh
            ;;
        reboot)
            sudo shutdown -r now
            ;;
        halt)
            sudo shutdown -h now
            ;;
    esac
fi
