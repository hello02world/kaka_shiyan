### 1 cd /opt
>
### 2 tar -zxvf docker-*.tgz
>
### 3 cd docker; cp * /usr/local/bin
>
### 4 wget https://raw.githubusercontent.com/humstarman/bigdata-02/master/docker.service
### cp docker.service /etc/systemd/system
>
### 5 systemctl daemon-reload
### systemctl enable docker
### systemctl restart docker
>
### 6 docker info
