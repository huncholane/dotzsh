export SYMLINK_RUST_VERSION="0.0.1"

export SYMLINK_RUST_ENV="${SYMLINK_RUST_ENV:-debug}"          # debug/release: defaults to debug
export SYMLINK_DEBUGGING_MODE="${SYMLINK_DEBUGGING_MODE:-0}"  # 0 for off and 1 for on

# Make sure local bin is available
[ ! -d ~/.local/bin ] && mkdir -p ~/.local/bin
echo "$PATH" | grep -q "$HOME/.local/bin" || export PATH="$PATH:$HOME/.local/bin"

# Keep track of programs added through this plugin
SYMLINKED_PROGRAMS=()

# Create a symlink from debug/release to target. 
# Can switch from debug to release at any time with `export SYMLINK_RUST_ENV=debug/release`.
# Your next command will switch out the symlink.
function _symlink_rust_executables() {
  [[ "$SYMLINK_DEBUGGING_MODE" == "1" ]] && echo "searching target/$SYMLINK_RUST_ENV for executables"
  [[ -d target/$SYMLINK_RUST_ENV ]] && for exe in target/$SYMLINK_RUST_ENV/*; do
    [[ -f "$exe" && -x "$exe" ]] || continue
    local name="$(basename "$exe")"
    local src="$(realpath "$exe")"
    local dst="$HOME/.local/bin/$name"
    [[ -x "$exe" ]] && ln -sf "$src" "$dst"
    [[ "$SYMLINK_DEBUGGING_MODE" == "1" ]] && echo "linked $src to $dst"
    SYMLINKED_PROGRAMS+=("$dst")
  done
}

# Remove all the programs created
function _cleanup_symlink_rust_executables() {
  for program in "${SYMLINKED_PROGRAMS[@]}"; do
    rm -f "$program"
  done
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _symlink_rust_executables
add-zsh-hook zshexit _cleanup_symlink_rust_executables
