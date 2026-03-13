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

# Custom PATH additions
export PATH="$PATH:$HOME/.local/bin"

. "$HOME/.cargo/env"

# Setup fnm
export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env --shell zsh)"
