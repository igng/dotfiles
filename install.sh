#!/bin/sh
# Install neovim, tmux and stow if missing.
# POSIX sh: run with `sh install.sh`, `bash install.sh` or `zsh install.sh`.

set -eu

NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
NVIM_DIR="/opt/nvim"
NVIM_LINK="/usr/bin/nvim"

have() { command -v "$1" >/dev/null 2>&1; }

if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
elif have sudo; then
    SUDO="sudo"
else
    echo "error: must be root or have sudo installed" >&2
    exit 1
fi

pkg_install() {
    if have pacman; then
        $SUDO pacman -S --needed --noconfirm "$@"
    elif have apt-get; then
        $SUDO apt-get update && $SUDO apt-get install -y "$@"
    elif have dnf; then
        $SUDO dnf install -y "$@"
    elif have zypper; then
        $SUDO zypper --non-interactive install "$@"
    elif have apk; then
        $SUDO apk add "$@"
    else
        echo "error: no supported package manager found" >&2
        return 1
    fi
}

install_nvim() {
    if [ "$(uname -s)" != "Linux" ] || [ "$(uname -m)" != "x86_64" ]; then
        echo "error: the neovim appimage is only fetched for linux x86_64" >&2
        return 1
    fi

    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT

    echo "Downloading neovim (latest stable appimage)..."
    if have curl; then
        curl -fL "$NVIM_URL" -o "$tmp/nvim.appimage"
    elif have wget; then
        wget -O "$tmp/nvim.appimage" "$NVIM_URL"
    else
        echo "error: curl or wget required" >&2
        return 1
    fi
    chmod +x "$tmp/nvim.appimage"

    $SUDO mkdir -p "$NVIM_DIR"
    $SUDO install -m 755 "$tmp/nvim.appimage" "$NVIM_DIR/nvim.appimage"
    target="$NVIM_DIR/nvim.appimage"

    # Appimages need FUSE; if it's missing, extract and use the unpacked binary (ref. instructions on neovim page about missing FUSE)
    if ! "$target" --version >/dev/null 2>&1; then
        echo "AppImage can't run (FUSE missing?), extracting instead..."
        (cd "$tmp" && ./nvim.appimage --appimage-extract >/dev/null)
        $SUDO rm -rf "$NVIM_DIR/squashfs-root"
        $SUDO mv "$tmp/squashfs-root" "$NVIM_DIR/squashfs-root"
        target="$NVIM_DIR/squashfs-root/AppRun"
    fi

    $SUDO ln -sf "$target" "$NVIM_LINK"
    trap - EXIT
    rm -rf "$tmp"
    echo "neovim linked at $NVIM_LINK"
}

link_vim() {
    # A symlink works from every shell, unlike an alias, and needs no rc edits.
    if have vim && [ "$(readlink -f "$(command -v vim)")" != "$(readlink -f "$NVIM_LINK")" ]; then
        echo "vim already installed, leaving it alone"
    else
        $SUDO ln -sf "$NVIM_LINK" /usr/bin/vim
        echo "vim -> nvim"
    fi
}

if have nvim; then
    echo "neovim already installed"
else
    install_nvim
    link_vim
fi

for p in tmux stow zsh; do
    if have "$p"; then
        echo "$p already installed"
    else
        echo "Installing $p..."
        pkg_install "$p"
    fi
done

# Install curl and wget; and the former to install oh-my-zsh
which curl &> /dev/null || sudo apt install curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install devcontainer 
curl -fsSL https://raw.githubusercontent.com/devcontainers/cli/main/scripts/install.sh | sh

# Move existing files into _bak
echo "Moving ~/.zshrc into ~/.zshrc_bak"
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc_bak
echo "Moving ~/.tmux.conf into ~/.tmux.conf_bak"
[ -f ~/.tmux.conf ] && mv ~/.tmux.conf ~/.tmux.conf_bak
# Stow every top-level, non-hidden directory (git, nvim, tmux, zsh, ...) into $HOME.
DOTFILES_DIR="~/dotfiles"
cd "$DOTFILES_DIR"
for dir in */; do
    pkg="${dir%/}"
    echo "Stowing $pkg..."
    stow --restow --target="$HOME" "$pkg" || echo "warning: failed to stow $pkg (conflicts?)" >&2
done
