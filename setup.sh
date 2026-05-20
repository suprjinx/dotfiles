#! /bin/bash
set -euo pipefail

# Ensure Homebrew is installed and on PATH (works on macOS and Linux).
ensure_brew() {
    if ! command -v brew &> /dev/null; then
        NONINTERACTIVE=1 /bin/bash -c \
            "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # brew may not be on PATH yet in this shell; source it from the
    # known install locations for macOS (arm/intel) and Linuxbrew.
    for brew_bin in \
        /opt/homebrew/bin/brew \
        /usr/local/bin/brew \
        /home/linuxbrew/.linuxbrew/bin/brew \
        "$HOME/.linuxbrew/bin/brew"; do
        if [ -x "$brew_bin" ]; then
            eval "$("$brew_bin" shellenv)"
            break
        fi
    done

    command -v brew &> /dev/null || { echo "brew install failed" >&2; exit 1; }
}

# Linux: install the minimum Homebrew needs before bootstrapping it
if [ -f /etc/debian_version ]; then
    sudo apt-get update
    sudo apt-get install -y --no-install-recommends \
        curl git ca-certificates procps file build-essential
fi

ensure_brew

brew install \
    tmux \
    fish \
    jq \
    emacs \
    curl \
    bind \
    fzf \
    the_silver_searcher \
    jansson \
    stow \
    gh \
    go \
    make \
    htop \
    ruby

# Docker (skip if Docker Desktop is providing the CLI)
if ! command -v docker &> /dev/null; then
    sudo apt install docker.io docker-compose-v2
    sudo usermod -aG docker "$USER"
elif docker info 2>&1 | grep -q "Docker Desktop"; then
    echo "Docker Desktop detected, skipping Docker Engine install"
fi

# Dagger
if ! command -v dagger &> /dev/null; then
    curl -fsSL https://dl.dagger.io/dagger/install.sh | BIN_DIR=$HOME/.local/bin sh
fi

# Tmuxinator (via brew-installed ruby; no sudo needed)
if ! command -v tmuxinator &> /dev/null; then
    gem install tmuxinator
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

