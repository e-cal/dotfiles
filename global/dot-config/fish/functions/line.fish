function line
		yes "$argv" | head -n (tput cols) | tr '\n' ',' | sed 's/,//g' | lolcat -F 0.03 -s 24
end
