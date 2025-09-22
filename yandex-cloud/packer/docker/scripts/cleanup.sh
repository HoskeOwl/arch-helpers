#!/usr/bin/env bash
set -euo pipefail

set -x

# remove history
rm -f /home/arch/.bash_history
rm -f /home/arch/.zsh_history
rm -f /root/.bash_history
rm -f /root/.zsh_history

# remove ssh configs
rm -rf /home/arch/.ssh
rm -rf /root/.ssh

#remove ssh keys
rm -f /etc/ssh/*_key*

# clear machine-id
rm -f /etc/machine-id
touch /etc/machine-id

if [ -d "/var/lib/dhcp" ]; then
    rm -rf /var/lib/dhcp/*
fi

rm -rf /tmp/*

# remove unused packages (only if any exist)
orphans=$(pacman -Qtdq || true)
if [ -n "$orphans" ]; then
    pacman -Rns --noconfirm $orphans
fi

grep "arch" /etc/passwd && rm -rf /home/arch/.cache
rm -rf /root/.cache

#clean sudoers
rm -f /etc/sudoers.d/*

find /var/log -type f -delete
journalctl --rotate 2>/dev/null
journalctl --vacuum-time=1s 2>/dev/null

grep "arch" /etc/passwd && usermod -L arch
