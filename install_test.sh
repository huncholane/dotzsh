#!/bin/bash

# Usage statement
usage="\e[37musage: install_test.sh [arch|ubuntu]

Spins up a docker image for arch or ubuntu with the current directory as a volume in '/installer'. 
It links the install script at '/installer/install.sh' to '/usr/bin/doit' for convience. Just run
'doit' within the image to run the installer.

Options:
  --root,-r Should the image be ran in root. If not set, a test user with the password
            test is set as current shell.
\e[0m"

# Gather arguments
for var in "$@"; do
    case "$var" in
    --root) root=1 ;;
    -r) root=1 ;;
    ubuntu) os="ubuntu" ;;
    arch) os="arch" ;;
    -h) printf "$usage" && exit 1 ;;
    --help) printf "$usage" && exit 1 ;;
    esac
done

# Create command pieces
case "$os" in
ubuntu)
    docker_cmd="docker run --rm -v $(pwd):/installer -w /installer -it ubuntu bash"
    update_cmd="apt update -y && apt install sudo -y"
    user_cmd="useradd test -m && echo test:test | chpasswd && usermod -aG sudo test && ln -s /installer/install.sh /bin/doit && su - test"
    ;;
arch)
    docker_cmd="docker run --rm -v $(pwd):/installer -w /installer -it archlinux bash "
    update_cmd="pacman --noconfirm -Syu && pacman -S sudo --noconfirm"
    user_cmd="useradd test -m && usermod -aG wheel test && echo test:test | chpasswd && sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers"
    ;;
*) printf "$usage" && exit 1 ;;
esac
ln_cmd="ln -s /installer/install.sh /usr/bin/doit"

# Start the docker image
if [[ -n "$root" ]]; then # Create symlink and start bash
    eval "$docker_cmd -c \"$ln_cmd && bash\""
else # Create sudo user test:test and su - test
    eval "$docker_cmd -c \"$update_cmd && $user_cmd && $ln_cmd && su - test\""
fi
