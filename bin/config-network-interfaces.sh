#!/usr/bin/env bash

# ==============================
# 
# dotfiles
#     - config-network-interfaces.sh
#
# Author: Bruce Frank Wong
# Created: 2020-02-08 00:10:18
#
# ==============================

# This BASH script is used to:
#    Configure the network interfaces for virtual machine on VirtualBox.
#

set -eu
set -o pipefail


function usage() {
    echo "Usage: ${0}"
    echo "Configure the network interfaces for virtual machine on VirtualBox."
}



# ------------------------------
# Get the environment.
if [ ! -v DOTFILES ]; then
    DOTFILES=${HOME}/projects/dotfiles
fi
if [ ! -v THIS_MACHINE ] || [ ! -v THIS_PLATFORM ]; then
    source ${DOTFILES}/bin/get_env.sh
fi



# ------------------------------
# Run on VirtualBox only.
if [ "x${THIS_MACHINE}" != "xvirtual" ] || [ "x${THIS_PLATFORM}" != "xoracle" ]; then
    usage
    exit 1
fi

# ------------------------------
# Config the network interface.
sudo cp /etc/network/interfaces /etc/network/interfaces.backup
sudo cp ${DOTFILES}/config/system/network-interfaces.virtualbox /etc/network/interfaces

sudo ifdown enp0s3 && ifup enp0s3
sudo ifdown enp0s8 && ifup enp0s8


exit 0
