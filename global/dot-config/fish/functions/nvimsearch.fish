function nvimsearch
    if count $argv > /dev/null
        set searchFrom $argv
    else
        set searchFrom "."
    end
    nvim (find $searchFrom -type f | fzf --preview 'bat --theme=gruvbox-dark --color=always {}')
end
