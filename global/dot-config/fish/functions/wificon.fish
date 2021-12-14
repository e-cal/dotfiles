function wificon
    nmcli device wifi connect $argv[1] password $argv[2]
end
