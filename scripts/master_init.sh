#!/usr/bin/env sh
set -eu

# Vagrant repo setup
wget -qO- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# VS Code repo setup
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor --yes -o /usr/share/keyrings/microsoft.gpg
cat > /etc/apt/sources.list.d/vscode.sources <<'EOF'
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF

# Base packages
apt-get update -y
apt-get install -y zsh qemu-system-x86 qemu-utils libvirt-daemon-system libvirt-clients \
                   virt-manager git curl rsync gcc make pkg-config libvirt-dev \
                   ruby-dev libxml2-dev libxslt1-dev zlib1g-dev vagrant code

# k9s install
wget -q -O /tmp/k9s.deb https://github.com/derailed/k9s/releases/download/v0.51.0/k9s_linux_amd64.deb
apt-get install -y /tmp/k9s.deb
rm -f /tmp/k9s.deb

# Vagrant init
usermod -aG libvirt,kvm,sudo vagrant
sudo -iu vagrant vagrant plugin install vagrant-libvirt

# Configure ZSH
usermod -s /bin/zsh vagrant
cat > .zshrc << 'EOF'
export PS1='%n@%m %~$ '
EOF
chown vagrant:vagrant /home/vagrant/.zshrc
