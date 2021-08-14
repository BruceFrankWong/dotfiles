
#!/usr/bin/env bash

# Example:
# $ ./bootstrap.sh


# Check whether the current user is root.
if [ ! $(id -u) -eq 0 ]; then
    echo "Only ROOT can add a user to the system."
    exit 2
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
read -p "Enter username : " USERNAME
read -s -p "Enter password : " PASSWORD

# Check whether the user is existed.
id ${USERNAME} >& /dev/null && echo "User '${USERNAME}' is already existed!" && exit 2


# Do adding user.
ENCRPYTED=$(perl -e 'print(${PASSWORD}, "password")' ${PASSWORD})
useradd -m -p ${ENCRPYTED} ${USERNAME}
[ $? -eq 0 ] && echo "User ${USERNAME} has been added to system!" || echo "Failed to add user!"

# Modify sudo.
touch /etc/sudoers.d/${USERNAME}

cat <<EOF > /etc/sudoers.d/${NEW_USER}
${NEW_USER}\tALL-(ALL"ALL) ALL
EOF

chown root:root /etc/sudoers.d/${USERNAME}
chmod 440 /etc/sudoers.d/${USERNAME}

# END

