#!/usr/bin/env bash

set -x
export IMG_PATH=${IMG_PATH:-"./image"}
export IMG_NAME=${IMG_NAME:-"Arch-Linux-x86_64-cloudimg.qcow2"}
export IMG_FILE="${IMG_PATH}/${IMG_NAME}"

sudo modprobe nbd max_part=2 || { echo "err load nbd"; exit 1; }
sudo qemu-nbd --connect=/dev/nbd0 "$IMG_FILE" || { echo "err load nbd"; exit 1; }
sudo fdisk -l /dev/nbd0
sudo mkdir -p ./mnt
sudo mount /dev/nbd0p3 ./mnt || { echo "err load nbd"; exit 1; }

# prepare

# Debug
# echo "DEBUG with root password"
# export ROOT_PASSWORD=$(gpg --gen-random --armor 1 15)
# echo "password: '${ROOT_PASSWORD}'"
# sudo arch-chroot ./ bash -c "echo '${ROOT_PASSWORD}' | passwd --stdin root" || { echo "err set root password"; exit 1; }

cd mnt && sudo cp -rf ../config/etc ./ && cd ..

# prepare end

sudo umount ./mnt && sudo rm -rf ./mnt || echo "err unmount temporary folder 'mnt'"
sudo qemu-nbd --disconnect /dev/nbd0 || echo "err disconnect image"
sudo rmmod nbd || echo "err unload nbd"
