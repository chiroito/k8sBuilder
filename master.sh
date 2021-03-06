#!/bin/bash

# Firewall
firewall-cmd --add-port=6443/tcp
firewall-cmd --add-port=6443/tcp --permanent
systemctl restart firewalld

# k8s
kubeadm-setup.sh up

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/admin.conf
chown $(id -u):$(id -g) $HOME/.kube/admin.conf
export KUBECONFIG=$HOME/.kube/admin.conf
echo 'export KUBECONFIG=$HOME/.kube/admin.conf' >> $HOME/.bashrc

# sharing for user
cp $KUBECONFIG /mnt/hostshared/kubectl.conf

