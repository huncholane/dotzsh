# dotzsh

Tired of reconfiguring mandatory programs over and over on new systems. This
one line install script fixes up a system to become a developement power house.

```sh
curl -fsSL https://raw.githubusercontent.com/huncholane/dotzsh/main/install.sh | bash
```

## Programs Installed

| Program | Installer | Description | System |
|---------|-----------|-------------|--------|
| [git](https://git-scm.com/install/linux) | System | Repo management | All |
| [base-devel](https://archlinux.org/packages/core/any/base-devel/) | System | Developer tools | Arch |
| [go](https://go.dev/doc/install) | Binary | Programming language also used to install some programs | All | 
| [cargo](https://doc.rust-lang.org/cargo/getting-started/installation.html) | Install Script | Used for rust, also used to install some programs | All |
| [lsd](https://github.com/lsd-rs/lsd) | cargo | Adds icons to ls | All |
| [lazygit](https://github.com/jesseduffield/lazygit) | Binary | Best way to use git by far | All |
| [fnm](https://github.com/Schniz/fnm) | Install Script | Node manager written in rust | All |
| [uv](https://docs.astral.sh/uv/getting-started/installation/) | Install Script | Python environment manager written in rust | All |
| [yazi](https://github.com/sxyazi/yazi/releases/tag/v26.1.22) | Binary | Miller pane tui file explorer | All |

## Antidote Plugins

| Plugin | Description |
|--------|-------------|
| [fzf-tab](https://github.com/Aloxaf/fzf-tab) | Replace zsh tab completion with fzf |
| [zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode) | Vi mode for zsh |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Fish-like syntax highlighting as you type |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Fish-like inline suggestions from history |
| [zsh-autopair](https://github.com/hlissner/zsh-autopair) | Auto-close brackets, quotes, and parentheses |
| [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) | Type a command and arrow up/down to search history |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter cd that learns your most-used directories |
| [powerlevel10k](https://github.com/romkatv/powerlevel10k) | Fast, configurable zsh prompt theme |
| [zsh-autoswitch-virtualenv](https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv) | Auto-activate Python virtualenvs on cd |
| [forgit](https://github.com/wfxr/forgit) | Interactive git commands powered by fzf |

## Test Installer

The `install_test.sh` file runs a docker image for ubuntu (debian) or arch
given a parameter ubuntu or arch. It creates a user with sudo priviledge and
symlinks install.sh to `/bin/doit`. Just start the script to enter a test
docker container and run `doit` to try it on the container.
