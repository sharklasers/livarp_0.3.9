#!/bin/sh
# tabdock, a simple script for tablaunch
tablaunch \
    --ignoreXRM \
    --dock bottom -x 0 -y 0 -r \
    -fn "snap" -sfn "snap" \
    -bg "#000000" \
    -fg "#9E9E9E" -sfg "#D7D7D7" -pfg "#099F00" \
    -d 1 -t -e 1 --fit_text \
    --hidden 1 --bottom 1 --top 1 \
    --pulldown 5 --caption_y 10 \
    --no_label \
    -c ~/.tablaunchrc
