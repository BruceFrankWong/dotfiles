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
    git \
    xclip \
    python-pip \
    python3-pip \
    virtualenv \
    virtuanenvwrapper


# --------------------------------------------------
# Add new user.
# --------------------------------------------------

# Get the username.
read -p "Enter the username: " USERNAME

# Check whether the user is existed.
egrep "^${USERNAME}" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
    echo "User '${USERNAME}' is already existed!"
    exit 2
fi

# Do adding user.
useradd -m -s /bin/zsh ${USERNAME}
if [ $? -eq 0 ]; then
    echo "User ${USERNAME} has been added to system!"
else
    echo "Failed to add user!"
fi

# Set the password for new user
passwd ${USERNAME}


# --------------------------------------------------
# Config user enviroment.
# --------------------------------------------------
# <sudoer> file.
touch /etc/sudoers.d/${USERNAME}

cat <<EOF > /etc/sudoers.d/${USERNAME}
${USERNAME} ALL=(ALL:ALL) ALL
EOF

chown root:root /etc/sudoers.d/${USERNAME}
chmod 440 /etc/sudoers.d/${USERNAME}

# <.zshrc> file.
touch /home/${USERNAME}/.zshrc
chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.zshrc
chmod 644 /home/${USERNAME}/.zshrc


# END
