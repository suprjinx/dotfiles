#! /bin/bash

if [ -f /etc/debian_version ]; then
    sudo add-apt-repository -y ppa:ubuntuhandbook1/emacs
    sudo add-apt-repository -y ppa:longsleep/golang-backports
    sudo apt update

    sudo apt install -y \
        tmux \
        fish \
        jq \
        emacs-nox \
        curl \
        dnsutils \
        fzf \
        silversearcher-ag \
        net-tools \
        libjansson4 \
        libjansson-dev \
        stow \
	gh \
	golang-go \
	make \
	htop
fi

# Docker (skip if Docker Desktop is providing the CLI)
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com | sh
    sudo usermod -aG docker "$USER"
elif docker info 2>&1 | grep -q "Docker Desktop"; then
    echo "Docker Desktop detected, skipping Docker Engine install"
fi

# Dagger
if ! command -v dagger &> /dev/null; then
    curl -fsSL https://dl.dagger.io/dagger/install.sh | BIN_DIR=$HOME/.local/bin sh
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
stow -v --adopt -t "$HOME" -d "$SCRIPT_DIR" home
