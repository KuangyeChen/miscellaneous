#!/usr/bin/env bash

set -e
BASEDIR="$(cd "$(dirname "$0")/.." && pwd)"

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
sudo apt -y update && sudo apt -y upgrade

log_section "APT Install"
sudo apt install -y build-essential python3 python3-dev python3-pip cmake gcc g++ \
                    libssl-dev zlib1g-dev libncurses5-dev libncursesw5-dev libreadline-dev libsqlite3-dev \
                    libgdbm-dev libdb5.3-dev libbz2-dev libexpat1-dev liblzma-dev libffi-dev uuid-dev tk-dev
sudo apt install -y git wget curl vim-gtk3 lm-sensors htop zsh \
                    openssh-server gnome-tweak-tool ibus-sunpinyin gir1.2-gtop-2.0 gir1.2-nm-1.0

log_section "Install Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P /tmp/
sudo apt install -y /tmp/google-chrome-stable_current_amd64.deb

log_section "Install VScode"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt install -y apt-transport-https
sudo apt -y update
sudo apt install -y code

log_section "Install Pyenv"
safe_git_clone https://github.com/pyenv/pyenv.git ~/.pyenv
safe_git_clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

log_section "Install Docker"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt -y update && sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

log_section "Common Setup"
${KYC_MISC_PATH}/common_setup.bash
