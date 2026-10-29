#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO="https://github.com/igng/dotfiles.git"
DOTFILES_DIR="${HOME}/dotfiles"

if [[ ! -d "${DOTFILES_DIR}/.git" ]]; then
    git clone "${DOTFILES_REPO}" "${DOTFILES_DIR}"
else
    echo "Dotfiles repository already exists: ${DOTFILES_DIR}"
fi

cd "${DOTFILES_DIR}"
source install.sh
echo "Dotfiles setup complete."
