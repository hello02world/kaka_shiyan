#!/bin/bash

# install ssh
apt-get install -y ssh

# configure sshd
CONFIG=/etc/ssh/sshd_config
sed -i s?"prohibit-password"?"yes"?g ${CONFIG}

# restart ssh service
systemctl restart sshd
systemctl status sshd
