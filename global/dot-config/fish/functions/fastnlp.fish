# Defined interactively
function fastnlp
cd ~/projects/fastai/nlp
tmux new -d -s nlp
tmux send -t nlp "jupyter notebook" ENTER
tmux a -t nlp
end
