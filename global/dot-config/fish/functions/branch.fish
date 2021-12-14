function branch
    git checkout -b $argv
    git push -u origin $argv
end
