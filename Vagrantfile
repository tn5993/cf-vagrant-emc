# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hashicorp/precise32"
  config.vm.hostname = "cf"
  config.vm.network :private_network, ip: "192.168.12.34"
  config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=755", "fmode=755"]

  config.berkshelf.enabled = true
  config.vm.provision :chef_solo do |chef|
    

  end
end