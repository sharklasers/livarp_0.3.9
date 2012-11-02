#! /bin/bash
# livarp_0.3.9 echinus keybinds & shortcuts
###########################################

## text colors ---------------------------------------------------------
red='\e[0;31m'
blue='\e[0;34m'
cyan='\e[0;36m'
green='\e[0;32m'
yellow='\e[0;33m'
## No Color
NC='\e[0m'
## background colors ---------------------------------------------------
RED='\e[41m'
BLUE='\e[44m'
CYAN='\e[46m'
GREEN='\e[42m'
YELLOW='\e[43m'
## output --------------------------------------------------------------
echo ""
echo -e "     ${green}livarp 0.3.9 echinus keybinds & shortcuts$NC"
echo ""
echo -e " ${RED} reload echinus  $NC Ctrl + Alt + r"
echo -e " ${RED} quit echinus    $NC Ctrl + Alt + Backspace"
echo -e " ${RED} quit livarp     $NC Ctrl + Shift + Alt + q"
echo -e " ${RED} quit client     $NC Super + q"
echo ""
echo -e " ${BLUE} start dmenu        $NC Alt + d"
echo -e " ${GREEN} open a terminal    $NC Super + Return"
echo -e " ${GREEN} open rox-filer     $NC Alt + Shift + r"
echo -e " ${GREEN} open ranger        $NC Alt + r"
echo -e " ${GREEN} open luakit        $NC Alt + w"
echo -e " ${GREEN} open firefox       $NC Alt + Shift + w"
echo -e " ${GREEN} open vim editor    $NC Alt + e"
echo -e " ${GREEN} open geany         $NC Alt + Shift + e"
echo -e " ${GREEN} open weechat       $NC Alt + x"
echo -e " ${GREEN} open music player  $NC Alt + z"
echo -e " ${GREEN} volume contol      $NC Alt + v"
echo ""
echo -e " ${BLUE} tiled layout        $NC Alt + t"
echo -e " ${BLUE} bottomstack layout  $NC Alt + s"
echo -e " ${BLUE} maximize layout     $NC Alt + m"
echo -e " ${BLUE} ifloating layout    $NC Alt + i"
echo -e " ${BLUE} floating layout     $NC Alt + f"
echo -e " ${BLUE} toggle free client  $NC Alt + space"
echo ""
echo -e " ${CYAN} prev/next client     $NC Alt + k/j"
echo -e " ${CYAN} prev/next tag        $NC Ctrl + Left/Right"
echo -e " ${CYAN} prev/next screen     $NC Alt + Up"
echo ""
echo -e " ${CYAN} sendto 'n' tag              $NC Alt + Shift + [F1..Fn]"
echo -e " ${CYAN} goto 'n' tag                $NC Alt + [F1..Fn]"
echo ""
echo ""
echo -e " ${green} full manual available with [man echinus]"
echo -en " ${green} hit Enter to quit..."
read anykey
exit 0
