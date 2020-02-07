#!/usr/bin/env bash

# ==============================
# dotfiles
#     - config-network.sh
#
# Author: Bruce Frank Wong
# Created: 2020-02-07 16:53
#
# ==============================

# This BASH script is used to:
#     Config the network.



function usage() {
    echo "Usage:"
    echo "    ${0} HOSTNAME"
    echo "Change the hostname."
    echo ""
    echo "    HOSTNAME    the new hostname."
}



# ------------------------------
# network interface.
sudo cat << EOF > /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

sources /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
# Virtual machine to Host
auto enp0s3
iface enp0s3 inet dhcp

# The secondary network interface
# Host to Virtual machine
auto enp0s8
iface enp0s8 inet static
    address 192.168.56.2
    netmask 255.255.255.0
    gateway 192.168.56.1
    metric 1000
EOF

ifdown enp0s3 && ifup enp0s3
ifdown enp0s8 && ifup enp0s8



# ------------------------------
# hostname
if [ $# -]
OLD=$(cat /etc/hostname)

sed -i "s/${OLD}/${1}/g" /etc/hostname
sed -i "s/${OLD}/${1}/g" /etc/hosts



# Unset variables.
unset OLD


exit 0
