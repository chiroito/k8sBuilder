#!/usr/bin/env bash

registry=$1

export KUBE_REPO_PREFIX=${registry}/kubernetes
echo "export KUBE_REPO_PREFIX=${registry}/kubernetes" >> $HOME/.bashrc