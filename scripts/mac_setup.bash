#!/usr/bin/env bash

set -e
BASEDIR="$(cd "$(dirname "$0")/.." && pwd)"

function log_section() {
    printf "\033[0;32m==>\033[0m\033[1m ${*}\033[0m\n"
}

log_section "Install Homebrew"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

log_section "Brew Install"
BREW_INSTALLS=(
    wget
    git
    pyenv-virtualenv
    pyenv
    pipenv
    htop
    screenfetch
    tmux
    unrar
    vim
    python3
)
BREW_CASK_INSTALLS=(
    iterm2
    google-chrome
    macvim
    font-ubuntu-mono-derivative-powerline
    logitech-options
    clashx
    istat-menus
)

brew tap homebrew/cask-fonts
brew tap homebrew/cask-drivers

for FORMULA in "${BREW_INSTALLS[@]}"; do
    brew install $FORMULA
done
brew unlink vim
for FORMULA in "${BREW_CASK_INSTALLS[@]}"; do
    brew install --cask $FORMULA
done
brew link --overwrite vim

log_section "Common Setup"
${BASEDIR}/common_setup.bash
