# Defined via `source`
function monitors-home --wraps='xrandr --output DP-0 --primary --mode 2560x1440 --output DP-2 --mode 1920x1080 --rotate right --left-of DP-0 --output HDMI-0 --mode 1920x1080 --left-of DP-2' --description 'alias monitors-home xrandr --output DP-0 --primary --mode 2560x1440 --output DP-2 --mode 1920x1080 --rotate right --left-of DP-0 --output HDMI-0 --mode 1920x1080 --left-of DP-2'
  xrandr --output DP-0 --primary --mode 2560x1440 --output DP-2 --mode 1920x1080 --rotate right --left-of DP-0 --output HDMI-0 --mode 1920x1080 --left-of DP-2 $argv; 
end
