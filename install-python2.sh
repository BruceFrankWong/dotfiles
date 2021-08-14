#!/usr/bin/env bash

# Compile and nstall Python 2.7.x from source, and install pip.

VERSION="2.7.18"

# Update the package and install the requirements.
sudo apt-get update && sudo apt-get install -y \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libsqlite3-dev \
    libreadline-dev \
    libffi-dev \
    libbz2-dev

# Create the temporary directory.
if [ ! -d ${HOME}/temp ]; then
    mkdir ${HOME}/temp
fi

# Download the source code.
cd ${HOME}/temp
wget https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz
tar -xvf Python-${VERSION}.tgz

# Compile the source code and install.
cd Python-${VERSION}
./configure --enable-optimizations
sudo make
sudo make altinstall

# Check whether Python 2.7.x install succeed.
if [ ! -x /usr/local/bin/python2.7 ]; then
    echo "ERROR! Python ${VERSION} is not install correctly."
    exit 1
fi

# Download pip
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o ${HOME}/temp/get-pip.py
/usr/local/bin/python2.7 ${HOME}/temp/get-pip.py

# Check whether Python 2.7.x install succeed.
# if [ ! -x /usr/local/bin/pip2.7 ]; then
#     echo "ERROR! Python ${VERSION} is not install correctly."
#     exit 1
# fi

# Make clean.
sudo rm -rf ${HOME}/temp/Python-${VERSION}
rm ${HOME}/temp/Python-${VERSION}.tgz
rm ${HOME}/temp/get-pip.py

# END

