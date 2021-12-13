#!/usr/bin/env bash

set -e
BASEDIR="$(cd "$(dirname "$0")/.." && pwd)"

function log_section() {
    printf "\033[0;32m==>\033[0m\033[1m ${*}\033[0m\n"
}

function log_warning() {
    printf "\033[1mWARN\033[0m: ${*}\n"
}

function log_error() {
    printf "\033[1mERROR\033[0m: ${*}\n"
}

function safe_git_clone() {
    if [[ ! -d ${2} ]]; then
        git clone ${1} ${2}
    else
        log_warning "${2} exists, do nothing."
    fi
}

log_section "Git Config"
git config --global user.email "chen.kuangye@gmail.com"
git config --global user.name "Kuangye Chen"
printf "Name: $(git config user.name), Email: $(git config user.email)\n"

log_section "Install Oh-My-Zsh"
if [[ ! -d ${HOME}/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
log_section "Change default shell to Zsh"
if [[ "$(grep ${USER} </etc/passwd | cut -f 7 -d ":")" != "/bin/zsh" ]]; then
    chsh -s /bin/zsh
fi
ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"

log_section "Install Oh-My-Zsh Themes and Plugins"
safe_git_clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
safe_git_clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
safe_git_clone https://github.com/KuangyeChen/zsh-rm2trash ${ZSH_CUSTOM}/plugins/zsh-rm2trash
safe_git_clone https://github.com/bhilburn/powerlevel9k.git ${ZSH_CUSTOM}/themes/powerlevel9k
if [[ ${OSTYPE} == linux-gnu ]]; then
    git clone https://github.com/powerline/fonts.git --depth=1 /tmp/fonts
    /tmp/fonts/install.sh && rm -rf /tmp/fonts
fi

function safe_link() {
    if [[ -e ${2} ]]; then
        log_warning "${2} exists, backup with timestamp."
        mv ${2} ${2}_$(date +%Y-%m-%d_%H-%M-%S)
    fi
    ln -s ${1} ${2}
    printf "Link ${2} -> ${1}\n"
}

function batch_link() {
    printf "Link all files in ${1} to ${2}.\n"
    for file in ${1}/.*; do
        if [[ "$(basename ${file})" == "*" ]] || [[ "$(basename ${file})" == "." ]] || [[ "$(basename ${file})" == ".." ]]; then
            continue
        fi
        safe_link ${file} ${2}/$(basename ${file})
    done
    for file in ${1}/*; do
        if [[ "$(basename ${file})" == "*" ]] || [[ "$(basename ${file})" == "." ]] || [[ "$(basename ${file})" == ".." ]]; then
            continue
        fi
        safe_link ${file} ${2}/$(basename ${file})
    done
}

log_section "Link Files"
batch_link ${BASEDIR}/dotfiles ${HOME}
batch_link ${BASEDIR}/zsh ${ZSH_CUSTOM}

log_section "Install Vim Plugins"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c "PlugInstall" -c ":q" -c ":q" -c ":q" -c ":q"
