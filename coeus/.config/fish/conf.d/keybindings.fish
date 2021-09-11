# Remove keybindings
bind -e -M insert \cd
bind -e -M insert \cl

# Normal (default) mode keybindings
bind \cr '/bin/clear; exec fish'
bind \t forward-word
bind \cd 'cds ~; redraw'
bind \cf 'vs'
bind \cl 'pwd; la; redraw'
bind \ck 'clear; echo; redraw'
bind \cs 'configstat; redraw'
bind \cv 'vclip'
bind \ch  backward-kill-word # ctrl+backspace
# bind -k f13 complete # alt+tab
bind \ct complete # alt+tab
bind \e\[3\;5~ backward-kill-line

# Insert mode keybindings
bind -M insert \t forward-word
bind -M insert \cr '/usr/bin/clear; exec fish'
bind -M insert \ch 'hist; redraw'
bind -M insert \cp 'htop; redraw'
bind -M insert \cd 'cds ~; redraw'
bind -M insert \ce 'vs'
bind -M insert \cl 'pwd; la; redraw'
bind -M insert \ck 'clear; echo; redraw'
bind -M insert \cs 'configstat; redraw'
bind -M insert \cv 'vclip'
# bind -M insert -k f13 complete # alt+tab

