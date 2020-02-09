#!/usr/bin/env bash

# ==============================
# 
# dotfiles
#     - setup.sh
#
# Author: Bruce Frank Wong
# Created: 2020-02-01 11:15:50
#
# ==============================

# This BASH script is used to:
#     - Install and config the softwares;
#     - Config the environment
#
# Softwares to be installed:
#     - oh-my-zsh
#       - z.lua
#     - docker and docker-compose
#     - 

# The configurations are stored in <~/.config> direcotry.
# The configurations are stored in <~/.config> direcotry.
# The configurations are stored in <~/.config> direcotry.
#
# The config
# ~/.config
#   |--shell    # bash and zsh
#   |--vim
#   |--nano
#   |--git
#   |--docker
#
# The data
# ~/.local
#   |--bin



set -euxo pipefail



# ==============================
# Functions.
# ==============================
function usage() {
    echo "Usage:"
    echo "    ${0}"
    echo "Install softwares and config enviroment for a new user."
    echo "This script MUST NOT run as root."
}



# ==============================
# Privilege.
# ==============================
if [ "$USER" = "root" ];then
    usage
    exit 1
fi



# ==============================
# Configurations.
# ==============================

# The default project path.
DEFAULT_PROJECT_PATH=${HOME}/Projects/

# docker-compose version.
DOCKER_COMPOSE_VERSION=1.25.3


# ------------------------------
# Other.
DOTFILES=${DEFAULT_PROJECT_PATH}/dotfiles



# ==============================
# Configurations.
# ==============================

# ------------------------------
# Clone the whole project.
if [ ! -d ${DEFAULT_PROJECT_PATH} ]; then
    git clone https://github.com/BruceFrankWong/dotfiles.git ${DOTFILES}
else
    echo "***** ERROR *****"
    echo "The directory ${DEFAULT_PROJECT_PATH} is already existed."
    exit 1
fi



# ------------------------------
# BASH.
if [ -f ${DOTFILES}/config/shell/bashrc ]; then
    if [ -f ${HOME}/.bashrc ]; then
        rm ${HOME}/.bashrc
    fi
    ln -s ${DOTFILES}/config/shell/bashrc ${HOME}/.bashrc
else
    echo "WARNING: ${DOTFILES}/config/shell/bashrc not found."
fi


# ------------------------------
# ZSH.
# Install ZSH, if not installed before.
if [ ! -f /bin/zsh ] || [ ! -f /usr/bin/zsh ]; then
    sudo apt-get install --assume-yes --no-install-recommends zsh
fi

# Change user's shell, if not did this before.
CURRENT_SHELL=$(cat /etc/passwd | grep bruce | cut -d ':' -f7)
if [ ${CURRENT_SHELL:0-3:3} != zsh ]; then
    chsh --shell /bin/zsh
fi

# Make an empty .zshrc file to prevent zsh-newuser-install running when interactive login.
# touch ${HOME}/.zshrc

# Install oh-my-zsh.
if [ ! -d ${HOME}/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install z.lua
mkdir ${HOME}/.oh-my-zsh/custom/plugins/z.lua
curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh
if [ ! -f ${HOME}/.zlua ]; then
    ln -s ${HOME}/.config/zlua ${HOME}/.zlua
fi

if [ -f ${HOME}/.zshrc ]; then
    mv ${HOME}/.zshrc ${HOME}/.zshrc_old
fi

# zshrc.
if [ -f ${DOTFILES}/config/shell/zshrc ]; then
    ln -s ${DOTFILES}/config/shell/zshrc ${HOME}/.zshrc
else
    echo "WARNING: ${DOTFILES}/config/shell/zshrc not found."
fi



# ------------------------------
# Shell alias.
if [ -f ${DOTFILES}/config/shell/alias ]; then
    ln -s ${DOTFILES}/config/shell/alias ${HOME}/.alias
else
    echo "WARNING: ${DOTFILES}/config/shell/alias not found."
fi



# ------------------------------




# ------------------------------
# git
if [ -f ${DOTFILES}/config/git/gitconfig ]; then
    ln -s ${DOTFILES}/config/git/gitconfig ${HOME}/.gitconfig
else
    echo "WARNING: ${DOTFILES}/config/git/gitconfig not found."
fi



# ------------------------------
# vim
if [ -f ${DOTFILES}/config/vim/vimrc ]; then
    ln -s ${DOTFILES}/config/vim/vimrc ${HOME}/.vimrc
else
    echo "WARNING: ${DOTFILES}/config/vim/vimrc not found."
fi


# ------------------------------
# Install docker.
# ------------------------------
# Install Docker
sh -c "$(curl -fsSL https://get.docker.com)"

# ------------------------------
# Install docker-compose
URL_DOCKER_COMPOSE="https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}"
sudo curl -L "${URL_DOCKER_COMPOSE}/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# ------------------------------
# Add mirror sites, and restart docker.
sudo ln -s ${DOTFILES}/config/docker/daemon.json /etc/docker/daemon.json

sudo systemctl daemon-reload
sudo systemctl restart docker.service



# ------------------------------
# Pull docker images.
if [ -f images.env ]; then
    mapfile IMAGE_LIST < images.env

    for i in ${!array[*]}; do      # 以数组index的方式遍历数组
        while [ sudo docker pull ${array[$i]} ]; do
            sudo docker pull ${array[$i]}
        done
    done
fi



# ==============================
# Exit
exit 0

