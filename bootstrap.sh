#!/usr/bin/env bash

# Change timezone.
sudo timedatectl set-timezone Asia/Shanghai

# Update package list.
sudo apt-get update

# Install packages.
sudo apt-get install -y \
    zsh \
    git \
    wget \
    xclip \
    python-pip \
    python3-pip \
    virtualenv \
    virtuanenvwrapper

# Change shell.
chsh -s /usr/bin/zsh

# <.zshrc> file.
touch ${HOME}/.zshrc


# Install oh-my-zsh.
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

