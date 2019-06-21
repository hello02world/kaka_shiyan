#!/bin/bash

# 0 prepare
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# 0.1 configure docker
mkdir -p /etc/docker
cat > /etc/docker/daemon.json << EOF
{
  "data-root": "/var/lib/docker",
  "registry-mirrors" : [
    "url-1"
  ],
  "insecure-registries" : [
    "192.168.0.0/16",
    "172.0.0.0/8",
    "10.0.0.0/8"
  ],
  "debug" : true,
  "experimental" : true,
  "max-concurrent-downloads" : 10
}
EOF

# 1 find docker.tgz
TGZ=$(find /opt -type f -name "*.tgz" | grep docker)
echo ${TGZ}

# 2 tar
tar -zxf ${TGZ} -C /opt || echo error

# 3 cp
yes | cp /opt/docker/* /usr/local/bin

# 4 make docker.service
SVC=/etc/systemd/system/docker.service
cat > ${SVC} << EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target

[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
ExecStart=/usr/local/bin/dockerd
ExecReload=/bin/kill -s HUP $MAINPID
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
# restart the docker process if it exits prematurely
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
EOF

# 5 start docker service
systemctl daemon-reload
systemctl enable docker 
systemctl restart docker 

# check
docker info
systemctl status docker 

