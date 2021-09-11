#!/bin/bash

rofi_command="rofi -no-fixed-num-lines -theme $HOME/.config/rofi/powermenu.rasi"

# Options
shutdown="󰐥"
reboot="󰜉"
suspend="󰒲"
logout="󰿅"

# Variable passed to rofi
options="$shutdown\n$reboot\n$suspend\n$logout"

# Remapping movement
xmodmap -e "keycode 32 = Return"
xmodmap -e "keycode 44 = Down"
xmodmap -e "keycode 45 = Up"

chosen="$(echo -e "$options" | $rofi_command -dmenu)"

# Reset Remapping
xmodmap -e "keycode 32 = o"
xmodmap -e "keycode 44 = j"
xmodmap -e "keycode 45 = k"

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
