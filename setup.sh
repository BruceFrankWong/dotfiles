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
    mkdir ${DEFAULT_PROJECT_PATH}
    cd ${DEFAULT_PROJECT_PATH}
    git clone https://github.com/BruceFrankWong/dotfiles.git
fi



# ------------------------------
# BASH.
if [ -f ${HOME}/.bashrc ]; then
    mv ${HOME}/.bashrc ${HOME}/.bashrc_old
fi

# bashrc.
ln -s ${DOTFILES}/config/shell/bashrc ${HOME}/.bashrc


# ------------------------------
# ZSH.
# Install ZSH.
if [ -f /bin/zsh ] || [ -f /usr/bin/zsh ]; then
    sudo apt-get install --assume-yes --no-install-recommends zsh
fi

# Change user shell.
chsh --shell /bin/zsh

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
ln -s ${DOTFILES}/config/shell/zshrc ${HOME}/.zshrc



# ------------------------------
# Shell alias.
ln -s ${DOTFILES}/config/shell/alias ${HOME}/.alias



# ------------------------------




# ------------------------------
# git
ln -s ${HOME}/.config/git/gitconfig ${HOME}/.gitconfig



# ------------------------------
# vim



# ------------------------------
# Install docker.
# ------------------------------
# Install Docker
sh -c "$(curl -fsSL https://get.docker.com)"

# ------------------------------
# Install docker-compose
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# ------------------------------
# Add mirror sites, and restart docker.
ln -s ${HOME}/.config/git/gitconfig ${HOME}/.gitconfig
systemctl daemon-reload
systemctl restart docker.service



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

