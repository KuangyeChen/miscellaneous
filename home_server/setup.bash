#!/usr/bin/env bash

set -e
BASEDIR=$(cd "$(dirname ${0})/.." && pwd)

function log_section() {
    printf "\033[0;32m==>\033[0m\033[1m ${*}\033[0m\n"
}

function safe_git_clone() {
    if [[ ! -d ${2} ]]; then
        git clone ${1} ${2}
    else
        log_warning "${2} exists, do nothing."
    fi
}

log_section "Update System"
sudo apt -y update
sudo apt -y upgrade

log_section "APT Install"
sudo apt install -y build-essential cmake gcc g++ docker.io cockpit net-tools cockpit-podman \
                    python3 python3-dev python3-pip python3-yaml \
                    git wget curl lm-sensors tmux htop zsh zfsutils-linux

log_section "Docker"
sudo usermod -aG docker ${USER}
sudo curl -SL https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

log_section "Add serveradmin user and group"
sudo addgroup --system --gid 930 serveradmin
sudo adduser --system --uid 930 --gid 930 serveradmin
sudo usermod -a -G serveradmin ${USER}

log_section "Install many things"
curl  https://get.acme.sh | sh -s email=chen.kuangye@gmail.com
safe_git_clone https://github.com/pyenv/pyenv.git ~/.pyenv
safe_git_clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
