function bwu
  set -xU BW_SESSION (bw unlock --raw $argv[1])
  bw sync
end
