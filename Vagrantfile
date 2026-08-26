# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "joaobrlt/ubuntu-desktop-24.04"
  config.vm.define "IoT"
  config.vm.hostname = "IoT"

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provision "copy-repo", type: "file",
    source: ".",
    destination: "/home/vagrant/Inception-of-Things"

  config.vm.provider "libvirt" do |lv|
    lv.default_prefix = ""
    lv.memory = 8192
    lv.cpus = 4
    lv.cpu_mode = "host-passthrough"
    lv.graphics_type = "spice"
    lv.video_type = "virtio"
    lv.channel type: "spicevmc", target_name: "com.redhat.spice.0",
               target_type: "virtio"
  end

  config.vm.provision "shell", path: "master_init.sh"
end
