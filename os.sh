#!/bin/bash
# SELinux
/usr/sbin/setenforce 0
sed s/SELINUX=enforcing/SELINUX=permissive/g /etc/selinux/config > /etc/selinux/config

# Network
modprobe br_netfilter
echo "br_netfilter" > /etc/modules-load.d/br_netfilter.conf
cat << EOL > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOL
/sbin/sysctl -p /etc/sysctl.d/k8s.conf

# Firewall
iptables -P FORWARD ACCEPT
systemctl start firewalld
firewall-cmd --add-masquerade
firewall-cmd --add-masquerade --permanent
firewall-cmd --add-port=10250/tcp
firewall-cmd --add-port=10250/tcp --permanent
firewall-cmd --add-port=8472/udp
firewall-cmd --add-port=8472/udp --permanent
systemctl restart firewalld

yum install -y --enablerepo=ol7_addons,ol7_addons --disablerepo=ol7_UEKR4,ol7_developer,ol7_developer_EPEL  docker-engine kubeadm

# Docker engine
systemctl enable docker
systemctl start docker