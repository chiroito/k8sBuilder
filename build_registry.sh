#!/bin/bash

firewall-cmd --add-port=5000/tcp
firewall-cmd --add-port=5000/tcp --permanent
systemctl restart firewalld

docker pull registry
docker run -d -p 5000:5000 -v /mnt/hostshared/registry:/var/lib/registry registry
