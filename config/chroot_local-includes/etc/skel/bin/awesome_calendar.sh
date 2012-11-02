#!/bin/bash
#
# pop-up calendar for dzen
# (c) 2007, by Robert Maneaq
# mods 2012, by arpinux
 
TODAY=$(expr `date +'%d'` + 0)
MONTH=`date +'%m'`
YEAR=`date +'%Y'`
 
(echo '^fg(grey)'`date +'%A, %d %b'`; \
echo ' day:'`date +'%j'`' - week:'`date +'%U'`; \
echo; cal | sed -re "s/(^|[ ])($TODAY)($|[ ])/\1^fg(red)\2^fg()^bg()\3/"; \
[ $MONTH -eq 12 ] && YEAR=`expr $YEAR + 1`; cal `expr \( $MONTH + 1 \) % 12` $YEAR; \
sleep 60) | dzen2 -fn '-*-terminus-*-*-*-*-12-*-*-*-*-*-iso10646-*' -x 890 -y 20 -h 14 -w 125 -l 18 -e 'onstart=uncollapse;button1=exit;button3=exit'
