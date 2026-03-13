zfunc_dir="$ZDOTDIR/.zfunc"
if [ ! -d "$zfunc_dir" ]; then mkdir -p "$zfunc_dir"; fi

add_completions() {
  local file="$zfunc_dir/$1"
  if [ ! -f "$file" ]; then
    $2 >"$zfunc_dir"
  fi
}

add_completions _fnm 'fnm completions --shell zsh'
add_completions _rustup 'rustup completions zsh'

# Custom PATH additions
export PATH="$PATH:$HOME/.local/bin"

# Setup fnm
eval "$(fnm env --shell zsh)"

. "$HOME/.cargo/env"
