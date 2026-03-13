#!/bin/bash

STORAGE="${XDG_DATA_HOME:-$HOME/.local/share}/dotzsh"
mkdir -p "$STORAGE"

# Select installer
if command -v pacman &>/dev/null; then
  INSTALL='sudo pacman -S --noconfirm'
elif command -v apt &>/dev/null; then
  INSTALL='sudo apt install -y'
elif command -v dnf &>/dev/null; then
  INSTALL='sudo dnf install -y'
elif command -v brew &>/dev/null; then
  INSTALL='brew install'
fi
echo "Using $INSTALL for installations"

# Pass in command to invoke and installation name
install() {
  if ! command -v "$1" &>/dev/null; then $INSTALL $2; fi
}

# Pass in command to invoke and installation command
custominstall() {
  if ! command -v "$1" &>/dev/null; then eval "$2"; fi
}

# Install useful tools
install curl curl
install git git
install nvim neovim
install tmux tmux
install hostname inetutils
install crontab cronie
if command -v systemctl &>/dev/null; then
  sudo systemctl enable --now cronie
fi
if command -v pacman &>/dev/null; then
  install docker docker
else
  custominstall docker 'curl -fsSL https://get.docker.com | sh'
fi
custominstall fnm 'curl -fsSL https://fnm.vercel.app/install | bash'
custominstall cargo "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh" && . "$HOME/.cargo/env"
custominstall lsd 'cargo install lsd'

# Initialize git setup
if [[ -z $(git config --global user.name) ]]; then
  read -rp "Git username: " username < /dev/tty
  git config --global user.name "$username"
fi
if [[ -z $(git config --global user.email) ]]; then
  read -rp "Git email: " email < /dev/tty
  git config --global user.email "$email"
fi

# Install dotzsh
read -rp "Are you sure you want to replace your current config? (y/n): " yn < /dev/tty
if [[ "$yn" == "y" ]]; then
  oldenv="$(cat "$HOME/.zshenv" 2>/dev/null)"
  echo 'export ZDOTDIR=$HOME/.config/zsh' >"$HOME/.zshenv"
  if cp -r "$HOME/.config/zsh" "$STORAGE/backup" &>/dev/null; then
    echo "Stored $HOME/.config/zsh into $STORAGE/backup"
  fi
  rm -rf "$HOME/.config/zsh" &>/dev/null
  if ! git clone https://github.com/huncholane/dotzsh "$HOME/.config/zsh" 2>/dev/null; then
    echo "Clone failed"
    if cp -r "$STORAGE/backup" "$HOME/.config/zsh" &>/dev/null; then
      echo "Reverted $HOME/.config/zsh to original"
    fi
  else
    echo "$oldenv" >"$HOME/.config/zsh/env.sh"
    git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
  fi
fi

# Register update check cron job (every 6 hours)
CRON_CMD="0 */6 * * * $HOME/.config/zsh/updates.sh # dotzsh-update-check"
if ! crontab -l 2>/dev/null | grep -q "dotzsh/monitor_updates.sh"; then
  (crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
  echo "Registered update check cron job"
fi

# Arch specific installations
if [ -f /etc/arch-release ]; then
  echo "Arch detected"
  # Install paru
  if ! command -v paru &>/dev/null; then
    echo "Installing paru"
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    (cd /tmp/paru && makepkg -si)
    rm -rf /tmp/paru
  fi
fi
