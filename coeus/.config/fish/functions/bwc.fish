function bwc
    bw get item (
        bw list items \
           | jq -r '.[] | [.name, .login.username // "", .id] | @tsv' \
           | column -t -s \t \
           | fzf --with-nth 1..-2 --preview-window down:2 \
              --preview 'bw get item (echo {} | awk \'{print $NF}\') | jq -r \'.login.uris | .[] | .uri // empty \'' \
           | awk '{print $NF}'
    ) | jq -r '.login.password' | xsel -i -b
end
