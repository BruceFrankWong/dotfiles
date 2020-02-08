#!/usr/bin/env bash

# ==============================
# 
# dotfiles
#     - config-hostname.sh
#
# Author: Bruce Frank Wong
# Created: 2020-02-08 00:13:51
#
# ==============================

# This BASH script is used to:
#    Configure the hostname.
#
# Valid check in not impletment.

set -eu
set -o pipefail


function usage() {
    echo "Usage:"
    echo "    ${0} HOSTNAME"
    echo "Configure the hostname."
}



# ------------------------------
# Error handler.
if [ ! $# -eq 1 ]; then
    usage
    exit 1
fi


# ==============================
# Config the network interface.
OLD=$(cat /etc/hostname)

sudo sed -i "s/${OLD}/${1}/g" /etc/hostname
sudo sed -i "s/${OLD}/${1}/g" /etc/hosts



exit 0
