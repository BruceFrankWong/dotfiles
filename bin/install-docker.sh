#!/usr/bin/env bash

# This BASH script is used to:
#
#     install Docker and docker-compose, then add mirror repositories.
#
# The connection to docker.com or GitHub.com is very slow from China,
# so we have to use some tricky method to make curl retry unlimited times.

set -u

VERSION=1.25.3


# ------------------------------
# Install Docker
while true; do
    sh -c "$(curl -fsSL https://get.docker.com)" && break
done

# ------------------------------
# Install docker-compose
while true; do
    curl -C --connect-timeout 10 --max-time 20000 \
        -L "https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose && \
    break
done
chmod +x /usr/local/bin/docker-compose

# ------------------------------
# Add mirror sites.
cat << EOF > /etc/docker/daemon.json
{
    "registry-mirrors":
        [
            "https://registry.docker-cn.com",
            "https://docker.mirrors.ustc.edu.cn",
            "http://hub-mirror.c.163.com"
        ]
}
EOF


# ------------------------------
# Restart docker.
systemctl daemon-reload
systemctl restart docker.service



unset VERSION

exit 0
