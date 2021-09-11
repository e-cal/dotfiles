function sshpi
    set ip (dig ecal.dev | tail -7 | head -1 | awk '{print $5}')
    ssh pi@$ip
end
