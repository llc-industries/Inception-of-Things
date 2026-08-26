#!/usr/bin/env sh
set -eu

# Base packages
apt-get update -y
apt-get install -y zsh qemu-system-x86 qemu-utils libvirt-daemon-system libvirt-clients \
                   virt-manager git curl gnupg wget rsync gcc make pkg-config libvirt-dev \
                   ruby-dev libxml2-dev libxslt1-dev zlib1g-dev

# Vagrant repo setup
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Vagrant install + init
apt-get update -y && apt-get install -y vagrant
usermod -aG libvirt,kvm,sudo vagrant
sudo -iu vagrant vagrant plugin install vagrant-libvirt

# VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor --yes -o /usr/share/keyrings/microsoft.gpg
cat > /etc/apt-get/sources.list.d/vscode.sources <<'EOF'
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF

apt-get update -y
apt-get install -y code

# Configure ZSH
usermod -s /bin/zsh vagrant
touch /home/vagrant/.zshrc
chown vagrant:vagrant /home/vagrant/.zshrc
