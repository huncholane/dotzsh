#!/bin/bash

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
    echo -e "\e[34m$1\e[0m"
}
echoy() {
    echo -e "\e[33m$1\e[0m"
}

# Clock animation
BLA_clock=(🕛 🕐 🕑 🕒 🕓 🕔 🕕 🕖 🕗 🕘 🕙 🕚)

# Use $prefix for commands that might need sudo
prefix="$([[ $(whoami) == "root" ]] && echo "" || echo "sudo")"
LAST_OUTPUT=$(mktemp)
[ -d "$HOME" ] || { echor "$HOME is not a directory. You are cancelled." && exit 1; }
export PATH="$PATH:/usr/local/go/bin:/usr/local/go/bin:$HOME/go/bin:$HOME/.local/bin"

# Ensure sudo and run command in background with animation, returns 1 if there was an issue
# $1: command used to check if the 2nd command should be ran ("" is always true)
# $2: command to run in the background
# $3: text to append to animation
# $4: success message
# $5: failure message (after LAST_OUTPUT)
# $6: Ignore output if set
animate() {
    # Return when check is success
    [[ -n "$1" ]] && eval "$1" && echob "ℹ️ No action required. $4" && return 0

    # Ensure sudo
    [[ "$(whoami)" == "root" ]] || sudo -v || exit 1

    # Run with output to tmp
    eval "$2" &>"$LAST_OUTPUT" &

    # Wait and animate the command
    local pid=$!
    while kill -0 $pid 2>/dev/null; do
        for frame in "${BLA_clock[@]}"; do
            printf "\r%s %s  " "${frame}" "$3"
            sleep 0.2
        done
    done

    # Clear and output error if needed
    printf "\033[2K\r"
    { { wait $pid || [[ -n "$6" ]]; } && echog "✅ $4"; } || { cat "$LAST_OUTPUT" && echor "\n🔴 $5" && return 1; }
}

echo "Ensuring base tools are installed."

# Install basic tools on debian
if [ -f /etc/debian_version ]; then
    # Set the installer prefix
    installer="$prefix apt-get -y"
    install_cmd="$installer install"

    # Update system
    echop "Detected Debian. Updating and upgrading now!"
    animate "" \
        "$installer update && $installer upgrade" \
        "Updating system" \
        "System up to date!" \
        "Failed to update system" || exit 1

    # Install build essential
    animate "dpkg -s build-essential &>/dev/null" \
        "$install_cmd build-essential" \
        "Installing build-essential" \
        "build-essential installed" \
        "Failed to install build-essential" || exit 1

# Install basic tools for arch
elif [ -f /etc/arch-release ]; then
    # Set pacman prefix
    installer="$prefix pacman --noconfirm"
    install_cmd="$installer -S"

    # Update system
    echot "Arch Detected. You are elite. Updating and upgrading now!"
    animate "" \
        "$installer -Syu" \
        "Updating system" \
        "System up to date!" \
        "Failed to update system" || exit 1

    # Install base-devel
    animate "pacman -Q base-devel &>/dev/null" \
        "$install_cmd base-devel" \
        "Installing base-devel" \
        "base-devel installed" \
        "Failed to install base-devel" || exit 1

    # Install git
    animate "command -v git &>/dev/null" \
        "$install_cmd git" \
        "Installing git" \
        "git installed" \
        "Failed to install git" || exit 1

    # Install cargo before paru
    animate "[ -f ~/.cargo/env ]" \
        "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" \
        "Installing cargo" \
        "cargo installed" \
        "Failed to install cargo" || exit 1

    # Install paru
    paru_dir="$(mktemp -d)"
    # command -v paru &>/dev/null ||
    #     { rm -rf $HOME/paru && git clone https://aur.archlinux.org/paru.git $paru_dir && cd $paru_dir && makepkg -si; } || 
    #     { exit 1; }
    animate "command -v paru &>/dev/null" \
        "rm -rf $HOME/paru && git clone https://aur.archlinux.org/paru.git $paru_dir && cd $paru_dir && makepkg -si --noconfirm" \
        "Installing paru" \
        "paru installed" \
        "Failed to install paru" || exit 1
fi

# Install zsh
animate "command -v zsh &>/dev/null" \
    "$install_cmd zsh" \
    "Installing zsh" \
    "zsh installed" \
    "Failed to install zsh" || exit 1

# Install curl (crazy but this happens sometimes)
animate "command -v curl &>/dev/null" \
    "$install_cmd curl" \
    "Installing curl" \
    "curl installed" \
    "Failed to install curl" || exit 1

# Install unzip
animate "command -v unzip &>/dev/null" \
    "$install_cmd unzip" \
    "Installing unzip" \
    "unzip installed" \
    "Failed to install unzip" || exit 1

# Install git
animate "command -v git &>/dev/null" \
    "$install_cmd git" \
    "Installing git" \
    "git installed" \
    "Failed to install git" || exit 1

# Install cargo
animate "[ -f ~/.cargo/env ]" \
    "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" \
    "Installing cargo" \
    "cargo installed" \
    "Failed to install cargo" || exit 1
. ~/.cargo/env

# Install lsd with cargo
animate "command -v lsd &>/dev/null" \
    "cargo install lsd" \
    "Installing lsd" \
    "lsd installed" \
    "Failed to install cargo" || exit 1

# Install golang
latest_go_version="$(curl -fsSL "https://go.dev/VERSION?m=text" | head -1)"
filename="$latest_go_version.$([[ "$(uname -m)" == "Linux" ]] && { printf "linux"; } || printf "darwin").$(uname -m).tar.gz"
animate "[[ \"$(go version 2>/dev/null | awk '{print $3}')\" == \"$latest_go_version\" ]]" \
    "curl -fsSL https://go.dev/dl/go1.26.1.linux-amd64.tar.gz | $prefix tar xvzf - -C /usr/local" \
    "Installing go" \
    "go installed" \
    "Failed to install go" || exit 1

# Install fzf (written in go)
animate "command -v fzf &>/dev/null" \
    "git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install" \
    "Installing fzf" \
    "fzf installed" \
    "Failed to install fzf"

# Install lazygit with go
animate "command -v lazygit &>/dev/null" \
    "go install github.com/jesseduffield/lazygit@latest" \
    "Installing lazygit" \
    "lazygit installed" \
    "Failed to install lazygit" || exit 1

# Install yazi
filename="yazi-$(uname -m)-$(
    { [[ "$(uname -s)" == "Linux" ]] && printf "unknown-linux-%s" "$(ldd --version 2>&1 | grep -qi musl && echo musl || echo gnu)"; } || printf "apple-darwin"
).zip"
animate "[ -d /usr/local/yazi ]" \
    "rm -rf /tmp/yazi* && $prefix rm -rf /usr/local/yazi &&
        curl -fsSL https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-x86_64-unknown-linux-gnu.zip -o /tmp/yazi.zip &&
        unzip /tmp/yazi.zip -d /tmp && $prefix mv /tmp/yazi-x86_64-unknown-linux-gnu/ /usr/local/yazi/ && $prefix mv /usr/local/yazi/ya* /usr/local/bin" \
    "Installing yazi" \
    "yazi installed" \
    "Failed to install yazi" || exit 1

# Install fnm
animate "[ -d ~/.local/share/fnm ]" \
    "curl -fsSL https://fnm.vercel.app/install | bash" \
    "Installing fnm" \
    "fnm installed" \
    "Failed to install fnm" \
    "ignore fail"

# Install uv
animate "[ -f ~/.local/bin/uv ]" \
    "curl -LsSf https://astral.sh/uv/install.sh | sh" \
    "Installing uv" \
    "uv installed" \
    "Failed to install uv" || exit 1
[ -f ~/.venv/bin/activate ] || (cd ~ && uv venv &>/dev/null)

# Install zoxide
animate "[ -f ~/.local/bin/zoxide ]" \
    "curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh" \
    "Installing zoxide" \
    "zoxide installed" \
    "Failed to install zoxide"

# Create backups
[ -d ~/.config ] || mkdir -p ~/.config
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak && echot "Backup ~/.zshrc -> ~/.zshrc.bak"
[ -f ~/.zshenv ] && mv ~/.zshenv ~/.zshenv.bak && echot "Backup ~/.zshenv -> ~/.zshenv.bak"
[ -d ~/.config/zsh ] && rm -rf ~/.config/zsh.bak && mv ~/.config/zsh ~/.config/zsh.bak

# Clone config repo
echo 'export ZDOTDIR=$HOME/.config/zsh' >~/.zshenv
export ZDOTDIR=$HOME/.config/zsh
animate "" \
    "git clone https://github.com/huncholane/dotzsh ~/.config/zsh" \
    "Cloning dotzsh" \
    "dotzsh cloned. Just a few more things." \
    "Failed to clone dotzsh" || exit 1

# Install antidote
animate "[ -d ~/.config/zsh/.antidote ]" \
    "git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote" \
    "Installing antidote" \
    "antidote installed" \
    "Failed to install antidote" || exit 1

echot "\nRun 'exec zsh' to see the magic"
