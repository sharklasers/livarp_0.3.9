#!/bin/bash
loc=`ls -A $HOME | dmenu -b -fn "snap" -nb '#222222' -nf '#7D7D7D' -sb '#7D7D7D' -sf '#222222' -p 'goto/open/edit: '` && eval "rox $loc"
