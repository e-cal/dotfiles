# Dependencies
## Required
neovim
nvidia
git
yay (git)
go
xorg
xorg-init
xmonad
xmonad-contrib
xmonad-log (aur)
haskell-dbus
alacritty
nitrogen
picom-jonaburg-git (aur)
dmenu
rofi
fish

## Secondary
lolcat
exa
fzf
chromium
bitwarden-cli (aur)
jq
xsel
nodejs
npm
python
python-pip
python-pipenv
neovim (pip)
jedi (pip)
polybar (aur)
bat
starship (starship.rs)
nemo
zip
unzip
alsa-utils
pulseaudio
pulseaudio-alsa
pavucontrol
dunst
ddcutil
flameshot
dropbox (aur)
spotify (aur)
playerctl
mailspring (aur)
gnome-keyring
wmctrl
xdotool
eog
postgresql

# H4CK (move to /opt)
gnu-netcat
nmap
gobuster (go get github.com/OJ/gobuster)
enum4linux-ng (git@github.com:cddmp/enum4linux-ng.git)
exploitdb (git@github.com:offensive-security/exploitdb.git)
hydra
linpeas (wget github)
john
exiftool (git@github.com:exiftool/exiftool.git)
nikto (https://github.com/sullo/nikto)
sqlmap (https://github.com/sqlmapproject/sqlmap.git)
smbmap (git@github.com:ShawnDEvans/smbmap.git)
pwncat (git@github.com:calebstewart/pwncat.git)
impacket (git@github.com:SecureAuthCorp/impacket.git)
metasploit
wireshark-cli (or wireshark-qt)
wfuzz (pip)



# Set up multiple monitors
https://wiki.archlinux.org/index.php/Multihead#Example:_dualhead_configuration_using_relative_coordinates
`xrandr --output DP-2 --auto --output DP-5 --auto --left-of DP-2`

# Disable mouse acceleration
https://wiki.archlinux.org/index.php/Mouse_acceleration#Disabling_mouse_acceleration

# Set Cursor for Non-GTK
/usr/share/icons/default/index.theme

# Polybar cursor
`sudo cp -r .local/share/icons/Sweet-cursors/ /usr/share/icons`

# Fix audio
https://unix.stackexchange.com/questions/473694/pulseaudio-not-recognizing-intel-hda-after-upgrading-to-debian-testing-buster

# Remove ~/.xmonad

`rm -rf $HOME/.xmonad && mkdir $HOME/.local/share/xmonad`

# Disable sleep on idle
Add: `xset s off -dpms` to `.xinitrc`
