# dotzsh

Tired of reconfiguring mandatory programs over and over on new systems. This
one line install script fixes up a system to become a developement power house.

## Oneline Installer

```sh
curl -fsSL https://raw.githubusercontent.com/huncholane/dotzsh/main/install.sh | bash
```

## Table of Contents

- [Programs Installed](#programs-installed)
- [Program Details](#program-details)
    - [Essentials](#essentials)
    - [Rust Related](#rust-related)
    - [Go Related](#go-related)
- [Antidote Plugins](#antidote-plugins)
- [Test Installer](#test-installer)

## Programs Installed

| Program | Installer | Description |
|---------|-----------|-------------|
| [base-devel](https://archlinux.org/packages/core/any/base-devel/) | System | Developer tools for arch systems (gcc/g++, make, binutils, libc headers, patch, fakeroot, pkgconf) |
| [build-essential](https://itsfoss.com/build-essential-ubuntu/) | System | Developer tools for debian systems (gcc/g++, make, binutils, libc headers, patch, fakeroot, pkgconf) |
| [git](https://git-scm.com/) | [System](https://git-scm.com/install/linux) | Repo management |
| [cargo](https://doc.rust-lang.org/cargo/) | [Install Script](https://doc.rust-lang.org/cargo/getting-started/installation.html) | Used for rust, also used to install some programs |
| [lsd](https://github.com/lsd-rs/lsd) | Cargo | Adds icons to ls |
| [go](https://go.dev/) | [Binary](https://go.dev/doc/install) | Programming language also used to install some programs |
| [fzf](https://github.com/junegunn/fzf) | [Git](https://github.com/junegunn/fzf) | Used in several programs to fuzzy find |
| [lazygit](https://github.com/jesseduffield/lazygit) | [Binary](https://github.com/jesseduffield/lazygit?tab=readme-ov-file#go) | Best way to use git by far (written in go) |
| [fnm](https://github.com/Schniz/fnm?tab=readme-ov-file#using-a-script-macoslinux) | [Install Script](https://github.com/Schniz/fnm) | Node version manager written in rust |
| [uv](https://docs.astral.sh/uv/) | [Install Script](https://docs.astral.sh/uv/getting-started/installation/) | Python environment manager written in rust |
| [yazi](https://yazi-rs.github.io/docs/quick-start) | [Binary](https://github.com/sxyazi/yazi/releases/tag/v26.1.22) | Miller pane tui file explorer |

## Program Details

### Essentials

**base-devel/build-essential - Must have**

Allows C/C++/Assembly programs work smoothly.

**git - Repo management**

Manages repos. This is used heavily for installing programs. Also used a ton as a developer.

### Rust Related

**cargo - Rust**

Rust manager that comes with rustup. Used for installing lsd. Also used with `nightly` to install blink in nvim. Essential for rust development.

**lsd - Pretty ls**

Pretty ls output. Alias `l` for `ls` with icons and `ll` for `ls -l` with icons.

**fnm - Node version management**

Node management written in rust. A much faster version of nvm. Alias `nvm` since it is muscle memory and fnm should be used instead for performance.

**uv - Python evironment management**

This one is interesting. This config sets up a a python environment in
`$HOME/.venv` and gets sourced automatically. This plays very nice with the
`zsh-auto-switch-vertialenv` plugin. Any directory with `.venv` in it will
automatically be sourced upon entry. It's like conda but faster and
automatically focused on the current directory.

**yazi - Miller pane tui file explorer**

A file explorer that looks like the mac file explorer using miller panes. This
one doesn't have a very good universal way to install, so the install script
makes installation smoother by determining architecture, download from github
release, and copy the binaries into `/usr/local/bin`.

### Go Related

**go - Programming language created by Google**

Some of the programs are installed using go. This is installed by checking the latest version online and installing for the detected architecture. The package is untarred into `/usr/local/go` and `/usr/local/go/bin` is added to the `PATH`.

**lazygit - The most incredible way to use git**

A tui to represent git and all of it's beauty written and installed through go. Used heavily in tmux with `prefix-G` on [dotmux](https://github.com/huncholane/dotmux).

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
