#! /bin/bash
RC="$HOME/.conky/.conkyrc_dzen"
FG="#7D7D7D"
BG="#222222"
ALIGN="right"
WIDTH="500"
HEIGHT="12"
FONT="-*-terminus-medium-*-*-*-12-*-*-*-*-*-*-*"
XPOS="0"
YPOS="0"
LIN="8" #number of lines in conky_dzen output

conky -d -c $RC | dzen2 -e 'button1=togglecollapse;button2=exec:$HOME/bin/dzenbar_reload.sh;button3=exec:geany $HOME/.conky/.conkyrc_dzen $HOME/bin/dzenbar.sh' -fg $FG -bg $BG -ta $ALIGN -h $HEIGHT -x $XPOS -y $YPOS -fn $FONT -l $LIN -u &
exit 0
