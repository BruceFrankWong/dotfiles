#!/usr/bin/env bash

# This BASH script is used to:
#     Generate an ssh key without passphrase prompt.



if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
    chmod 700 ~/.ssh
elif [
fi

ssh-keygen 
