zfunc_dir="$ZDOTDIR/.zfunc"
if [ ! -d "$zfunc_dir" ]; then mkdir -p "$zfunc_dir" &>/dev/null; fi

add_completions() {
  local file="$zfunc_dir/$1"
  if [ ! -f "$file" ]; then
    eval "$2" >"$file"
  fi
}

# Update PATH
export PATH="$PATH:$HOME/.local/bin:$HOME/go/bin:$HOME/.avm/bin:/usr/local/go/bin"
export PATH="$PATH:$HOME/.local/share/solana/install/active_release/bin"
export PATH="$HOME/.local/share/fnm:$PATH"

# Add environments
[ -f ~/.fzf.zsh ] && . ~/.fzf.zsh
[ -f ~/.cargo/env ] && . "$HOME/.cargo/env"
[ -f ~/.venv/bin/activate ] && . ~/.venv/bin/activate

# Create completions now that path is updated
add_completions _fnm 'fnm completions --shell zsh'
add_completions _rustup 'rustup completions zsh'
add_completions _uv 'uv generate-shell-completion zsh'
