#!/bin/bash

rofi_command="rofi -no-fixed-num-lines -theme $HOME/.config/rofi/powermenu.rasi"

if [[ `hostname` = "coeus" ]]; then
    rofi_command+=" -m 2"
fi

# Options
shutdown="󰐥"
reboot="󰜉"
suspend="󰒲"
logout="󰿅"

# Variable passed to rofi
options="$shutdown\n$reboot\n$suspend\n$logout"

chosen="$(echo -e "$options" | $rofi_command -dmenu)"

case $chosen in
    $shutdown)
	    sudo poweroff
        ;;
    $reboot)
	    sudo reboot
        ;;
    $suspend)
	    #betterlockscreen -l &
	    sleep 0.5
        systemctl suspend
        ;;
    $logout)
        session=`loginctl session-status | head -n 1 | awk '{print $1}'`
        loginctl terminate-session $session
        ;;
esac
