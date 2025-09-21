#!/usr/bin/env bash
set -euo pipefail

pacman --noconfirm -Syu
pacman --noconfirm -Syy vim openssh htop net-tools curl less nftables grep docker docker-compose
