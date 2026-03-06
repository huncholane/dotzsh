# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Created by newuser for 5.9
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Lazy-load conda — only initializes when you first call conda or activate
conda() {
  unfunction conda mamba activate 2>/dev/null
  eval "$("$HOME/miniconda3/bin/conda" shell.zsh hook)"
  conda "$@"
}
activate() {
  conda activate "$@"
}

# Lazy-load nvm
export NVM_DIR="$HOME/.nvm"
nvm() {
  unfunction nvm node npm npx 2>/dev/null
  source "$NVM_DIR/nvm.sh"
  nvm "$@"
}
node() {
  unfunction nvm node npm npx 2>/dev/null
  source "$NVM_DIR/nvm.sh"
  node "$@"
}
npm() {
  unfunction nvm node npm npx 2>/dev/null
  source "$NVM_DIR/nvm.sh"
  npm "$@"
}
npx() {
  unfunction nvm node npm npx 2>/dev/null
  source "$NVM_DIR/nvm.sh"
  npx "$@"
}

# Emacs keybindings
bindkey -e

# Autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
