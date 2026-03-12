#! /bin/bash

sudo add-apt-repository ppa:ubuntuhandbook1/emacs
sudo add-apt-repository ppa:longsleep/golang-backports
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
    stow

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
stow -v -t "$HOME" -d "$(dirname "$SCRIPT_DIR")" "$(basename "$SCRIPT_DIR")"
