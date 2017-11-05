#!/usr/bin/env bash

master_host=$1

kubeadm-setup.sh join --token ${TOKEN} ${master_host}:6443
export KUBECONFIG=/etc/kubernetes/kubelet.conf
echo 'export KUBECONFIG=/etc/kubernetes/kubelet.conf' >> $HOME/.bashrc
