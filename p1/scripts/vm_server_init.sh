#!/usr/bin/env sh

# Disable SSH Password
sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
service sshd restart

# Handle VM Packages
sudo dnf upgrade -y && sudo dnf install -y zsh docker curl && sudo dnf autoremove -y

# Install k3s control plane
curl -fL https://get.k3s.io | sh -s - server --token <token> --disable-etcd --server https://<etcd-only-node>:6443

