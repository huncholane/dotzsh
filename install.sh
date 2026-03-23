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

# Use $prefix for commands that might need sudo
prefix="$([[ $(whoami) == "root" ]] && echo "" || echo "sudo")"
LAST_OUTPUT=$(mktemp)
[ -d "$HOME" ] || { echor "$HOME is not a directory. You are cancelled." && exit 1; }
export PATH="$PATH:/usr/local/go/bin:/usr/local/go/bin:$HOME/go/bin:$HOME/.local/bin"

# Install basic tools on debian
if [ -f /etc/debian_version ]; then
    # Set the installer prefix
    installer="$prefix apt-get -y"
    install_cmd="$installer install"

    # Update system
    echop "Detected Debian. Updating and upgrading now!"
    { tput smcup && echot "ℹ️ Updating system" &&
        eval "$installer update && $installer upgrade" &&
        tput rmcup && echog "✅ System up to date"; } ||
        { echor "🔴 Failed to update system" && exit 1; }

    # Install build essential
    dpkg -s build-essential &>/dev/null && echot "☑️ build-essential already installed" ||
        { tput smcup && echot "ℹ️ Installing build-essential" &&
            eval "$install_cmd build-essential" &&
            tput rmcup && echog "✅ build-essential installed"; } ||
        { echor "🔴 Failed to install build-essential" && exit 1; }

# Install basic tools for arch
elif [ -f /etc/arch-release ]; then
    # Set pacman prefix
    installer="$prefix pacman --noconfirm"
    install_cmd="$installer -S"

    # Update system
    { tput smcup &&
        eval "$installer -Syu" &&
        tput rmcup && echog "✅ System up to date"; } ||
        { echor "Failed to update" && exit 1; }

    # Install base-devel
    pacman -Q base-devel &>/dev/null && echob "☑️ base-devel already installed" ||
        { tput smcup &&
            eval "$install_cmd base-devel" && echot "ℹ️ Installing base-devel" &&
            tput rmcup && echog "✅ base-devel installed"; } ||
        { echor "🔴 Failed to install base-devel" && exit 1; }

    # Install git
    command -v git &>/dev/null && echob "☑️ git already installed" ||
        {
            tput smcup && echot "ℹ️ Installing git" &&
                eval "$install_cmd git" &&
                tput rmcup && echog "✅ git installed"
        } ||
        { echor "🔴 Failed to install git" && exit 1; }

    # Install cargo before paru
    [ -f ~/.cargo/env ] && echob "☑️ cargo already installed" ||
        { tput smcup && echot "ℹ️ Installing cargo" &&
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y &&
            tput rmcup && echog "✅ cargo installed"; } ||
        { echor "🔴 Failed to install cargo" && exit 1; }
    . ~/.cargo/env # Source cargo

    # Install paru
    paru_dir="$(mktemp -d)"
    command -v paru &>/dev/null && echob "☑️ paru already installed" ||
        { tput smcup && echot "ℹ️ Installing paru" &&
            rm -rf $HOME/paru && git clone https://aur.archlinux.org/paru.git $paru_dir && cd $paru_dir && makepkg -si --noconfirm &&
            tput rmcup && echog "✅ paru installed"; } ||
        { tput rmcup && echor "🔴 Failed to install paru"; }
fi

# Install zsh
command -v zsh &>/dev/null && echob "☑️ zsh already installed" ||
    { tput smcup && echot "ℹ️ Installing zsh" &&
        eval "$install_cmd zsh" &&
        tput rmcup && echog "✅ zsh installed"; } ||
    { echor "🔴 Failed to install zsh" && exit 1; }
chsh -s /usr/bin/zsh &>/dev/null && echot "ℹ️ Set default shell to zsh"

# Install curl (crazy but this happens sometimes)
command -v curl &>/dev/null && echob "☑️ curl already installed" ||
    { tput smcup && echot "ℹ️ Installing curl" &&
        eval "$install_cmd curl" &&
        tput rmcup && echog "✅ curl installed"; } ||
    { echor "🔴 Failed to install curl" && exit 1; }

# Install unzip
command -v unzip &>/dev/null && echob "☑️ unzip already installed" ||
    { tput smcup && echot "ℹ️ Installing unzip" &&
        eval "$install_cmd unzip" &&
        tput rmcup && echog "✅ unzip installed"; } ||
    { echor "🔴 Failed to install unzip" && exit 1; }

# Install git
command -v git &>/dev/null && echob "☑️ git already installed" ||
    { tput smcup && echot "ℹ️ Installing git" &&
        eval "$install_cmd git" &&
        tput rmcup && echog "✅ git installed"; } ||
    { echor "🔴 Failed to install git" && exit 1; }

# Install cargo
[ -f ~/.cargo/env ] &>/dev/null && echob "☑️ cargo already installed" ||
    { tput smcup && echot "ℹ️ Installing cargo" &&
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y &&
        tput rmcup && echog "✅ cargo installed"; } ||
    { echor "🔴 Failed to install cargo" && exit 1; }
. ~/.cargo/env # Source cargo

# Install lsd with cargo
command -v lsd &>/dev/null && echob "☑️ lsd already installed" ||
    { tput smcup && echot "ℹ️ Installing lsd" &&
        cargo install lsd &&
        tput rmcup && echog "✅ lsd installed"; } ||
    { echor "🔴 Failed to install lsd" && exit 1; }

# Install golang
current_go_version="$(go version 2>/dev/null | awk '{print $3}')"
latest_go_version="$(curl -fsSL "https://go.dev/VERSION?m=text" | head -1)"
case "$(uname -s)$(uname -m)" in
"Linuxx86_64") go_arch="linux-amd64" ;;
"Linuxaarch64") go_arch="linux-arm64" ;;
"Darwinx86_64") go_arch="darwin-amd64" ;;
"Darwinaarch64") go_arch="darwin-arm64" ;;
*) echor "unknown architecture, don't care" && exit 1 ;;
esac
filename="$latest_go_version.$go_arch.tar.gz"
[[ "$current_go_version" == "$latest_go_version" ]] &>/dev/null && echob "☑️ go ($latest_go_version) already installed" ||
    { tput smcup && echot "ℹ️ Installing go ($latest_go_version)" &&
        eval "$prefix rm -rf /usr/local/go && curl -fsSL https://go.dev/dl/$filename | $prefix tar xvzf - -C /usr/local" &&
        tput rmcup && echog "✅ go installed"; } ||
    { echor "🔴 Failed to install go" && exit 1; }

# Install fzf (written in go)
[ -d ~/.fzf ] &>/dev/null && echob "☑️ fzf already installed" ||
    { tput smcup && echot "ℹ️ Installing fzf" &&
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all &&
        tput rmcup && echog "✅ fzf installed"; } ||
    { echor "🔴 Failed to install fzf" && exit 1; }

# Install lazygit with go
command -v lazygit &>/dev/null && echob "☑️ lazygit already installed" ||
    { tput smcup && echot "ℹ️ Installing lazygit" &&
        go install github.com/jesseduffield/lazygit@latest &&
        tput rmcup && echog "✅ lazygit installed"; } ||
    { echor "🔴 Failed to install lazygit" && exit 1; }

# Install yazi if yazi command is found
# Download yazi zip for identified system build
# Move file contents into /usr/local/yazi (delete if existing)
# Move binaries into /usr/local/bin
case "$(uname -s)$(ldd --version | grep -o GNU)" in
"LinuxGNU") yazi_arch="unknown-linux-gnu" ;;
"Linux") yazi_arch="unknown-linux-musl" ;;
"Darwin") yazi_arch="apple-darwin" ;;
esac
yazi_stem="yazi-$(uname -m)-$yazi_arch"
yazi_link="https://github.com/sxyazi/yazi/releases/download/v26.1.22/$yazi_stem.zip"
yazi_tmp_dir="$(mktemp -d)"
yazi_zip_path="$yazi_tmp_dir/yazi.zip"
command -v yazi &>/dev/null && echob "☑️ yazi already installed" ||
    { tput smcup && echot "ℹ️ Installing yazi" &&
        eval "$prefix rm -rf /usr/local/yazi && curl -fsSL $yazi_link -o $yazi_zip_path && 
            unzip $yazi_zip_path -d $yazi_tmp_dir && $prefix mv $yazi_tmp_dir/$yazi_stem /usr/local/yazi &&
            $prefix mv -f /usr/local/yazi/* /usr/local/bin" &&
        tput rmcup && echog "✅ yazi installed"; } ||
    { echor "🔴 Failed to install yazi" && exit 1; }

# Install fnm if the directory does not already exist at ~/.local/share/fnm
[ -d ~/.local/share/fnm ] &>/dev/null && echob "☑️ fnm already installed" ||
    { tput smcup && echot "ℹ️ Installing fnm" &&
        curl -fsSL https://fnm.vercel.app/install | bash 2>&1 | grep -Pq "Could not infer shell type|open a new terminal" &&
        tput rmcup && echog "✅ fnm installed"; } ||
    { echor "🔴 Failed to install fnm" && exit 1; }

# Install uv if the binary does not exist yet at ~/.local/bin/uv
[ -f ~/.local/bin/uv ] &>/dev/null && echob "☑️ uv already installed" ||
    { tput smcup && echot "ℹ️ Installing uv" &&
        curl -LsSf https://astral.sh/uv/install.sh | sh &&
        tput rmcup && echog "✅ uv installed"; } ||
    { echor "🔴 Failed to install uv" && exit 1; }

# Create uv venv in home directory if one does not exist
[ -f ~/.venv/bin/activate ] || (cd ~ && uv venv &>/dev/null)

# Install zoxide
[ -f ~/.local/bin/zoxide ] && echob "☑️ zoxide already installed" ||
    { tput smcup && echot "ℹ️ Installing zoxide" &&
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh &&
        tput rmcup && echog "✅ zoxide installed"; } ||
    { echor "🔴 Failed to install zoxide" && exit 1; }

# Create backups
[ -d ~/.config ] || mkdir -p ~/.config
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak && echot "ℹ️ Backup ~/.zshrc -> ~/.zshrc.bak"
[ -f ~/.zshenv ] && mv ~/.zshenv ~/.zshenv.bak && echot "ℹ️ Backup ~/.zshenv -> ~/.zshenv.bak"
[ -d ~/.config/zsh ] && rm -rf ~/.config/zsh.bak && mv ~/.config/zsh ~/.config/zsh.bak && echot "ℹ️ Backup ~/.config/zsh -> ~/.config/zsh.bak"

# Clone config repo
echo 'export ZDOTDIR=$HOME/.config/zsh' >~/.zshenv && echot "ℹ️ Set ZDOTDIR TO ~/.config/zsh"
export ZDOTDIR=$HOME/.config/zsh
{ tput smcup && echot "ℹ️ Cloning dotzsh into ~/.config/zsh" &&
    git clone --depth=1 https://github.com/huncholane/dotzsh ~/.config/zsh &&
    tput rmcup && echog "✅ dotzsh cloned to ~/.config/zsh"; } ||
    { echor "🔴 Failed to clone dotzsh into ~/.config/zsh" && exit 1; }

# Install antidote
{ tput smcup && echot "ℹ️ Cloning antidote into ~/.config/zsh/.antidote" &&
    git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote &&
    tput rmcup && echog "✅ antidote installed"; }

# Start new shell with everything installed
exec zsh
