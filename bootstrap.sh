#!/usr/bin/env bash

# ==============================
# 
# dotfiles
#     - bootstrap.sh
#
# Author: Bruce Frank Wong
# Created: 2020-01-31 08:54:01
#
# ==============================

# This BASH script is used to：
#     - Install the basic software from Debian repository;
#     - Put the default user in <sudoers> file.
#
# This script should be run as ROOT, or in su mode.



set -euxo pipefail


# ==============================
# Functions.
# ==============================
function usage() {
    echo "Usage:"
    echo "    ${0} LOGIN."
    echo "Initiliaze enviroment for a new THIS_SYSTEM."
    echo ""
    echo "    LOGIN    A common account."
    echo ""
    echo "This script MUST run as root. you can do it in two ways:"
    echo "1) login as root"
    echo "2) run with <su>:"
    echo "    su -l -c $0"
}


function install_on_macos() {
    # ------------------------------
    # Install Homebrew.
    xcode-select --install
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # TODO:
    # Need complete.
}


function install_on_debian() {
    # ------------------------------
    # Modify the repository.
    cat << EOF > /etc/apt/sources.list
# Use the USTC (University of Science and Technology of China) mirror site.
deb http://mirrors.ustc.edu.cn/debian/ buster main contrib non-free
deb-src http://mirrors.ustc.edu.cn/debian/ buster main contrib non-free

# buster-updates, previously known as 'volatile'
deb http://mirrors.ustc.edu.cn/debian/ buster-updates main contrib non-free
deb-src http://mirrors.ustc.edu.cn/debian/ buster-updates main contrib non-free

# Debian official security repository.
deb http://security.debian.org/debian-security buster/updates main contrib non-free
deb-src http://security.debian.org/debian-security buster/updates main contrib non-free
EOF


    # ------------------------------
    # Install softwares.
    apt-get update
    apt-get install --assume-yes --no-install-recommends \
        sudo \
        curl \
        zsh \
        vim \
        git \
        tmux \
        rsync


    # ------------------------------
    # Make the account can use <sudo> command.
    cat << EOF > /etc/sudoers.d/bruce
${ACCOUNT}   ALL = (ALL:ALL) ALL
EOF
    chmod =0400 /etc/sudoers.d/bruce
}


function install_on_alpine() {
    ALPINE_VERSION="$(echo ${THIS_VERSION} | cut -d '.' -f1).$(echo ${THIS_VERSION} | cut -d '.' -f2)"
    # ------------------------------
    # Modify the repository.
    cat << EOF > /etc/apk/repositories
# Use the USTC (University of Science and Technology of China) mirror site.
https://mirrors.ustc.edu.cn/alpine/v${ALPINE_VERSION}/main
https://mirrors.ustc.edu.cn/alpine/v${ALPINE_VERSION}/community
EOF

    # TODO:
    # Need complete.
}



# ==============================
# Configurations.
# ==============================
# Basic packages.
PACKAGES='sudo curl zsh vim git tmux rsync lua'

# Default user account.
DEFAULT_ACCOUNT=bruce



# ==============================
# Main.
# ==============================

# ------------------------------
# Error handler.
if [ "$USER" != "root" ];then
    usage
    exit 1
fi
case $# in
    0)  ACCOUNT=${DEFAULT_ACCOUNT}
        ;;
    1)  ACCOUNT=$1
        ;;
    *)  usage
        exit 1
        ;;
esac


# ------------------------------
# Get current environment (OS, THIS_DISTRIBUTION, THIS_RELEASE or version, virtual or physical).

# According to:
#   <https://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux>
case "$(uname -s)" in
    Darwin*)
        THIS_SYSTEM=macOS
        THIS_DISTRIBUTION=$(sw_vers -productName)
        THIS_VERSION=$(sw_vers -productVersion)

        # According to:
        #   <https://stackoverflow.com/questions/28529633/how-to-detect-if-mac-os-x-is-being-run-inside-a-virtual-THIS_MACHINE>
        if [ -n "$(ioreg -l | grep 'Vendor Name' | grep -E 'Oracle|VirtualBox|Parallels|VMware')" ]; then
            THIS_MACHINE=Virtual
        else
            THIS_MACHINE=Physical
        fi
        ;;

    Linux*)
        THIS_SYSTEM=Linux
        # Alpine has no lsb_release by default.
        # THIS_DISTRIBUTION=$(lsb_release -a | grep 'Distributor ID' | cut -f2)
        # THIS_VERSION=$(lsb_release -a | grep 'Release' | cut -f2)
        THIS_DISTRIBUTION=$(cat /etc/*-release | grep '^ID=' | cut -d '=' -f2)
        THIS_VERSION=$(cat /etc/*-release | grep '^VERSION_ID=' | cut -d '=' -f2 | cut -d '"' -f2)

        # According to:
        #   <https://www.infoq.cn/article/536L*XPRudOwCkiTDgM4>
        if [ command -v systemd-detect-virt >/dev/null 2>&1 ]; then
            THIS_PLATFORM=$(systemd-detect-virt)
            if [ "x${THIS_PLATFORM}" != "xnone" ]; then
                THIS_MACHINE=Virtual
            then
                THIS_MACHINE=Physical
            fi
        else
            THIS_PLATFORM=Unknown
            THIS_MACHINE=Unknown
        fi
        ;;

    *)
        THIS_SYSTEM=Unknown
        THIS_DISTRIBUTION=Unknown
        THIS_VERSION=Unknown
        THIS_MACHINE=Unknown
esac



# ------------------------------
# Install
case ${THIS_SYSTEM} in
    macOS)
        install_on_macos
        ;;
    Linux)
        case ${THIS_DISTRIBUTION} in
            Debian)
                install_on_debian
                ;;
            Alpine)
                install_on_alpine
                ;;
            *)
                echo "Unknown Linux distributor. You have to install softwares manual."
        esac
        ;;
    Unknown)
        echo "Unknown Linux distributor. You have to install softwares manual."
esac




# ==============================
# Exit.
# ==============================

# Unset variables.
unset DEFAULT_ACCOUNT
unset PACKAGES
unset VERSION
unset ACCOUNT
unset THIS_MACHINE
unset THIS_SYSTEM
unset THIS_DISTRIBUTION
unset THIS_VERSION


exit 0
