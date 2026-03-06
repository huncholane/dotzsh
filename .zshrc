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

# Plugin manager
# Usage:
#   plug <pkg> <source>            — eager load (source immediately)
#   plug <pkg> <source> cmd1 cmd2  — lazy load (stubs for listed commands)
# <source> can be a file path or a command string to eval.
# Auto-installs via pacman if the package is missing.
function plug() {
  local pkg=$1 src=$2
  shift 2
  pacman -Q "$pkg" &>/dev/null || sudo pacman -S --noconfirm "$pkg"
  if (( $# == 0 )); then
    if [[ -f "$src" ]]; then source "$src"; else eval "$src"; fi
  else
    local cmds="$*"
    for cmd in "$@"; do
      eval "function $cmd() {
        unfunction $cmds 2>/dev/null
        if [[ -f ${(qq)src} ]]; then source ${(qq)src}; else eval ${(qq)src}; fi
        $cmd \"\$@\"
      }"
    done
  fi
}

# Plugins — eager
plug zsh-autosuggestions /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Plugins — lazy
plug zoxide 'eval "$(zoxide init zsh)"' z zi

# Lazy-load conda
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
