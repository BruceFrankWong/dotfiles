#!/usr/bin/env bash

VERSION="3.8.11"


VER=$(echo ${VERSION} | awk 'BEGIN{FS="."} {print $1"."$2}')


# --------------------------------------------------
# Update the package and install the requirements.
# --------------------------------------------------
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    checkinstall \
    tk-dev \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libsqlite3-dev \
    libreadline-dev \
    libffi-dev \
    libbz2-dev \
    libpcre3 \
    libpcre3-dev


# --------------------------------------------------
# Create the temporary directory.
# --------------------------------------------------
if [ ! -d ${HOME}/temp ]; then
    mkdir ${HOME}/temp
fi


# --------------------------------------------------
# Download the source code.
# --------------------------------------------------
cd ${HOME}/temp
wget https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz
tar -xvf Python-${VERSION}.tgz


# --------------------------------------------------
# Compile the source code and install.
# --------------------------------------------------
cd Python-${VERSION}
./configure --enable-optimizations
sudo make
sudo make altinstall


# --------------------------------------------------
# Check whether Python 3.x.y install succeed.
# --------------------------------------------------
if [ ! -x /usr/local/bin/python${VER} ]; then
    echo "ERROR! Python ${VERSION} is not install correctly."
    exit 1
fi


# --------------------------------------------------
# Make clean.
# --------------------------------------------------
rm -rf ${HOME}/temp/Python-${VERSION}
rm ${HOME}/temp/Python-${VERSION}.tgz


# END
