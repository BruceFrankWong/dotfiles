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



# ==============================
# Functions.
# ==============================
function usage() {
    echo "Usage:"
    echo "    ${0} LOGIN."
    echo "Initiliaze enviroment for a new system."
    echo ""
    echo "    LOGIN    A common account."
    echo ""
    echo "This script MUST run as root. you can do it in two ways:"
    echo "1) login as root"
    echo "2) run with <su>:"
    echo "    su -l -c $0"
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
# Get current environment (VirtualBox or physics machine).

# According to:
#   <https://www.infoq.cn/article/536L*XPRudOwCkiTDgM4>
if [ "$(systemd-detect-virt)" != "none" ]; then
    IS_VIRTUAL=TRUE
then
    IS_VIRTUAL=FALSE
fi

# According to:
#   <https://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux>
case "$(uname -s)" in
    Darwin*)
        SYSTEM=macOS
        ;;
    Linux*)
        SYSTEM=Linux
        ;;
    CYGWIN*)
        SYSTEM=Cygwin
        ;;
    MINGW*)
        SYSTEM=MinGW
        ;;
    *)
        SYSTEM=Unknown
esac

# if [ "${SYSTEM}" = "Linux" ]; then
#     DISTRIBUTION
# fi



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
apt-get install --assume-yes --no-install-recommends ${PACKAGES}



# ------------------------------
# Make the account can use <sudo> command.
cat << EOF > /etc/sudoers.d/bruce
${ACCOUNT}   ALL = (ALL:ALL) ALL
EOF
chmod =0400 /etc/sudoers.d/bruce

# ------------------------------
# Change user shell
chsh --shell /bin/zsh ${ACCOUNT}

# Make an empty .zshrc file to prevent zsh-newuser-install running.
touch /home/${ACCOUNT}/.zshrc
chown ${ACCOUNT}:${ACCOUNT} /home/${ACCOUNT}/.zshrc



# ==============================
# Exit.
# ==============================

# Unset variables.
unset DEFAULT_ACCOUNT
unset PACKAGES
unset VERSION
unset ACCOUNT
unset IS_VIRTUAL
unset SYSTEM
unset DISTRIBUTION


exit 0
