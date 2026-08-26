default: up

up:
	vagrant up --provider=libvirt

down:
	vagrant halt

repo_copy:
	vagrant provision --provision-with=copy_repo

gui:
	virt-viewer -c qemu:///system IoT --attach &

clean:
	vagrant destroy

fclean:
	vagrant destroy -f

re: fclean up

.PHONY: up down repo_copy gui clean fclean
