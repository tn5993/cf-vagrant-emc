# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hashicorp/precise32"

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe 'cloudfoundry::vagrant-provision-start'

    chef.add_recipe 'apt::default'
    chef.add_recipe 'git'
    chef.add_recipe 'chef-golang'
    chef.add_recipe 'ruby_build'
    chef.add_recipe 'rbenv::user'
    chef.add_recipe 'java::openjdk'
    chef.add_recipe 'sqlite'
    chef.add_recipe 'mysql::server'
    chef.add_recipe 'postgresql::server'

    chef.add_recipe 'rbenv-alias'
    chef.add_recipe 'rbenv-sudo'
    chef.add_recipe 'cloudfoundry::cloud_controller'
    chef.add_recipe 'cloudfoundry::warden'
    chef.add_recipe 'cloudfoundry::dea'
    chef.add_recipe 'cloudfoundry::uaa'
    chef.add_recipe 'cloudfoundry::cf_bootstrap'

    chef.add_recipe 'cloudfoundry::vagrant-provision-end'

    chef.json = {
      'rbenv' => {
        'user_installs' => [ {
          'user' => 'vagrant',
          'global' => '1.9.3-p392',
          'rubies' => [ '1.9.3-p392' ],
          'gems' => {
            '1.9.3-p392' => [
              { 'name' => 'bundler' }
            ]
          },
        } ]
      },
      'rbenv-alias' => {
        'user_rubies' => [ {
          'user' => 'vagrant',
          'installed' => '1.9.3-p392',
          'alias' => '1.9.3'
        } ]
      },
      'mysql' => {
        'server_root_password' => '',
        'server_repl_password' => '',
        'server_debian_password' => ''
      },
      'postgresql' => {
        'password' => {
          'postgres' => ''
        }
      }
    }
  end
end