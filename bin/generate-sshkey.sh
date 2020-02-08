#!/usr/bin/env bash

# ==============================
# 
# dotfiles
#     - generate-sshkey.sh
#
# Author: Bruce Frank Wong
# Created: 2020-02-08 13:51:04
#
# ==============================

# This BASH script is used to:
#     Generate an ssh key without passphrase prompt.



if [ $# -eq 0 ]; then
    KEY_FILE=~/.ssh/id_key
else
    KEY_FILE=~/.ssh/${1}
fi

if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
    chmod 700 ~/.ssh
fi

if [ "$(ls -la ~ | grep '.ssh' | cut -d ' ' -f1)" != 'drwx------' ]; then
    chmod 700 ~/.ssh
fi

ssh-keygen -q -b 2048 -t rsa -N "" -f ${KEY_FILE}

exit 0
