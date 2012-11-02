#!/bin/bash
exe=`dmenu_path | dmenu -b -fn "snap" -nb '#222222' -nf '#7D7D7D' -sb '#6DDD00' -sf '#222222' -p 'exec:'` && eval "exec $exe"
