#!/bin/bash

case "$1" in
"ubuntu") docker run --rm -v "$(pwd):/installer" -w /installer -it ubuntu bash -c "
  apt update -y && apt install sudo -y && useradd test -m && echo test:test | chpasswd && usermod -aG sudo test &&
  su - test" ;;
"arch") docker run --rm -v "$(pwd):/installer" -w /installer -it arch 'pacman -Syu --noconfirm && pacman -S && pacman -S --noconfirm && useradd test && bash' ;;
esac
