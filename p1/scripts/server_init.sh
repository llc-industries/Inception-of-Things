#!/usr/bin/env sh
set -eu

apt-get update -y
apt-get install -y curl zsh

# Disable SSH Password
echo "PasswordAuthentication no" > /etc/ssh/sshd_config.d/99-no-password.conf
systemctl reload ssh

# Install K3s
export INSTALL_K3S_EXEC="server --node-ip=192.168.56.110"
export K3S_KUBECONFIG_MODE="644"
export K3S_TOKEN="token"
curl -sfL https://get.k3s.io | sh -

# Configure ZSH
usermod -s /bin/zsh vagrant
cat > /home/vagrant/.zshrc <<'EOF'
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
alias k=kubectl
EOF
chown vagrant:vagrant /home/vagrant/.zshrc
