#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar
sleep 3

# launch polybar
polybar laptop -c $HOME/.config/polybar/config.ini &
