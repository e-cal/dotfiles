function fixairpods
pacmd list-cards
echo pacmd set-card-profile \# a2dp_sink
end
