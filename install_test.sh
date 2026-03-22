#!/bin/bash

case "$1" in
"ubuntu") docker run --rm -v "$(pwd):/installer" -w /installer -it ubuntu bash -c "
  apt update -y && apt install sudo -y && useradd test -m && echo test:test | chpasswd && usermod -aG sudo test && 
  ln -s /installer/install.sh /bin/doit && su - test" ;;
"arch") docker run --rm -v "$(pwd):/installer" -w /installer -it archlinux bash -c "
  pacman --noconfirm -Syu && pacman -S sudo --noconfirm && useradd test -m && usermod -aG wheel test && 
  echo test:test | chpasswd && sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers && 
  ln -s /installer/install.sh /bin/doit && su - test" ;;
*) echo "usage: install_test.sh [ubuntu|arch]"
esac
