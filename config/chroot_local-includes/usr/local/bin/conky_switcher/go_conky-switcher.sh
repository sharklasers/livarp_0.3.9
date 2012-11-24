#!/bin/bash
cd "$( cd "$(dirname "$0")"; pwd )"
./glade2script.py -g ./conky-switcher.glade -d -t \
"@@treeconky@@CHECK%%Lancer|CHECK%%Autostart|Conky%%50"
exit
