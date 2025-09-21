#/usr/bin/env bash

rm -rf /etc/pacman.d/gnupg
mkdir /etc/pacman.d/gnupg
pacman-key --init
