#!/usr/bin/env bash

# ==============================
# 
# dotfiles
#     - get_env.sh
#
# Author: Bruce Frank Wong
# Created: 2020-02-08 00:19:34
#
# ==============================

# This BASH script is used to：
#     Get the environment of the current system, including:
#         - MACHINE, virtual or physical;
#         - PLATFORM, virtual environment (see )



# According to:
#   <https://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux>

case "$(uname -s)" in
    Darwin*)
        SYSTEM=macos
        DISTRIBUTION=$(sw_vers -productName)
        RELEASE=$(sw_vers -productVersion)

        # According to:
        #   <https://stackoverflow.com/questions/28529633/how-to-detect-if-mac-os-x-is-being-run-inside-a-virtual-machine>
        if [ -n "$(ioreg -l | grep 'Vendor Name' | grep -E 'Oracle|VirtualBox|Parallels|VMware')" ]; then
            MACHINE=virtual
            PLATFORM=none
        else
            MACHINE=physical
            PLATFORM=none
        fi
        ;;

    Linux*)
        SYSTEM=linux
        # Alpine has no lsb_release by default.
        # THIS_DISTRIBUTION=$(lsb_release -a | grep 'Distributor ID' | cut -f2)
        # THIS_VERSION=$(lsb_release -a | grep 'Release' | cut -f2)
        THIS_DISTRIBUTION=$(cat /etc/*-release | grep '^ID=' | cut -d '=' -f2)
        THIS_VERSION=$(cat /etc/*-release | grep '^VERSION_ID=' | cut -d '=' -f2 | cut -d '"' -f2)

        # According to:
        #   <https://www.infoq.cn/article/536L*XPRudOwCkiTDgM4>
        if [ command -v systemd-detect-virt >/dev/null 2>&1 ]; then
            PLATFORM=$(systemd-detect-virt)
            if [ "${PLATFORM}" != "none" ]; then
                MACHINE=virtual
            then
                MACHINE=physical
            fi
        else
            PLATFORM=unknown
            MACHINE=unknown
        fi
        ;;

    *)
        SYSTEM=unknown
        DISTRIBUTION=unknown
        RELEASE=unknown
        PLATFORM=unknown
        MACHINE=unknown
esac



export THIS_MACHINE=${MACHINE}
export THIS_PLATFORM=${PLATFORM}
export THIS_SYSTEM=${SYSTEM}
export THIS_DISTRIBUTION=${DISTRIBUTION}
export THIS_RELEASE=${RELEASE}



unset MACHINE
unset PLATFORM
unset SYSTEM
unset DISTRIBUTION
unset RELEASE



exit 0
