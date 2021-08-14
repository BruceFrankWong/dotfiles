#!/usr/bin/env bash

# Example:
# $ ./bootstrap.sh


# --------------------------------------------------
# Check whether the current user is root.
# --------------------------------------------------
if [ ! $(id -u) -eq 0 ]; then
    echo "Only ROOT can add a user to the system."
    exit 1
fi


# --------------------------------------------------
# Update package list and install basic packages.
# --------------------------------------------------
apt-get update
apt-get install -y \
    sudo \
    zsh \
    wget \
    git


# --------------------------------------------------
# Add user <bruce>.
# --------------------------------------------------

# Get the username.
read -p "Enter the username: " USERNAME

# Check whether the user is existed.
egrep "^${USERNAME}" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
    echo "User '${USERNAME}' is already existed!"
    exit 2
fi

# Get the password.
read -p "Enter the password: " PASSWORD

# Do adding user.
ENCRPYTED=$(perl -e 'print(${PASSWORD}, "password")' ${PASSWORD})
useradd -m -p ${ENCRPYTED} ${USERNAME}
if [ $? -eq 0 ]; then
    echo "User ${USERNAME} has been added to system!"
else
    echo "Failed to add user!"
fi

# Modify sudo.
touch /etc/sudoers.d/${USERNAME}

cat <<EOF > /etc/sudoers.d/${NEW_USER}
${NEW_USER}\tALL-(ALL"ALL) ALL
EOF

chown root:root /etc/sudoers.d/${USERNAME}
chmod 440 /etc/sudoers.d/${USERNAME}

# END

