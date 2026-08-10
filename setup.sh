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
    ruby \
    mc \
    mg \
    tmuxinator \
    dagger \
    fresh-editor \
    claude-code \
    net-tools

# Docker
if command -v docker &> /dev/null; then
    if docker info 2>&1 | grep -qE "Docker Desktop|OrbStack"; then
        echo "Docker Desktop/OrbStack detected, skipping Docker Engine install"
    fi
elif [ "$(uname -s)" = "Darwin" ]; then
    # macOS: install OrbStack, which provides a real docker/docker compose CLI.
    echo "Installing OrbStack (Docker engine + CLI for macOS)..."
    brew install --cask orbstack
    echo "Launch OrbStack once to start the Docker engine: open -a OrbStack"
elif [ -f /etc/debian_version ]; then
    # Linux (Debian/Ubuntu): install the Docker engine from apt.
    sudo apt install -y docker.io docker-compose-v2
    sudo usermod -aG docker "$USER"
else
    echo "No docker found and no known installer for this OS; install Docker manually." >&2
fi

# Go tools
go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@latest
go install golang.org/x/tools/gopls@latest

# Fish
chsh -s $(which fish)

# Install configs
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
stow -v --adopt -t "$HOME" -d "$SCRIPT_DIR" home

