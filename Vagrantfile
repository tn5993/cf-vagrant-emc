# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hashicorp/precise64"
  config.vm.hostname = "cf"
  config.vm.network :private_network, ip: "192.168.12.34"
  config.vm.network :forwarded_port, guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 4222, host: 4222
  config.vm.provision :shell, path: "bootstrap.sh"
  config.berkshelf.enabled = true

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 1
  end

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe 'cloudfoundry::vagrant-provision-start'

    chef.add_recipe 'apt'
    chef.add_recipe 'java'
    chef.add_recipe 'mysql::server'
    chef.add_recipe 'mysql::client'
    chef.add_recipe 'cloudfoundry::warden'
    chef.add_recipe 'cloudfoundry::dea'
    chef.json = {
      :java => {
        :install_flavor => "oracle",
        :jdk_version => "7",
        :oracle => {
          "accept_oracle_download_terms" => true
        }
      },
      :mysql => {
         :server_root_password => "password",
         :server_repl_password => "password",
         :server_debian_password => "password"
      }
    }

  
  end
end
