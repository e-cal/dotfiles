function search
    if count $argv > /dev/null
        sudo find $argv 2>/dev/null | fzf
    else
        searchsys
    end
end
