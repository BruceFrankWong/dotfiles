#!/usr/bin/env bash

# ==============================
# 
# dotfiles
#     - setup.sh
#
# Author: Bruce Frank Wong
# Created: 2020-02-01 11:27:48
#
# ==============================

# This BASH script is used to:
#
#     install Oracle VirtualBox.
#
# Images to be pulled is in <images.env> file.


set -u

VB_VERSION=6.1

# ------------------------------
# Get the environment.
if [ ! -v DOTFILES ]; then
    DOTFILES=${HOME}/projects/dotfiles
fi
if [ ! -v THIS_MACHINE ]; then
    source ${DOTFILES}/bin/get_env.sh
fi


# ------------------------------
# Prevent install VirtualBox on a virtual machin.
if [ "x${THIS_MACHINE}" = "xvirtual" ]; then
    echo "Do NOT install VirtualBox on a virtual machine.";
    exit 1;
fi

# ------------------------------
# Add the Oracle VirtualBox repository.
sudo cat << EOF >> /etc/apt/sources.list

# Oracle VirtualBox repository.
deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian buster contrib
EOF

# Add the Oracle public key for apt-secure.
sudo apt-key add https://www.virtualbox.org/download/oracle_vbox_2016.asc

# Install the Oracle VirtualBox.
sudo apt-get update
sudo apt-get install virtualbox-${VB_VERSION}

exit 0
