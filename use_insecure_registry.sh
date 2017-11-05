#!/usr/bin/env bash

registry=$1

 cat << EOF > /etc/docker/daemon.json
{
  "insecure-registries" : ["${registry}"]
}
EOF
 systemctl daemon-reload
systemctl restart docker