#!/usr/bin/env sh

# Disable SSH Password
sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
service sshd restart
