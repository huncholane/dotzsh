# Install fnm
if [ ! -d "$FNM_PATH" ]; then
  curl -fsSL https://fnm.vercel.app/install | bash
fi

# Install cargo
if [ ! -d "$HOME/.cargo" ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
if [ ! -f /usr/bin/lsd ]; then
  cargo install lsd
fi
if [ -f /etc/arch-release ]; then
  # Install paru
  if ! command -v paru &>/dev/null; then
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru && makepkg -si
    rm -rf /tmp/paru
  fi
fi
