# Set up antidote
source /usr/share/zsh-antidote/antidote.zsh
antidote load ${ZDOTDIR:-$HOME}/zsh_plugins.txt

# Setup completions
fpath=("${ZDOTDIR}/.zfunc" $fpath)
source "$ZDOTDIR/precomp.sh"
autoload -Uz compinit && compinit

# Post compinit setups. Good for overriding plugins.
source "$ZDOTDIR"/env.sh
source "$ZDOTDIR"/config.sh
