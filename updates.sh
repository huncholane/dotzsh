#!/usr/bin/bash

ue() {
  printf "\e[33mWARNING: System is outdated\e[0m\n"
}

if command -v paru &>/dev/null; then
  paru -Qu &>/dev/null && ue
elif command -v apt; then
  apt list --upgradeable &>/dev/null && ue
elif command -v dnf; then
  dnf check-update &>/dev/null && ue
fi

(
  cd "$ZDOTDIR" && git fetch origin && if [ "$(git rev-parse HEAD)" != "$(git rev-parse '@{u}')" ]; then
    printf "\e[34mdotzsh update available. Run udz to apply.\e[0m\n"
  fi
)

# Update dotzsh
udz() {
  printf "\e[34mUpdating dotzsh\e[0m\n"
  (
    cd "$ZDOTDIR" && git pull --rebase
  )
}
