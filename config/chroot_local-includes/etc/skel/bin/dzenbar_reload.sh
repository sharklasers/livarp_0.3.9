#! /bin/bash
# dzenbar-reload script

killall dzen2 &
sleep 2
~/bin/dzenbar.sh
exit 0
