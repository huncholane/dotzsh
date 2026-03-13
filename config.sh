# History
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Set nvim as default editor
export EDITOR=nvim

# Aliases
alias l=lsd
alias v=nvim
alias nvm=fnm
alias ll='lsd -l'
alias pip='uv pip'

# History substring search
bindkey '^[[A' history-substring-search-up   # or '\eOA'
bindkey '^[[B' history-substring-search-down # or '\eOB'
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# Change tmux title
if command -v tmux &>/dev/null; then
  tmux set -g pane-border-format " #{pane_index} | #{pane_current_command} | $(whoami)@#[bold]$(hostname)#[nobold]:#{pane_current_path} "
fi

# Use powerlevel10k
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
