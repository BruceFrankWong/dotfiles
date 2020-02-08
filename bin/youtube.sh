#!/usr/bin/env bash

# ==============================
# 
# dotfiles
#     - youtube.sh
#
# Author: Bruce Frank Wong
# Created: 2020-02-08 13:51:04
#
# ==============================


# This BASH script is used to:
#     Download videos via youtube-dl, try unlimited times until success.


if [ $# -lt 2 ]; then
    echo "Usage: $0 URL"
    exit 1
fi

if [ ! command -v youtube-dl >/dev/null 2>&1 ]; then
    sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
    sudo chmod a+rx /usr/local/bin/youtube-dl
fi

while true; do
    youtube-dl --ignore-errors --format best --output "%(title)s.%(ext)s" $@ && break
done


exit 0
