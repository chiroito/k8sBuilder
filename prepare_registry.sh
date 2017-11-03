#!/bin/bash

local_registry=$1

docker pull container-registry.oracle.com/kubernetes/k8s-dns-sidecar-amd64:1.14.4
docker pull container-registry.oracle.com/kubernetes/k8s-dns-kube-dns-amd64:1.14.4
docker pull container-registry.oracle.com/kubernetes/k8s-dns-dnsmasq-nanny-amd64:1.14.4
docker pull container-registry.oracle.com/kubernetes/flannel:v0.7.1-amd64          
docker pull container-registry.oracle.com/kubernetes/kube-controller-manager-amd64:v1.7.4
docker pull container-registry.oracle.com/kubernetes/kube-scheduler-amd64:v1.7.4
docker pull container-registry.oracle.com/kubernetes/kube-apiserver-amd64:v1.7.4
docker pull container-registry.oracle.com/kubernetes/kube-proxy-amd64:v1.7.4
docker pull container-registry.oracle.com/kubernetes/etcd-amd64:3.0.17       
docker pull container-registry.oracle.com/kubernetes/pause-amd64:3.0

docker tag container-registry.oracle.com/kubernetes/k8s-dns-sidecar-amd64:1.14.4 ${local_registry}/kubernetes/k8s-dns-sidecar-amd64:1.14.4
docker tag container-registry.oracle.com/kubernetes/k8s-dns-kube-dns-amd64:1.14.4 ${local_registry}/kubernetes/k8s-dns-kube-dns-amd64:1.14.4
docker tag container-registry.oracle.com/kubernetes/k8s-dns-dnsmasq-nanny-amd64:1.14.4 ${local_registry}/kubernetes/k8s-dns-dnsmasq-nanny-amd64:1.14.4
docker tag container-registry.oracle.com/kubernetes/flannel:v0.7.1-amd64 ${local_registry}/kubernetes/flannel:v0.7.1-amd64
docker tag container-registry.oracle.com/kubernetes/kube-controller-manager-amd64:v1.7.4 ${local_registry}/kubernetes/kube-controller-manager-amd64:v1.7.4
docker tag container-registry.oracle.com/kubernetes/kube-scheduler-amd64:v1.7.4 ${local_registry}/kubernetes/kube-scheduler-amd64:v1.7.4
docker tag container-registry.oracle.com/kubernetes/kube-apiserver-amd64:v1.7.4 ${local_registry}/kubernetes/kube-apiserver-amd64:v1.7.4
docker tag container-registry.oracle.com/kubernetes/kube-proxy-amd64:v1.7.4 ${local_registry}/kubernetes/kube-proxy-amd64:v1.7.4
docker tag container-registry.oracle.com/kubernetes/etcd-amd64:3.0.17 ${local_registry}/kubernetes/etcd-amd64:3.0.17
docker tag container-registry.oracle.com/kubernetes/pause-amd64:3.0 ${local_registry}/kubernetes/pause-amd64:3.0

docker push ${local_registry}/kubernetes/k8s-dns-sidecar-amd64:1.14.4
docker push ${local_registry}/kubernetes/k8s-dns-kube-dns-amd64:1.14.4
docker push ${local_registry}/kubernetes/k8s-dns-dnsmasq-nanny-amd64:1.14.4
docker push ${local_registry}/kubernetes/flannel:v0.7.1-amd64
docker push ${local_registry}/kubernetes/kube-controller-manager-amd64:v1.7.4
docker push ${local_registry}/kubernetes/kube-scheduler-amd64:v1.7.4
docker push ${local_registry}/kubernetes/kube-apiserver-amd64:v1.7.4
docker push ${local_registry}/kubernetes/kube-proxy-amd64:v1.7.4
docker push ${local_registry}/kubernetes/etcd-amd64:3.0.17
docker push ${local_registry}/kubernetes/pause-amd64:3.0

