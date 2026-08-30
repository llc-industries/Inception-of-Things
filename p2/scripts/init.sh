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
curl -sfL https://get.k3s.io | sh -

# Wait for readiness and apply manifests
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
until kubectl get nodes -o name 2>/dev/null | grep -q node/; do sleep 2; done
kubectl wait --for=condition=Ready node --all --timeout=120s
kubectl apply -f /home/vagrant/manifests

# Resolve appX.com
echo "192.168.56.110 app1.com app2.com app3.com" >> /etc/hosts

# Configure ZSH
usermod -s /bin/zsh vagrant
cat > /home/vagrant/.zshrc <<'EOF'
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
alias k=kubectl
EOF
chown vagrant:vagrant /home/vagrant/.zshrc
