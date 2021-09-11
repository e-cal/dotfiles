# Defined interactively
function fastbook
cd ~/projects/fastai/fastbook
tmux new -d -s fastbook
tmux send -t fastbook "jupyter notebook" ENTER
tmux a -t fastbook
end
