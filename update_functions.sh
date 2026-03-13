# Check for updates (reads from cache, no network)
_dotzsh_cache="${XDG_CACHE_HOME:-$HOME/.cache}/dotzsh"
if [[ -s "$_dotzsh_cache/system_updates" ]]; then
  printf "\e[33mSystem updates available. Run uds to update.\e[0m\n"
fi
if [[ -f "$_dotzsh_cache/dotzsh_update" ]]; then
  printf "\e[34mdotzsh update available. Run udz to apply.\e[0m\n"
fi
unset _dotzsh_cache

# Update system
uds() {
  if command -v paru &>/dev/null; then
    paru -Syu
  elif command -v pacman &>/dev/null; then
    sudo pacman -Syu
  elif command -v apt &>/dev/null; then
    sudo apt update && sudo apt upgrade
  elif command -v dnf &>/dev/null; then
    sudo dnf upgrade
  fi
  rm -f "${XDG_CACHE_HOME:-$HOME/.cache}/dotzsh/system_updates"
}

# Update dotzsh
udz() {
  printf "\e[34mUpdating dotzsh\e[0m\n"
  (cd "$ZDOTDIR" && git pull --rebase)
  rm -f "${XDG_CACHE_HOME:-$HOME/.cache}/dotzsh/dotzsh_update"
}
