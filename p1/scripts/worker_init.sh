#!/usr/bin/env sh
set -eu

apt-get update -y
apt-get install -y curl zsh

echo "PasswordAuthentication no" > /etc/ssh/sshd_config.d/99-no-password.conf
systemctl reload ssh

# Wait for the K3s API server
tries=0
until curl -sk -o /dev/null --max-time 2 https://192.168.56.110:6443/; do
	tries=$((tries + 1))
	[ "$tries" -lt 60 ] || exit 1
	sleep 2
done

# Install K3s
export K3S_URL="https://192.168.56.110:6443"
export INSTALL_K3S_EXEC="agent --node-ip=192.168.56.111"
export K3S_TOKEN="token"
curl -sfL https://get.k3s.io | sh -

usermod -s /bin/zsh vagrant
touch /home/vagrant/.zshrc
chown vagrant:vagrant /home/vagrant/.zshrc
