function cdsearch
    if count $argv > /dev/null
        set searchFrom $argv
    else
        set searchFrom "."
    end
    cd (find $searchFrom -type d | fzf)
end
