# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hashicorp/precise32"
  config.vm.hostname = "cf"
  config.vm.network :private_network, ip: "192.168.12.34"
  config.vm.network :forwarded_port, guest: 8080, host: 8080
  
  config.berkshelf.enabled = true
  config.vm.provision :chef_solo do |chef|
    chef.add_recipe 'cloudfoundry::vagrant-provision-start'

    chef.add_recipe 'apt'
    chef.add_recipe 'java'
    chef.add_recipe 'ruby_build'
    chef.add_recipe 'rbenv::user'
    chef.add_recipe 'rbenv::vagrant'
    chef.add_recipe 'git'
    chef.add_recipe 'sqlite'
    chef.add_recipe 'mysql_config'
    chef.add_recipe 'postgresql::server'
    chef.add_recipe 'golang'

    chef.add_recipe 'cloudfoundry::warden'
    chef.add_recipe 'cloudfoundry::dea'
        
    chef.json = {
      :rbenv => {
        :user_installs => [{
          :user => 'vagrant',
          :rubies => ["2.1.5"],
          :global => "2.1.5",
          :gems => {
            "2.1.5" => [
              { :name => "bundler" }
            ]
          }
        }]
      },
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
      },
      :postgresql => {
         :password => {
            :postgres => "password"
         }
      }
    }
  end
end
