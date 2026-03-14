# Set up antidote
source "$ZDOTDIR/.antidote/antidote.zsh"
antidote load ${ZDOTDIR:-$HOME}/zsh_plugins.txt

# Setup completions
fpath=("${ZDOTDIR}/.zfunc" $fpath)
source "$ZDOTDIR/precomp.sh"
autoload -Uz compinit && compinit

# Update checks and functions
source "$ZDOTDIR/update_functions.sh"

# Post compinit setups. Good for overriding plugins.
touch "$ZDOTDIR/env.sh" && source "$ZDOTDIR"/env.sh
source "$ZDOTDIR"/config.sh
