# Update PATH
export PATH="$PATH:$HOME/.local/bin:$HOME/go/bin:$HOME/.avm/bin:/usr/local/go/bin"
export PATH="$PATH:$HOME/.local/share/solana/install/active_release/bin"
export PATH="$HOME/.local/share/fnm:$PATH"
export PATH="$PATH:/usr/local/flutter/bin"

# Set up a cached file as a subprocess with all the home rust debug paths in it
(
  mkdir -p ~/.cache
  fd -I -c never -E 'doc' -E 'package' --full-path 'target/debug$' ~ | tr '\n' ':' >~/.cache/RUST_DEBUG_PATHS
)
[ -f ~/.cache/RUST_DEBUG_PATHS ] && RUST_DEBUG_PATHS="$(cat ~/.cache/RUST_DEBUG_PATHS)" && export PATH="$PATH:$RUST_DEBUG_PATHS"

# Add environments
[ -f ~/.fzf.zsh ] && . ~/.fzf.zsh
[ -f ~/.cargo/env ] && . "$HOME/.cargo/env"
[ -f ~/.venv/bin/activate ] && . ~/.venv/bin/activate
eval "$(fnm env)"

# Create completions into ~/.config/.zfuncs directory
zfunc_dir="$ZDOTDIR/.zfunc"
if [ ! -d "$zfunc_dir" ]; then mkdir -p "$zfunc_dir" &>/dev/null; fi
add_completions() {
  local file="$zfunc_dir/$1"
  if [ ! -f "$file" ]; then
    eval "$2" >"$file"
  fi
}
add_completions _fnm 'fnm completions --shell zsh'
add_completions _rustup 'rustup completions zsh'
add_completions _uv 'uv generate-shell-completion zsh'
