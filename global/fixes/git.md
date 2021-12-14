# Checkout Remote Branch
`git checkout --track origin/<branch>`

If `fatal: 'origin/<branch>' is not a commit and a branch '<branch>' cannot be created from it`
1. `git config -e --global`
2. Add:
```
[remote "origin"]
    fetch = +refs/heads/*:refs/remotes/origin/*
```
3. `git fetch --all`
