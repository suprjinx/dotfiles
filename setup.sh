#! /bin/bash

if [ -f /etc/debian_version ]; then
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
	htop \
	ruby
fi

# Docker (skip if Docker Desktop is providing the CLI)
if ! command -v docker &> /dev/null; then
    sudo apt install docker.io
    sudo usermod -aG docker "$USER"
elif docker info 2>&1 | grep -q "Docker Desktop"; then
    echo "Docker Desktop detected, skipping Docker Engine install"
fi

# Dagger
if ! command -v dagger &> /dev/null; then
    curl -fsSL https://dl.dagger.io/dagger/install.sh | BIN_DIR=$HOME/.local/bin sh
fi

# Tmuxinator
if ! command -v tmuxinator &> /dev/null; then
    sudo gem install tmuxinator
fi

# Go tools
go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@latest
go install golang.org/x/tools/gopls@latest

# Claude
curl -fsSL https://claude.ai/install.sh | bash

# Fish
chsh -s $(which fish)

# Install configs
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
stow -v --adopt -t "$HOME" -d "$SCRIPT_DIR" home

