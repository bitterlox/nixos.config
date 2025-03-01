# primagen's tmux sessionizer
# from https://youtu.be/0eHZRPzbiJ0 minute 8:30

if [[ $# -eq 1 ]]; then
  selected=$1
else
  if [[ -z $CODE_PATHS ]]; then
    echo "no code paths set"
    exit 1
  else
    IFS=':' read -ra CODEPATHS <<<"$CODE_PATHS"
  fi
  selected=$(find "${CODEPATHS[@]}" -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -s "$selected_name" -c "$selected"
  exit 0
fi

if ! tmux has-session -t="$selected" name 2>/dev/null; then
  tmux new-session -ds "$selected_name" -c "$selected"
fi

if [[ -z $TMUX ]]; then
  tmux attach-session -t "$selected_name"
else
  tmux switch-client -t "$selected_name"
fi
