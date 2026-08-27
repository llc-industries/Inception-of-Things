default: up

up:
	vagrant up --provider=libvirt

down:
	vagrant halt

repo_copy:
	vagrant provision --provision-with=copy-repo

gui:
	virt-viewer -c qemu:///system -f IoT --attach &

clean:
	vagrant destroy

fclean:
	vagrant destroy -f

fix:
	sudo iptables -P FORWARD ACCEPT

re: fclean up

.PHONY: default up down repo_copy gui clean fclean re
