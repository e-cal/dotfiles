# def _fixap():
#    pacmd list-cards
#    print("pacmd set-card-profile # a2dp_sink")
#
# aliases['fixap'] = _fixap
# del _fixap

def _sshpi():
    ip = ${dig "ecal.dev" | tail -7 | head -1 | awk '{print $5}'}
    ssh f"pi@{ip}"
aliases['sshpi'] = _sshpi
print("hi")
