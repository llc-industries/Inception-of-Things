#!/usr/bin/env sh

dnf upgrade -y
dnf install -y zsh curl
dnf autoremove -y

# Disable firewalld so VMs can communicate
systemctl disable --now firewalld

# Disable SSH Password
sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

while [ ! -f /vagrant/node-token ]; do
  sleep 2
done

# Install K3s
TOKEN=$(cat /vagrant/node-token)
export K3S_URL="https://192.168.56.110:6443"
export K3S_TOKEN="${TOKEN}"
export INSTALL_K3S_EXEC="agent --node-ip=192.168.56.111"

curl -sfL https://get.k3s.io | sh -

# Configure ZSH
usermod -s /bin/zsh vagrant
touch /home/vagrant/.zshrc
chown vagrant:vagrant /home/vagrant/.zshrc
