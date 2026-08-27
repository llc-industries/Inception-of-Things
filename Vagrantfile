# -*- mode: ruby -*-
# vi: set ft=ruby :

# ────── Configuration ─────────
BOX_IMAGE     = "joaobrlt/ubuntu-desktop-24.04"
VM_CPUS       = 4
VM_MEMORY     = 4096
VM_NAME       = "IoT"
# ──────────────────────────────

Vagrant.configure("2") do |config|
  config.vm.box = BOX_IMAGE
  config.vm.define VM_NAME
  config.vm.hostname = VM_NAME

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provision "copy-repo", type: "file",
    source: ".",
    destination: "/home/vagrant/Inception-of-Things"

  config.vm.provider "libvirt" do |lv|
    lv.default_prefix = ""
    lv.memory = VM_MEMORY
    lv.cpus = VM_CPUS
    lv.cpu_mode = "host-passthrough"
    lv.graphics_type = "spice"
    lv.video_type = "virtio"
    lv.channel type: "spicevmc", target_name: "com.redhat.spice.0",
               target_type: "virtio"
  end

  config.vm.provision "shell", path: "scripts/master_init.sh"
end
