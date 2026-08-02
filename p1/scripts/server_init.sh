#!/usr/bin/env sh

dnf upgrade -y
dnf install -y zsh curl
dnf autoremove -y

# Disable firewalld so VMs can communicate
systemctl disable --now firewalld

# Disable SSH Password
sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd


# Install K3s
export INSTALL_K3S_EXEC="server --node-ip=192.168.56.110 --flannel-iface=eth1"
export K3S_KUBECONFIG_MODE="644"
curl -sfL https://get.k3s.io | sh -

# Wait K3s
systemctl enable --now k3s
while [ ! -f /var/lib/rancher/k3s/server/node-token ]; do
	sleep 2
done

# Put the token in shared folder
cp /var/lib/rancher/k3s/server/node-token /vagrant/node-token

# Configure ZSH
usermod -s /bin/zsh vagrant
echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' > /home/vagrant/.zshrc
echo 'alias k=kubectl' >> /home/vagrant/.zshrc
chown vagrant:vagrant /home/vagrant/.zshrc
