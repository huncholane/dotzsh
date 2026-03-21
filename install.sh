#!/bin/bash

BLA_clock=(🕛 🕐 🕑 🕒 🕓 🕔 🕕 🕖 🕗 🕘 🕙 🕚)

animate() {
    eval "$1" &>/tmp/last_output &
    local pid=$!
    local spin='-\|/'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        for frame in "${BLA_clock[@]}"; do
            printf "\r%s" "${frame}"
            sleep 0.2
        done
    done
    printf "\r"
    wait $pid
    return $?
}

# Colored echos
echop() {
    echo -e "\e[35m$1\e[0m"
}
echor() {
    echo -e "\e[31m$1\e[0m"
}
echog() {
    echo -e "\e[32m$1\e[0m"
}
echot() {
    echo -e "\e[36m$1\e[0m"
}
echob() {
    echo -e "\e[34$1\e[0m"
}

# Select sudo or not
[ "$(whoami)" == "root" ] && prefix="" || prefix="sudo"

login_sudo() {
    [ "$prefix" != "sudo" ] || sudo -v
}

echo "Ensuring base tools are installed."

# Install basic tools on debian
if [ -f /etc/debian_version ]; then
    # Set the installer prefix
    installer="$prefix apt-get"
    install_cmd="$installer install -y"

    # Update system
    echop "Detected Debian. Updating and upgrading now!"
    animate "$installer update -y && $installer upgrade -y"
    echog "✅ System up to date!"

    # Install build essential
    dpkg -s build-essential &>/dev/null ||
        { echo "Installing build-essential" && animate "$install_cmd build-essential" && printf "\e[1A\e[2K"; } ||
        { cat /tmp/last_output && echor "Failed to install build-essential" && exit 1; }
    echog "✅ build-essential installed"

# Install basic tools for arch
elif [ -f /etc/arch-release ]; then
    # Set pacman prefix
    installer="$prefix pacman"
    install_cmd="$installer -S --noconfirm"

    # Update system
    echob "Arch Detected. You are elite. Updating and upgrading now!"
    animate "$installer -Syu"
    echog "✅ System up to date!"

    # Install base-devel
    pacman -Q base-devel &>/dev/null ||
        { echo "Installing base-devel" && animate "$installer base-devel" && printf "\e[1A\e[2K"; } ||
        { cat /tmp/last_output && echor "Failed to install base-devel"; }
    echog "✅ base-devel installed"

    # Install paru
    command -v paru &>/dev/null ||
        { echo "Installing paru" && animate "git clone https://aur.archlinux.org/paru.git /tmp/paru &&
            cd /tmp/paru && makepkg -si" && printf "\e[1A\e[2K"; } ||
        { cat /tmp/last_output && echor "Failed to install paru"; }
    echog "✅ paru installed"
fi

# Install zsh
command -v zsh &>/dev/null ||
    { echo "Installing zsh" && animate "$install_cmd zsh" && printf "\e[1A\e[2K"; } ||
    { cat /tmp/last_output && echor "Failed to install zsh" && exit 1; }
echog "✅ zsh installed"

# Install curl (crazy but this happens sometimes)
command -v curl &>/dev/null ||
    { echo "Installing curl" && animate "$install_cmd curl" && printf "\e[1A\e[2K"; } ||
    { cat /tmp/last_output && echor "Failed to install curl"; }
echog "✅ curl installed"

# Install unzip
command -v unzip &>/dev/null ||
    { echo "Installing unzip" && animate "$install_cmd unzip" && printf "\e[1A\e[2K"; } ||
    { cat /tmp/last_output && echor "Failed to install unzip"; }
echog "✅ unzip installed"

# Install git
command -v git &>/dev/null ||
    { echo "Installing git" && animate "$install_cmd git" && printf "\e[1A\e[2K"; } ||
    { cat /tmp/last_output && echor "Failed to install git"; }
echog "✅ git installed"

# Install cargo
[ -f ~/.cargo/env ] ||
    { echo "Installing cargo" && animate "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" && printf "\e[1A\e[2K"; } ||
    { cat /tmp/last_output && echor "Failed to install cargo" && exit 1; }
echog "✅ cargo installed"
. ~/.cargo/env

# Install lsd with cargo
command -v lsd &>/dev/null ||
    { echo "Installing lsd" && animate "cargo install lsd" && printf "\e[1A\e[2K"; } ||
    { cat /tmp/last_output && echor "Failed to install lsd" && exit 1; }
echog "✅ lsd installed"

# Install golang
export PATH=$PATH:/usr/local/go/bin:/usr/local/go/bin
latest_go_version="$(curl -fsSL "https://go.dev/VERSION?m=text" | head -1)"
filename="$latest_go_version.$([[ "$(uname -m)" == "Linux" ]] && { printf "linux"; } || printf "darwin").$(uname -m).tar.gz"
[[ "$(go version 2>/dev/null | awk '{print $3}')" == "$latest_go_version" ]] ||
    { login_sudo && echo "Installing golang" && animate "curl -fsSL https://go.dev/dl/go1.26.1.linux-amd64.tar.gz | $prefix tar xvzf - -C /usr/local" && printf "\e[1A\e[2K"; } ||
    { cat /tmp/last_output && echor "Failed to install go" && exit 1; }
echog "✅ golang installed"

# Install lazygit with go
command -v lazygit &>/dev/null ||
    { echo "Installing lazygit" && animate "go install github.com/jesseduffield/lazygit@latest" && printf "\e[1A\e[2K"; } ||
    { cat /tmp/last_output && echor "Failed to install lazygit" && exit 1; }
echog "✅ lazygit installed"

# Install yazi
filename="yazi-$(uname -m)-$(
    { [[ "$(uname -s)" == "Linux" ]] && printf "unknown-linux-%s" "$(ldd --version 2>&1 | grep -qi musl && echo musl || echo gnu)"; } || printf "apple-darwin"
).zip"
[ -d /usr/local/yazi ] ||
    { login_sudo && echo "installing yazi" && animate "rm -rf /tmp/yazi* && $prefix rm -rf /usr/local/yazi &&
        curl -fsSL https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-x86_64-unknown-linux-gnu.zip -o /tmp/yazi.zip &&
        unzip /tmp/yazi.zip -d /tmp && $prefix mv /tmp/yazi-x86_64-unknown-linux-gnu/ /usr/local/yazi/ && $prefix mv /usr/local/yazi/ya* /usr/local/bin" &&
        printf "\e[1A\e[2K"; } ||
    { cat /tmp/last_output && echor "Failed to install yazi" && exit 1; }
echog "✅ yazi installed"

# Create backups
[ -d ~/.config ] || mkdir -p ~/.config
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak && echot "Backup ~/.zshrc -> ~/.zshrc.bak"
[ -f ~/.zshenv ] && mv ~/.zshenv ~/.zshenv.bak && echot "Backup ~/.zshenv -> ~/.zshenv.bak"
[ -d ~/.config/zsh ] && rm -rf ~/.config/zsh.bak

# Clone config repo
echo 'export ZDOTDIR=$HOME/.config/zsh' >~/.zshenv
{ echo "Cloning dotzsh" && animate "git clone https://github.com/huncholane/dotzsh ~/.config/zsh" && printf "\e[1A\e[2K"; } ||
    { cat /tmp/last_output && echor "Failed to clone dotzsh to ~/.config/zsh" && exit 1; }
export ZDOTDIR=$HOME/.config/zsh
echog "✅ dotzsh installed"

# Install antidote
[ -d ~/.config/zsh/.antidote ] ||
    { echo "Installing antidote" && animate "git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote" && printf "\e[1A\e[2K"; } ||
    { cat /tmp/last_output && echor "Failed to install antidote" && exit 1; }

echot -e "\nRun 'exec zsh' to see the magic"

# [ -f /etc/arch-release ] && pacman -Q base-devel &>/dev/null || sudo pacman -S base-devel || echo -e "\e[31mFailed to install base-devel" && exit 1
# [ -f /etc/debian_version ] && (apt update dpkg -s build-essential &>/dev/null || echo "missing build-essential")

# command -v zsh || sudo apt install zsh || sudo dnf install zsh || sudo pacman -S zsh
