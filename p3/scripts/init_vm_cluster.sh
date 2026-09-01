#!/usr/bin/env sh
set -eu

if [ "$(id -u)" -ne 0 ]; then
      echo "Please run me as sudo"
      exit 1
fi

# Docker repo
install -m 0755 -d /etc/apt/keyrings
wget -q -O /etc/apt/keyrings/docker.asc https://download.docker.com/linux/ubuntu/gpg
chmod a+r /etc/apt/keyrings/docker.asc
cat > /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# Kubectl repo
wget -q -O /tmp/k8s.key https://pkgs.k8s.io/core:/stable:/v1.36/deb/Release.key
gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes.gpg /tmp/k8s.key
rm -f /tmp/k8s.key
cat > /etc/apt/sources.list.d/kubernetes.sources <<'EOF'
Types: deb
URIs: https://pkgs.k8s.io/core:/stable:/v1.36/deb/
Suites: /
Signed-By: /etc/apt/keyrings/kubernetes.gpg
EOF

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin \
                        docker-compose-plugin kubectl
systemctl enable --now docker
usermod -aG docker vagrant

# k3d
wget -q -O /tmp/k3d.sh https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh
TAG=v5.9.0 bash /tmp/k3d.sh
rm -f /tmp/k3d.sh

echo "Run newgrp docker please"
