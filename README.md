# Cloud Foundry on Vagrant
================

## Background
================



## Prerequisites
================
* [Vagrant:]()
* [Chef sdk:]()
* Install vagrant plugins
- $ vagrant plugin install vagrant-berkshelf
- $ vagrant plugin install vagrant-omnibus

## Run Cloud Foundry on Vagrant (Implementing)
================
1. Clone this project
```shell
$ git clone https://github.com/tn5993/cf-vagrant-emc.git
$ cd cf-vagrant-emc
```

2. Bring up the VM
```shell
$ vagrant up
```

3. Login to the VM and config it using Ruby Rake
```shell
$ bundle exec rake cf:init
```

4. Done

## Behind the scene
================
The flow of the program is as below
* Vagrant Provisioning: 
At first, when we call `vagrant up`, it will use the `ubuntu\trusty64` box and do provisioning through bootstrap.sh and chef-solo configuration. You can look at Vagrantfile for more information. If you are not familiar with chef sdk, you can learn more about chef at https://learn.chef.io/. Basically, chef is a DSL(Domain Specific Language) that allows us to do package installation. Chef's instruction is stored inside `recipes`. Additionally, we can accummulate those recipes together and put it inside a `cookbook`. For this project, the Berkfile file store all the reference to cookbooks. For example, inside Berkfile, we see that

```shell
source "https://supermarket.chef.io"

cookbook 'java'
cookbook 'cloudfoundry', path: './cookbooks/cloudfoundry'
```

This means that the default source for cookbook is https://supermarket.chef.io. If you want to refer your local cookbook, you can override its path. Berkfile will be read through vagrant berkshelf plugin and refered by chef-solo in Vagran tfile

Note: some provisioning is achieved through bootstrap.sh.

* Cloud Foundry installation
Basically, cloud foundry has the following components. They are:
- [CloudController](https://github.com/cloudfoundry/cloud_controller_ng.git)
- [GoRouter](https://github.com/cloudfoundry/gorouter.git)
- [HealthManager](https://github.com/cloudfoundry/hm9000.git)
- [DEA](https://github.com/cloudfoundry/dea_ng.git)
- [Warden](https://github.com/cloudfoundry/warden.git)
- [UAA](https://github.com/cloudfoundry/uaa.git)
- [Loggregator](https://github.com/cloudfoundry/loggregator.git)

To read more about cloud foundry compnonents. Please refer to https://docs.cloudfoundry.org/concepts/architecture/

In this project, the configuration and installation for cloud foundry
components are all configure in the Rakefile at the root of this
project. This Rakefile is in charge of setting up each components and
their dependencies. Later on, it will copy the run commands for each
components under /etc/init/ and run them at start up with [upstart](http://upstart.ubuntu.com/)

Thanks,

Enjoy






















