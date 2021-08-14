#!/usr/bin/env bash

VERSION="12"

# Update package list and install gnupg2.
sudo apt-get update
sudo apt-get install -y gnupg2

# Add the PostgreSQL repository into apt config.
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Import PostgreSQL repository signed key.
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update package list.
sudo apt-get update

# Install.
sudo apt-get install -y postgresql-${VERSION}

# Config to recieve remote connection.
sudo sed -i -e "59s/^#//" -e "59s/'localhost'/'*'\t/" \
    /etc/postgresql/${VERSION}/main/postgresql.conf
sudo sed -i -e "97i host\tall\t\tbruce\t\t0.0.0.0\/0\t\tmd5" \
    /etc/postgresql/${VERSION}/main/pg_hba.conf

# Restart
sudo service postgresql Restart

# Install UFW
sudo apt-get install -y ufw

# Open port 5432
sudo ufw allow 5432

# END

