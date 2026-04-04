[ -f "$ZDOTDIR/before_plugins.sh" ] && source "$ZDOTDIR/before_plugins.sh"

# Load custom plugins
for plugin in ~/.config/zsh/custom-plugins/*.zsh; do
  source "$plugin"
done

# Set up antidote
source "$ZDOTDIR/.antidote/antidote.zsh"
antidote load ${ZDOTDIR:-$HOME}/zsh_plugins.txt

# Setup completions
fpath=("${ZDOTDIR}/.zfunc" $fpath)
autoload -Uz compinit && compinit

# Update checks and functions
source "$ZDOTDIR/update_functions.sh"

# Add secret environment variables
[ -f "$ZDOTDIR/secrets.sh" ] && source "$ZDOTDIR/secrets.sh"

# Post compinit setups. Good for overriding plugins.
[ -f "$ZDOTDIR/after_plugins.sh" ] && source "$ZDOTDIR"/after_plugins.sh
